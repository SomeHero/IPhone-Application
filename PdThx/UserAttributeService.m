//
//  UserAttributeService.m
//  PdThx
//
//  Created by James Rhodes on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAttributeService.h"

@implementation UserAttributeService

@synthesize userSettingsCompleteProtocol;

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
-(void)updateUserSettingsDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* attributeKey = [jsonDictionary valueForKey: @"AttributeKey"];
    NSString* attributeValue = [jsonDictionary valueForKey: @"AttributeValue"];
    
    [userSettingsCompleteProtocol updateUserSettingsDidComplete: attributeKey withValue: attributeValue];
}
-(void)updateUserSettingsDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];

    [userSettingsCompleteProtocol updateUserSettingsDidFail:message withErrorCode:errorCode];
}

@end
