//
//  UserService.m
//  PdThx
//
//  Created by James Rhodes on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserService.h"
#import "User.h"
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "JSON.h"
#import "PdThxAppDelegate.h"
#import "PhoneNumberFormatting.h"

@implementation UserService

@synthesize userInformationCompleteDelegate, userSecurityPinCompleteDelegate, linkFbAccountDelegate;
@synthesize personalizeUserCompleteDelegate, changePasswordCompleteDelegate, forgotPasswordCompleteDelegate;
@synthesize findUserDelegate, findMeCodeDelegate;
@synthesize requestObj;

-(id)init 
{
    self = [super init];
    
    return self;
}

-(void) getUserInformation:(NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getUserInformationComplete:)];
    [requestObj setDidFailSelector:@selector(getUserInformationFailed:)];
    [requestObj startAsynchronous];
}
-(void) getUserInformationComplete:(ASIHTTPRequest *)request
{
    if ( [request responseStatusCode] == 200 )
    {
        //NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
        
        NSString *theJSON = [request responseString];
        
        NSLog(@"GetUserInformationReturned: %@",theJSON);
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:[jsonDictionary objectForKey:@"preferredName"] forKey:@"PdThx_PreferredName"];
        [userDefaults synchronize];
        
        User* user = [[[User alloc] initWithDictionary:jsonDictionary] autorelease];
        
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate setUser:[user copy]];
        
        NSLog(@"USER INFO COMPLETE DELEGATE: %@", userInformationCompleteDelegate);
        [userInformationCompleteDelegate userInformationDidComplete:user];
    } else {
        [userInformationCompleteDelegate userInformationDidFail:@"Timed out?"];
    }
}

-(void) getUserInformationFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSLog(@"Setup User Info Failed");
    
    [userInformationCompleteDelegate userInformationDidFail:@"Timed out?"];
}

-(void)linkFacebookAccount:(NSString*)userId withFacebookId:(NSString*)facebookId withAuthToken:(NSString*)token
{
    NSLog(@"User Service -> Linking facebook");
    
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/link_facebook", myEnvironment.pdthxWebServicesBaseUrl, userId]] autorelease];
    
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              apiKey, @"apiKey",
                              token, @"oAuthToken",
                              facebookId, @"AccountId",
                              nil];
    
    NSString* newJSON = [userData JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(linkFbAccountSuccess:)];
    [requestObj setDidFailSelector:@selector(linkFbAccountFailed:)];
    [requestObj startAsynchronous];
}

-(void) linkFbAccountSuccess: (ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 || [request responseStatusCode] == 201 ) {
        NSLog(@"Linking facebook account success!");
        
        [linkFbAccountDelegate linkFbAccountDidSucceed];
        
    } else
    {
        NSLog(@"%@", [request responseStatusMessage]);
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        // NSString* message = [[jsonDictionary valueForKey: @"errorResponse"] copy];
        
        [linkFbAccountDelegate linkFbAccountDidFail: @"Failed to Link Facebook"];
        
        NSLog(@"Linking FB Account Error Code %d", [request responseStatusCode]);
    }
}
-(void) linkFbAccountFailed:(ASIHTTPRequest *)request
{
    NSString* message = [NSString stringWithFormat: @"Unable to change link Facebook.  Unhandled Exception"];
    
    [linkFbAccountDelegate linkFbAccountDidFail: message];
    
    NSLog(@"Facebook linking Failed with Exception");
}


-(void) setupSecurityPin:(NSString*) userId WithPin: (NSString*) securityPin {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, apiKey]] autorelease];  
    
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              securityPin, @"securityPin",
                              nil];
    
    NSString* newJSON = [userData JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(setSecurityPinComplete:)];
    [requestObj setDidFailSelector:@selector(setSecurityPinFailed:)];
    [requestObj startAsynchronous];
}

-(void) changeSecurityPin: (NSString*) userId WithOld:(NSString*) oldSecurityPin AndNew:(NSString*) newSecurityPin {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/change_securitypin", myEnvironment.pdthxWebServicesBaseUrl, userId]] autorelease];
    
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              oldSecurityPin, @"currentSecurityPin",
                              newSecurityPin, @"newSecurityPin",
                              nil];
    
    NSString* newJSON = [userData JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(setSecurityPinComplete:)];
    [requestObj setDidFailSelector:@selector(setSecurityPinFailed:)];
    [requestObj startAsynchronous];
}

-(void) setSecurityPinComplete: (ASIHTTPRequest *)request {
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        NSLog(@"Changing security pin worked!");
        
        [userSecurityPinCompleteDelegate userSecurityPinDidComplete];
        
    } else
    {
        NSLog(@"%@", [request responseStatusMessage]);
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* message = [[jsonDictionary valueForKey: @"errorResponse"] copy];
        
        [userSecurityPinCompleteDelegate userSecurityPinDidFail: message];
        
        NSLog(@"Security Pin Failed, Error Code %d", [request responseStatusCode]);
    }
}
-(void) setupSecurityPinFailed:(ASIHTTPRequest *)request
{
    NSString* message = [NSString stringWithFormat: @"Unable to change security pin.  Unhandled Exception"];
    
    [userSecurityPinCompleteDelegate userSecurityPinDidFail: message];
    
    NSLog(@"Security Pin Failed with Exception");
}

-(void) personalizeUser:(NSString*) userId WithFirstName: (NSString*) firstName withLastName :(NSString*) lastName withImage: (NSString*) imageUrl {
    
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/personalize_user?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, apiKey]] autorelease];  
    
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              firstName, @"FirstName",
                              lastName, @"LastName",
                              imageUrl, @"ImageUrl",
                              nil];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:firstName forKey:@"firstName"];
    [prefs setValue:lastName forKey:@"lastName"];
    NSString* newJSON = [userData JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(personalizeUserDidComplete:)];
    [requestObj setDidFailSelector:@selector(personalizeUserDidFail:)];
    [requestObj startAsynchronous];
}
-(void) personalizeUserDidComplete: (ASIHTTPRequest *)request {
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        NSLog(@"Personalize User Complete");
        [personalizeUserCompleteDelegate personalizeUserDidComplete];
    }
    else
    {
        NSLog(@"Personalize User Failed");
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* message = [[jsonDictionary valueForKey: @"errorResponse"] copy];
        
        [personalizeUserCompleteDelegate personalizeUserDidFail: message];
        
        NSLog(@"Security Pin Failed, Error Code %d", [request responseStatusCode]);
    }
}
-(void) personalizeUserDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString* message = [NSString stringWithFormat: [request responseString]];
    
    [personalizeUserCompleteDelegate personalizeUserDidFail: message];
    
    NSLog(@"Security Pin Failed with Exception");
}

-(void) changePasswordFor: (NSString*) userId WithOld: (NSString*) oldPassword AndNew:(NSString*) newPassword 
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/change_password", myEnvironment.pdthxWebServicesBaseUrl, userId]] autorelease];  
    
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              oldPassword, @"currentPassword",
                              newPassword, @"newPassword",
                              nil];
    
    NSString* newJSON = [userData JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(changePasswordComplete:)];
    [requestObj setDidFailSelector:@selector(changePasswordFailed:)];
    [requestObj startAsynchronous];
}

-(void) changePasswordComplete: (ASIHTTPRequest *)request {
    if([request responseStatusCode] == 200 ) {
        NSLog(@"Changing password worked!");
        
        [changePasswordCompleteDelegate changePasswordSuccess];
        
    } else
    {
        NSLog(@"%@", [request responseStatusMessage]);
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* message = [[jsonDictionary valueForKey: @"errorResponse"] copy];
        
        [changePasswordCompleteDelegate changePasswordDidFail:message];
        
        NSLog(@"Password Change Failed, Error Code %d", [request responseStatusCode]);
    }
}

-(void) changePasswordFailed:(ASIHTTPRequest *)request
{
    NSString* message = [NSString stringWithFormat: @"Unable to change password.  Unhandled Exception"];
    
    [changePasswordCompleteDelegate changePasswordDidFail:message];
    
    NSLog(@"Password change failed with Exception");
}

-(void) forgotPasswordFor:(NSString *)emailAddress
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/reset_password", myEnvironment.pdthxWebServicesBaseUrl]] autorelease];  
    
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              emailAddress, @"emailAddress",
                              nil];
    
    NSString* newJSON = [userData JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(forgotPasswordComplete:)];
    [requestObj setDidFailSelector:@selector(forgotPasswordFailed:)];
    [requestObj startAsynchronous];
}

-(void) forgotPasswordComplete: (ASIHTTPRequest*) request
{
    if([request responseStatusCode] == 200 ) {
        NSLog(@"Forgot password worked!");
        
        [forgotPasswordCompleteDelegate forgotPasswordDidComplete];
        
    } else
    {
        NSLog(@"%@", [request responseString]);
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* message = [[jsonDictionary valueForKey: @"errorResponse"] copy];
        
        [forgotPasswordCompleteDelegate forgotPasswordDidFail:[request responseStatusMessage]];
        
        NSLog(@"Password Change Failed, Error Code %d", [request responseStatusCode]);
        NSLog(@"Error: %@", [request error]);
    }
}

-(void) forgotPasswordFailed: (ASIHTTPRequest*) request
{
    NSString* message = [NSString stringWithFormat: @"Unable to change password.  Unhandled Exception"];
    
    [forgotPasswordCompleteDelegate forgotPasswordDidFail:message];
    
    NSLog(@"Password change failed with Exception");
}


/*  Home Screen Update  */

-(void) refreshHomeScreenInformation:(NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/refresh_homepage", myEnvironment.pdthxWebServicesBaseUrl, userId]] autorelease];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj setRequestMethod: @"GET"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(refreshHomeScreenInformationComplete:)];
    [requestObj setDidFailSelector:@selector(refreshHomeScreenInformationFailed:)];
    [requestObj startAsynchronous];
}

-(void) refreshHomeScreenInformationComplete:(ASIHTTPRequest *)request
{
    if ( [request responseStatusCode] == 200 ){
        NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[jsonDictionary valueForKey:@"numberOfIncomingNotifications"] forKey:@"IncomingNotificationCount"];
        [defaults setValue:[jsonDictionary valueForKey:@"numberOfOutgoingNotifications"] forKey:@"OutgoingNotificationCount"];
        
        [defaults synchronize];
        
        /*
         -(void)userHomeScreenInformationDidComplete:(User*)user;
         -(void)userHomeScreenInformationDidFail:(NSString*) message;
         */
        [userInformationCompleteDelegate userHomeScreenInformationDidComplete:[jsonDictionary objectForKey:@"quickSendContacts"]];
    } else {
        NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    }
    
    
}
-(void) refreshHomeScreenInformationFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSLog(@"Refresh Homescreen Failed");
    
}

- (void)dealloc
{
    [userInformationCompleteDelegate release];
    [requestObj release];
    
    [super dealloc];
}

-(Contact*)findContactByPhoneNumber:(NSString*)phoneNumber
{
    PhoneNumberFormatting*formatter = [[PhoneNumberFormatting alloc] init];
    NSString* formattedNumber = [formatter stringToFormattedPhoneNumber:phoneNumber];
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    for ( NSMutableArray*alphaArray in appDelegate.phoneContacts )
    {
        for ( Contact*con in alphaArray )
        {
            for ( NSString* point in con.paypoints )
            {
                if ( [point isEqualToString:formattedNumber] )
                {
                    NSLog(@"Found contact [%@] for [%@]",con.name,phoneNumber);
                    return con;
                }
            }
        }
    }
    
    return NULL;
}

-(void) findMeCodesMatchingSearchTerm:(NSString*) searchTerm
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/find_mecodes", myEnvironment.pdthxWebServicesBaseUrl, searchTerm]] autorelease];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj setRequestMethod: @"GET"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(findMeCodesMatchingSearchTermComplete:)];
    [requestObj setDidFailSelector:@selector(findMeCodesMatchingSearchTermFailed:)];
    [requestObj startAsynchronous];
}

-(void) findMeCodesMatchingSearchTermComplete:(ASIHTTPRequest *)request
{
    if ( [request responseStatusCode] == 200 ){
        NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSMutableArray*meCodeArray = [jsonDictionary objectForKey:@"foundUsers"];
        NSString*searchTerm = [jsonDictionary objectForKey:@"searchTerm"];
        
        [findMeCodeDelegate foundMeCodes:meCodeArray matchingSearchTerm:searchTerm];
    } else {
        NSLog(@"Response NOT OKAY %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    }
}

-(void) findMeCodesMatchingSearchTermFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSLog(@"Find me Codes Failed");
}

@end
