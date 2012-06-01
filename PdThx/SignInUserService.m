//
//  SignInUserService.m
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SignInUserService.h"
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "JSON.h"

@implementation SignInUserService

@synthesize userSignInCompleteDelegate;

-(void) validateUser:(NSString*) userName withPassword:(NSString*) password
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/validate_user?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];  
    
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              userName, @"userName",
                              password, @"password",
                              nil];
    
    NSString *newJSON = [userData JSONRepresentation];
    
    requestObj= [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate:self];
    [requestObj setDidFinishSelector:@selector(validateUserComplete:)];
    [requestObj setDidFailSelector:@selector(validateUserFailed:)];
    
    [requestObj startAsynchronous];
}
-(void) validateUserComplete:(ASIHTTPRequest *)request
{
    if([request responseStatusCode] == 200 ) {
        NSLog(@"User Validation Success");
        
        NSString *theJSON = [request responseString];
    
        SBJsonParser *parser = [[SBJsonParser alloc] init];
    
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
    
<<<<<<< HEAD
=======
        BOOL hasBankAccount = [[jsonDictionary objectForKey:@"hasACHAccount"] boolValue];
        BOOL hasSecurityPin = [[jsonDictionary objectForKey:@"hasSecurityPin"] boolValue];
>>>>>>> origin/web-api-chris
        NSString* userId = [jsonDictionary valueForKey:@"userId"];
        NSString* mobileNumber = [jsonDictionary valueForKey: @"mobileNumber"];
        NSString* paymentAccountId = [jsonDictionary valueForKey: @"paymentAccountId"];
        
<<<<<<< HEAD
        [userSignInCompleteDelegate userSignInDidComplete:userId withPaymentAccountId:paymentAccountId withMobileNumber:mobileNumber];
=======
        [userSignInCompleteDelegate userSignInDidComplete:hasBankAccount withSecurityPin:hasSecurityPin withUserId:userId withPaymentAccountId:paymentAccountId withMobileNumber:mobileNumber];
>>>>>>> origin/web-api-chris
        
    } else
    {
        NSLog(@"User Validation Failed");
        
        NSString* response = [NSString stringWithString: @"Unable to validate user.  Try again."];
        
        [userSignInCompleteDelegate userSignInDidFail:response];
         
    }
    
}
-(void) validateUserFailed:(ASIHTTPRequest *)request
{
    NSLog(@"User Validation Failed with Exception");
    
    NSString* response = [NSString stringWithString: @"Unable to validate user.  Try again."];
    
    [userSignInCompleteDelegate userSignInDidFail: response];
    
}
- (void)dealloc
{
    //[userInformationCompleteDelegate release];
    [requestObj release];
    
    [super dealloc];
}

@end
