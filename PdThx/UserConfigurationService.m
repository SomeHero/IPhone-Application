//
//  UserConfigurationService.m
//  PdThx
//
//  Created by James Rhodes on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserConfigurationService.h"

@implementation UserConfigurationService

-(void)updateUserConfiguration:(NSString*)configurationValue forKey:(NSString*) configurationKey forUserId:(NSString *)userId;
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/Configurations?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, apiKey]] autorelease];
    
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
    [request setDidFinishSelector:@selector(updateConfigurationItemsComplete:)];
    [request setDidFailSelector:@selector(updateConfigurationItemsComplete:)];
    
    [request startAsynchronous];
}

@end
