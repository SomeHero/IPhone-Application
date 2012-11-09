//
//  UserConfigurationService.m
//  PdThx
//
//  Created by James Rhodes on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserConfigurationService.h"

@implementation UserConfigurationService

@synthesize userConfigurationCompleteDelegate;

-(void) getUserSettings:(NSString*) userId;
{
    Environment *myEnvironment = [Environment sharedInstance];

    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/Configurations?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, myEnvironment.pdthxAPIKey]] autorelease];

    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    request = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [request setRequestMethod: @"GET"];	
    
    [request setDelegate: self];
    [request setDidFinishSelector:@selector(getUserSettingsDidComplete:)];
    [request setDidFailSelector:@selector(getUserSettingsDidFail:)];
    [request startAsynchronous];
}

-(void) getUserSettingsDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSArray *tempArray = [[parser objectWithString:theJSON] copy];
        
        NSMutableArray* userConfigurationItems = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[tempArray count]; i++)
        {
            [userConfigurationItems addObject: [[[UserConfiguration alloc] initWithDictionary: [tempArray objectAtIndex:(NSUInteger) i]] autorelease]];
        }
        [parser release];
                
        [userConfigurationCompleteDelegate getUserConfigurationDidComplete:userConfigurationItems];
    }
    else {
        
        NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [userConfigurationCompleteDelegate getUserConfigurationDidFail:message withErrorCode: errorCode];
        
    }
    
    
}
-(void) getUserSettingsDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [userConfigurationCompleteDelegate getUserConfigurationDidFail:  message withErrorCode: errorCode];
    
}
-(void)updateUserConfiguration:(NSString*)configurationValue forKey:(NSString*) configurationKey forUserId:(NSString *)userId;
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/Configurations?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, apiKey]] autorelease];
    
    [rootUrl release];
    [apiKey release];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          configurationKey, @"Key",
                          configurationValue, @"Value",
                          nil];
    
    NSString *newJSON = [data JSONRepresentation];
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod: @"PUT"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(updateUserConfigurationDidComplete:)];
    [request setDidFailSelector:@selector(updateUserConfigurationDidFail:)];
    
    [request startAsynchronous];
}
-(void)updateUserConfigurationDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* configurationKey = [jsonDictionary valueForKey: @"Key"];
    NSString* configurationValue = [jsonDictionary valueForKey: @"Value"];
    
    [userConfigurationCompleteDelegate updateUserConfigurationDidComplete:configurationKey withValue:configurationValue];
}
-(void)updateUserConfigurationDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [userConfigurationCompleteDelegate updateUserConfigurationDidFail: message withErrorCode: errorCode];
}


@end
