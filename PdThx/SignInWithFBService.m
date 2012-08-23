//
//  SignInWithFBService.m
//  PdThx
//
//  Created by James Rhodes on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignInWithFBService.h"
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "PdThxAppDelegate.h"
#import "JSON.h"

@implementation SignInWithFBService

@synthesize  fbSignInCompleteDelegate;

-(void) validateUser:(NSDictionary*)response
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/signin_withfacebook?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];
    
    NSString* oAuthToken = [NSString stringWithFormat:[prefs objectForKey:@"FBAccessTokenKey"]];
    
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              apiKey , @"apiKey",
                              [response objectForKey:@"id"], @"accountId",
                              [response objectForKey:@"first_name"], @"firstName",
                              [response objectForKey:@"last_name"], @"lastName",
                              [response objectForKey:@"email"], @"emailAddress",
                              oAuthToken, @"oAuthToken",
                              nil];
    
    [prefs setValue:[response valueForKey:@"first_name"] forKey:@"firstName"];
    [prefs setValue:[response valueForKey:@"last_name"] forKey:@"lastName"];
    [prefs setValue:[response valueForKey:@"id"] forKey:@"facebookId"];
    
    [prefs synchronize];
    
    NSString * newJSON = [userData JSONRepresentation];
    
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
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 || [request responseStatusCode] == 201 ) {
        NSLog(@"User Validation Success");
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        BOOL hasBankAccount = [[jsonDictionary objectForKey:@"hasACHAccount"] boolValue];
        BOOL hasSecurityPin = [[jsonDictionary objectForKey:@"hasSecurityPin"] boolValue];
        NSString* userId = [jsonDictionary valueForKey:@"userId"];
        NSString* mobileNumber = [jsonDictionary valueForKey: @"mobileNumber"];
        NSString* paymentAccountId = [jsonDictionary valueForKey: @"paymentAccountId"];
        
        bool isNewUser = NO;
        if([request responseStatusCode] == 201)
            isNewUser = YES;
        
        [fbSignInCompleteDelegate fbSignInDidComplete:hasBankAccount withSecurityPin:hasSecurityPin withUserId:userId withPaymentAccountId:paymentAccountId withMobileNumber:mobileNumber isNewUser:isNewUser];     
    } else {
        NSLog(@"User Validation Failed");
        
        NSString* response = [NSString stringWithString: @"Unable to validate user.  Try again."];
        
        [fbSignInCompleteDelegate fbSignInDidFail:response];
    }
    
}

-(void) validateUserFailed:(ASIHTTPRequest *)request
{
    NSLog(@"User Validation Failed with Exception");
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString* response = [NSString stringWithString: @"Unable to validate user.  Try again."];
    
    [fbSignInCompleteDelegate fbSignInDidFail:response];    
    
}
- (void)dealloc
{
    //[userInformationCompleteDelegate release];
    [requestObj release];
    
    [super dealloc];
}


@end
