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
    [requestObj setDidFailSelector:@selector(deletePayPointsFailed:)];
    [requestObj startAsynchronous];
}
-(void) deletePayPointsCompleted:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        
    }
    else {
        
        NSLog(@"Error Answered Security Questions");
        
        
        
    }
    
    
}
-(void) deletePayPointsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Answering Security Questions");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    
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
-(void) addPayPointsCompleted:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 201 ) {
        
        
    }
    else {
        
        NSLog(@"Error Answered Security Questions");
        
        
        
    }
    
    
}
-(void) addPayPointsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Answering Security Questions");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    
}
@end
