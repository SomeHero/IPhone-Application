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

-(void)getNonProfits
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Merchants?type=NonProfits&apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getNonProfitsComplete:)];
    [requestObj setDidFailSelector:@selector(getNonProfitsFailed:)];
    [requestObj startAsynchronous];
    
}
-(void) getNonProfitsComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if ( [request responseStatusCode] == 200 ){
       
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
        
        [merchantServicesCompleteProtocol getNonProfitsDidComplete:merchants];
        
        NSLog(@"Got the NonProfits");
        
    } else {
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [merchantServicesCompleteProtocol getNonProfitsDidFail: message withErrorCode: errorCode];
    }
    
    
}
-(void) getNonProfitsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [merchantServicesCompleteProtocol getNonProfitsDidFail: message withErrorCode: errorCode];
}
-(void)getOrganizations
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Merchants?type=Organizations&apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getOrganizationsComplete:)];
    [requestObj setDidFailSelector:@selector(getOrganizationsFailed:)];
    [requestObj startAsynchronous];
    
}
-(void) getOrganizationsComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if ( [request responseStatusCode] == 200 ){
       
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
        
        [merchantServicesCompleteProtocol getOrganizationsDidComplete:merchants];
        
        
    } else {
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [merchantServicesCompleteProtocol getOrganizationsDidFail: message withErrorCode: errorCode];
    }
    
    
}
-(void) getOrganizationsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [merchantServicesCompleteProtocol getOrganizationsDidFail: message withErrorCode: errorCode];
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
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [merchantServicesCompleteProtocol getNonProfitDetailDidFail: message withErrorCode: errorCode];
    }
    
    
}
-(void) getMerchantDetailFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [merchantServicesCompleteProtocol getNonProfitDetailDidFail: message withErrorCode: errorCode];
}

@end