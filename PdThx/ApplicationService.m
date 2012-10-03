//
//  ApplicationService.m
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApplicationService.h"

@implementation ApplicationService

@synthesize applicationSettingsDidComplete;

-(void) getApplicationSettings:(NSString*) apiKey;
{
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Applications/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getApplicationSettingsDidComplete:)];
    [requestObj setDidFailSelector:@selector(getApplicationSettingsDidFail:)];
    [requestObj startAsynchronous];
}

-(void) getApplicationSettingsDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {

        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        Application* application = [[[Application alloc] initWithDictionary:jsonDictionary] autorelease];
        
        [applicationSettingsDidComplete getApplicationSettingsDidComplete:application];
    }
    else {
        
        NSLog(@"Error Getting Application");
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [applicationSettingsDidComplete getApplicationSettingsDidFail: message withErrorCode: errorCode];
        
    }
    
    
}
-(void) getApplicationSettingsDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Error Getting Application Settings");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [applicationSettingsDidComplete getApplicationSettingsDidFail: message withErrorCode: errorCode];
    
    
}

@end
