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

@implementation UserService

@synthesize userInformationCompleteDelegate, userSecurityPinCompleteDelegate;
@synthesize personalizeUserCompleteDelegate;

-(id)init {
    self = [super init];
    
    return self;
}

-(void) getUserInformation:(NSString*) userId {
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
    NSString *theJSON = [request responseString];
    
    NSLog ( @"Got user information of %@" , theJSON );
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    User* user = [[[User alloc] initWithDictionary:jsonDictionary] autorelease];
    
    
    [userInformationCompleteDelegate userInformationDidComplete:user];
    
}
-(void) getUserInformationFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Setup User Info Failed");
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
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, apiKey]] autorelease];  
    
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
        
    } else
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
    
    [userSecurityPinCompleteDelegate userSecurityPinDidFail: message];
    
    NSLog(@"Security Pin Failed with Exception");
}

- (void)dealloc
{
    [userInformationCompleteDelegate release];
    [requestObj release];
    
    [super dealloc];
}



@end
