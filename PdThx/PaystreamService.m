//
//  PaystreamService.m
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PaystreamService.h"
#import "Environment.h"


@implementation PaystreamService

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

}
-(void) cancelPaymentFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Payment Failed");
}
-(void) acceptRequest:(NSString*) messageId {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/accept_request?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(acceptRequestComplete:)];
    [requestObj setDidFailSelector:@selector(acceptRequestFailed:)];
    [requestObj startAsynchronous];
}
-(void) acceptRequestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Accept Request Complete");
    
}
-(void) acceptRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Accept Request Failed");
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
    NSLog(@"Accept Request Complete");
    
}
-(void) rejectRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Accept Request Failed");
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
    
}
-(void) canelRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Request Complete");
}

@end
