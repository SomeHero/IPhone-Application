//
//  SecurityQuestionService.m
//  PdThx
//
//  Created by James Rhodes on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecurityQuestionService.h"

@implementation SecurityQuestionService

@synthesize securityQuestionAnsweredDelegate;

-(void) validateSecurityAnswer: (NSString*) answer forUserId: (NSString*) userId {
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/validate_security_question?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, myEnvironment.pdthxAPIKey]] autorelease];  
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //deviceId, @"deviceId",
                                 answer, @"questionAnswer",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(securityQuestionAnswerDidComplete:)];
    [requestObj setDidFailSelector:@selector(securityQuestionAnsweredDidFail:)];
    [requestObj startAsynchronous];
}
-(void) securityQuestionAnswerDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        [securityQuestionAnsweredDelegate securityQuestionAnsweredDidComplete];
        
    }
    else {
        
        NSLog(@"Error Answered Security Questions");
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [securityQuestionAnsweredDelegate securityQuestionAnsweredDidFail: message withErrorCode:errorCode];
        
    }
    
    
}
-(void) securityQuestionAnsweredDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [securityQuestionAnsweredDelegate securityQuestionAnsweredDidFail: message withErrorCode: errorCode];
}

@end
