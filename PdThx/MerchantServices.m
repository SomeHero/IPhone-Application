//
//  MerchantServices.m
//  PdThx
//
//  Created by James Rhodes on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MerchantServices.h"

@implementation MerchantServices

@synthesize merchantServicesCompleteProtocol;

-(void)getMerchants 
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Merchants?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getMerchantsComplete:)];
    [requestObj setDidFailSelector:@selector(getMerchantsFailed:)];
    [requestObj startAsynchronous];
    
}
-(void) getMerchantsComplete:(ASIHTTPRequest *)request
{
    if ( [request responseStatusCode] == 200 ){
        NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
        
        NSString *theJSON = [request responseString];
        
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *tempArray = [[parser objectWithString:theJSON] copy];
        
        NSMutableArray* tempMerchants = [[[NSMutableArray alloc] initWithArray:tempArray] copy];
        
        NSMutableArray* merchants = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[tempMerchants count]; i++)
        {
            [merchants addObject: [[[Merchant alloc] initWithDictionary: [tempMerchants objectAtIndex:(NSUInteger) i]] autorelease]];
        }
        
        [parser release];
        
        [merchantServicesCompleteProtocol getMerchantsDidComplete:merchants];
        
        NSLog(@"Got the Merchantw");
        
    } else {
        [merchantServicesCompleteProtocol getMerchantsDidFail: [request responseString]];
    }
    
    
}
-(void) getMerchantsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSLog(@"GetMerchants Failed");
    
    [merchantServicesCompleteProtocol getMerchantsDidFail: [request responseString]];
}
-(void)getNonProfitDetail:(NSString*) merchantId {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Merchants/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, merchantId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getMerchantDetailComplete:)];
    [requestObj setDidFailSelector:@selector(getMerchantDetailFailed:)];
    [requestObj startAsynchronous];
    
}
-(void) getMerchantDetailComplete:(ASIHTTPRequest *)request
{
    if ( [request responseStatusCode] == 200 ){
        NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
        
        NSString *theJSON = [request responseString];
        
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        NonProfitDetail* merchant = [[[NonProfitDetail alloc] initWithDictionary:jsonDictionary] autorelease];
        
        [parser release];
        
        [merchantServicesCompleteProtocol getNonProfitDetailDidComplete:merchant];
        
        NSLog(@"Got the Merchantw");
        
    } else {
        [merchantServicesCompleteProtocol getNonProfitDetailDidFail: [request responseString]];
    }
    
    
}
-(void) getMerchantDetailFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSLog(@"GetMerchants Failed");
    
    [merchantServicesCompleteProtocol getNonProfitDetailDidFail: [request responseString]];
}

@end