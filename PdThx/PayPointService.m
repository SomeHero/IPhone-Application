//
//  PayPointService.m
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PayPointService.h"

@implementation PayPointService

@synthesize getPayPointsDelegate;
@synthesize addPayPointCompleteDelegate;
@synthesize payPointVerificationCompleteDelegate;
@synthesize deletePayPointCompleteDelegate;
@synthesize verifyMobilePayPointDelegate;
@synthesize resendVerificationLinkDelegate;

-(void) getPayPoints:(NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, myEnvironment.pdthxAPIKey]] autorelease];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getPayPointsCompleted:)];
    [requestObj setDidFailSelector:@selector(getPayPointsFailed:)];
    [requestObj startAsynchronous];
}

-(void) getPayPoints:(NSString*) userId ofType: (NSString*) type 
{
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints?type=%@&apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, type, myEnvironment.pdthxAPIKey]] autorelease];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getPayPointsCompleted:)];
    [requestObj setDidFailSelector:@selector(getPayPointsFailed:)];
    [requestObj startAsynchronous];
}
-(void) getPayPointsCompleted:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *tempArray = [[parser objectWithString:theJSON] copy];
        
        NSMutableArray* tempPayPoints = [[[NSMutableArray alloc] initWithArray:tempArray] copy];
        
        NSMutableArray* payPoints = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[tempPayPoints count]; i++)
        {
            [payPoints addObject: [[[PayPoint alloc] initWithDictionary: [tempPayPoints objectAtIndex:(NSUInteger) i]] autorelease]];
        }
        
        [parser release];
        
        [getPayPointsDelegate getPayPointsDidComplete: payPoints];
        
    }
    else {
        
        NSLog(@"Error Getting Pay Points");
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [getPayPointsDelegate getPayPointsDidFail: message withErrorCode:errorCode];

    }
    
    
}
-(void) getPayPointsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [getPayPointsDelegate getPayPointsDidFail: message withErrorCode: errorCode];

}
-(void) deletePayPoint: (NSString*)payPointId forUserId: (NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints/%@?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, payPointId, myEnvironment.pdthxAPIKey]] autorelease];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"DELETE"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(deletePayPointCompleted:)];
    [requestObj setDidFailSelector:@selector(deletePayPointFailed:)];
    [requestObj startAsynchronous];
}
-(void) deletePayPointCompleted:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        [deletePayPointCompleteDelegate  deletePayPointCompleted];
        
    }
    else {
        
        NSLog(@"Error Answered Security Questions");
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [deletePayPointCompleteDelegate deletePayPointFailed: message withErrorCode: errorCode];
    }
    
    
}
-(void) deletePayPointFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Answering Security Questions");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
   [deletePayPointCompleteDelegate deletePayPointFailed: message withErrorCode: errorCode];
}
-(void) addPayPoint:(NSString *) uri ofType: (NSString*) type forUserId: (NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, apiKey]] autorelease];
    
    [rootUrl release];
    [apiKey release];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                 uri, @"Uri",
                                 type, @"PayPointType",
                                 nil];
    
    NSString *newJSON = [data JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(addPayPointCompleted:)];
    [request setDidFailSelector:@selector(addPayPointFailed:)];
    
    [request startAsynchronous];
}
-(void) addPayPointCompleted:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 201 ) {
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSString *theJSON = [request responseString];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString* payPointId = [[jsonDictionary valueForKey: @"Id"] copy];
        
        [addPayPointCompleteDelegate addPayPointsDidComplete:payPointId];
        
    }
    else {
        
        NSLog(@"Error Answered Security Questions");
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [addPayPointCompleteDelegate addPayPointsDidFail: message withErrorCode: errorCode];
        
    }
    
    
}
-(void) addPayPointFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [addPayPointCompleteDelegate addPayPointsDidFail: message withErrorCode: errorCode];
    
}
-(void) resendEmailVerificationLink:(NSString*)payPointId forUserId:(NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints/resend_email_verification_link?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, apiKey]] autorelease];
    
    [rootUrl release];
    [apiKey release];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          payPointId, @"UserPayPointId",
                          nil];
    
    NSString *newJSON = [data JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(resendVerificationLinkCompleted:)];
    [request setDidFailSelector:@selector(resendVerificationLinkFailed:)];
    
    [request startAsynchronous];
}
-(void) resendVerificationLinkCompleted:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        
        [resendVerificationLinkDelegate resendVerificationLinkDidComplete];
        
    }
    else {
        
        NSLog(@"Error Answered Security Questions");
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [resendVerificationLinkDelegate resendVerificationLinkDidFail: message withErrorCode: errorCode];
        
    }
    
    
}
-(void) resendVerificationLinkCompletedFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [resendVerificationLinkDelegate resendVerificationLinkDidFail: message withErrorCode: errorCode];
    
}
-(void) resendMobileVerificationCode:(NSString*)payPointId forUserId:(NSString*) userId {
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints/resend_mobile_verification_code?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, apiKey]] autorelease];
    
    [rootUrl release];
    [apiKey release];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          payPointId, @"UserPayPointId",
                          nil];
    
    NSString *newJSON = [data JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(resendMobileVerificationCodeCompleted:)];
    [request setDidFailSelector:@selector(resendMobileVerificationCodeFailed:)];
    
    [request startAsynchronous];
}
-(void) resendMobileVerificationCodeCompleted:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        
        [payPointVerificationCompleteDelegate payPointWasVerifiedComplete];
        
    }
    else {
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [payPointVerificationCompleteDelegate payPointWasVerifiedFailed: message withErrorCode: errorCode];
    }
}
-(void) resendMobileVerificationCodeFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Answering Security Questions");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [payPointVerificationCompleteDelegate payPointWasVerifiedFailed: message withErrorCode: errorCode];
    
}
-(void) verifyMobilePayPoint: (NSString*)verificationCode forPayPointId:(NSString*)payPointId forUserId:(NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints/%@/verify_mobile_paypoint?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, payPointId, apiKey]] autorelease];
    
    [rootUrl release];
    [apiKey release];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          verificationCode, @"VerificationCode",
                          nil];
    
    NSString *newJSON = [data JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(verifyMobilePayPointDidComplete:)];
    [request setDidFailSelector:@selector(verifyMobilePayPointDidFail:)];
    
    [request startAsynchronous];
}
-(void) verifyMobilePayPointDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        BOOL verified = [[jsonDictionary objectForKey:@"Verified"] boolValue];
        
        [verifyMobilePayPointDelegate verifyMobilePayPointDidComplete:verified];

    }
    else {
        
        NSLog(@"Verify Mobile Pay Point Failed");
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [verifyMobilePayPointDelegate verifyMobilePayPointDidFail: message withErrorCode: errorCode];
    }
}
-(void) verifyMobilePayPointDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [verifyMobilePayPointDelegate verifyMobilePayPointDidFail: message withErrorCode:errorCode];
    
}
@end
