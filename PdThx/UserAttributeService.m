//
//  UserAttributeService.m
//  PdThx
//
//  Created by James Rhodes on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAttributeService.h"

@implementation UserAttributeService

-(void) updateUserAttribute:(NSString*)attributeId withValue:(NSString*) attributeValue forUser:(NSString*) userId
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/attributes/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, attributeId, apiKey]] autorelease];
    
    [rootUrl release];
    [apiKey release];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          attributeValue, @"AttributeValue",
                          nil];
    
    NSString *newJSON = [data JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod: @"PUT"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(updateUserSettingsDidComplete:)];
    [request setDidFailSelector:@selector(updateUserSettingsDidFail:)];
    
    [request startAsynchronous];
    
}
@end
