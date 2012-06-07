//
//  RegisterUserService.m
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterUserService.h"
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "JSON.h"

@implementation RegisterUserService

@synthesize userRegistrationCompleteDelegate;

-(void) registerUser:(NSString *) newUserName withPassword:(NSString *) newPassword withMobileNumber:(NSString *) newMobileNumber withSecurityPin : (NSString *) newSecurityPin withDeviceId:(NSString*) deviceId
{
    NSLog(@"Passed deviceToken into registerUser of string: %@" , deviceId);
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSString *rootUrl = myEnvironment.pdthxWebServicesBaseUrl;
    NSString *apiKey = myEnvironment.pdthxAPIKey;
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];

    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              apiKey, @"apiKey",
                              newUserName, @"userName",
                              newPassword, @"password",
                              newUserName, @"emailAddress",
                              deviceId, @"deviceToken",
                              nil];
    
    NSString *newJSON = [userData JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];
    
    [requestObj setDelegate:self];
    [requestObj setDidFinishSelector:@selector(registerUserComplete:)];
    [requestObj setDidFailSelector:@selector(registerUserFailed:)];
    
    [requestObj startAsynchronous];
}
-(void) registerUserComplete:(ASIHTTPRequest *)request
{
    if([request responseStatusCode] == 201 ) {
        NSLog(@"User Registration Success");
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* userId = [[jsonDictionary valueForKey:@"userId"] copy];
        NSString* mobileNumber = [[jsonDictionary valueForKey:@"mobileNumber"] copy];
        
        [userRegistrationCompleteDelegate userRegistrationDidComplete:userId withSenderUri:mobileNumber];
        
    } else
    {
        NSLog(@"%@", [request responseStatusMessage]);
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* message = [[jsonDictionary valueForKey: @"errorResponse"] copy];
        
        [userRegistrationCompleteDelegate userRegistrationDidFail: message];
        
        NSLog(@"User Registration Failed, Error Code %d", [request responseStatusCode]);
    }

}
-(void) registerUserFailed:(ASIHTTPRequest *)request
{
    NSString* message = [NSString stringWithFormat: @"Unable to add user.  Unhandled Exception"];
    
    [userRegistrationCompleteDelegate userRegistrationDidFail: message];
    
    NSLog(@"Register User Failed with Exception");
}

@end
