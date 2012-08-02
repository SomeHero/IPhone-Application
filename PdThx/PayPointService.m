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

-(void) getPayPoints:(NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, myEnvironment.pdthxAPIKey]] autorelease];  
    
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
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints?type=%@&apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, type, myEnvironment.pdthxAPIKey]] autorelease];  
    
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
        
        [getPayPointsDelegate getPayPointsDidFail: [request responseStatusMessage]];

    }
    
    
}
-(void) getPayPointsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Getting Pay Points");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [getPayPointsDelegate getPayPointsDidFail: [request responseStatusMessage]];

}
-(void) deletePayPoint: (NSString*)payPointId forUserId: (NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, payPointId, myEnvironment.pdthxAPIKey]] autorelease];  
    
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
        
        [deletePayPointCompleteDelegate deletePayPointFailed: [request responseString]];
    }
    
    
}
-(void) deletePayPointFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Answering Security Questions");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
   [deletePayPointCompleteDelegate deletePayPointFailed: [request responseString]];
}
-(void) addPayPoint:(NSString *) uri ofType: (NSString*) type forUserId: (NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, apiKey]] autorelease];
    
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
        
        [addPayPointCompleteDelegate addPayPointsDidComplete];
        
    }
    else {
        
        NSLog(@"Error Answered Security Questions");
        
        [addPayPointCompleteDelegate addPayPointsDidFail: [request responseString]];
        
    }
    
    
}
-(void) addPayPointFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Answering Security Questions");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [addPayPointCompleteDelegate addPayPointsDidFail: [request responseString]];
    
}
-(void) resendEmailVerificationLink:(NSString*)payPointId forUserId:(NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints/resend_email_verification_link?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, apiKey]] autorelease];
    
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
    
    if([request responseStatusCode] == 202) {
        
        [payPointVerificationCompleteDelegate payPointWasVerifiedComplete];
        
    }
    else {
        
        NSLog(@"Error Answered Security Questions");
        
        [payPointVerificationCompleteDelegate payPointWasVerifiedFailed: [request responseString]];
        
    }
    
    
}
-(void) resendVerificationLinkCompletedFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Answering Security Questions");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [payPointVerificationCompleteDelegate payPointWasVerifiedFailed: [request responseString]];
    
}
-(void) resendMobileVerificationCode:(NSString*)payPointId forUserId:(NSString*) userId {
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PayPoints/resend_mobile_verification_code?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, apiKey]] autorelease];
    
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
        
        NSLog(@"Error Answered Security Questions");
        
        [payPointVerificationCompleteDelegate payPointWasVerifiedFailed: [request responseString]];
    }
}
-(void) resendMobileVerificationCodeFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Answering Security Questions");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [payPointVerificationCompleteDelegate payPointWasVerifiedFailed: [request responseString]];
    
}
@end
