//
//  PaystreamService.m
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PaystreamService.h"
#import "Environment.h"
#import "JSON.h"

@implementation PaystreamService

@synthesize acceptPaymentRequestProtocol;
@synthesize rejectPaymentRequestProtocol;
@synthesize cancePaymentRequestProtocol;
@synthesize cancelPaymentProtocol;

-(void) cancelPayment:(NSString*) messageId {
    
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/cancel_payment?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(cancelPaymentComplete:)];
    [requestObj setDidFailSelector:@selector(cancelPaymentFailed:)];
    [requestObj startAsynchronous];
}
-(void) cancelPaymentComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Payment Complete");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        [cancelPaymentProtocol cancelPaymentDidComplete];
    }
    else {
        [cancelPaymentProtocol cancelPaymentDidFail];
    }

}
-(void) cancelPaymentFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Payment Failed");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [cancelPaymentProtocol cancelPaymentDidFail];
}
-(void) acceptRequest:(NSString*) messageId withUserId: (NSString*) userId fromPaymentAccount : (NSString*) paymentAccountId withSecurityPin : (NSString*) securityPin {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/accept_request?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
    NSDictionary *requestBody = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 userId, @"userId",
                                 paymentAccountId, @"paymentAccountId",
                                 securityPin, @"securityPin",
                                 nil];
    
    
    NSString *newJSON = [requestBody JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(acceptRequestComplete:)];
    [requestObj setDidFailSelector:@selector(acceptRequestFailed:)];
    
    [requestObj startAsynchronous];
}
-(void) acceptRequestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Accept Request Complete");
        
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);

    if([request responseStatusCode] == 200) {
        [acceptPaymentRequestProtocol acceptPaymentRequestDidComplete];
    }
    else {
        [acceptPaymentRequestProtocol acceptPaymentRequestDidFail];
    }
    
}
-(void) acceptRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Accept Request Failed");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [acceptPaymentRequestProtocol acceptPaymentRequestDidFail];
}
-(void) rejectRequest:(NSString*) messageId {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/reject_request?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(rejectRequestComplete:)];
    [requestObj setDidFailSelector:@selector(rejectRequestFailed:)];
    [requestObj startAsynchronous];
}
-(void) rejectRequestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Reject Request Complete");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        [rejectPaymentRequestProtocol rejectPaymentRequestDidComplete];
    }
    else {
        [rejectPaymentRequestProtocol rejectPaymentRequestDidComplete];
    }
    
}
-(void) rejectRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Reject Request Failed");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [rejectPaymentRequestProtocol rejectPaymentRequestDidFail];
}
-(void) cancelRequest:(NSString*) messageId {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/cancel_request?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(cancelRequestComplete:)];
    [requestObj setDidFailSelector:@selector(cancelRequestFailed:)];
    [requestObj startAsynchronous];
}
-(void) cancelRequestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Request Complete");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        [cancePaymentRequestProtocol cancelPaymentRequestDidComplete];
    }
    else {
        [cancePaymentRequestProtocol cancelPaymentRequestDidFail];
    }
    
}
-(void) canelRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Request Failed");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [cancePaymentRequestProtocol cancelPaymentRequestDidFail];
}

@end
