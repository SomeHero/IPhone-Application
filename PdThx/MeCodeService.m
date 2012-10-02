//
//  MeCodeService.m
//  PdThx
//
//  Created by Justin Cheng on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeCodeService.h"
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "JSON.h"


@implementation MeCodeService
@synthesize MeCodeCreateCompleteDelegate;

-(void) validateMeCode:(NSString*)userId withMeCode: (NSString *)meCode
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/mecodes?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, apiKey]] autorelease];  
    
    NSDictionary *meCodeData = [NSDictionary dictionaryWithObjectsAndKeys:
                              meCode, @"MeCode",
                              nil];
    
    NSString *newJSON = [meCodeData JSONRepresentation];
    
    requestObj= [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate:self];
    [requestObj setDidFinishSelector:@selector(validateMeCodeComplete:)];
    [requestObj setDidFailSelector:@selector(validateMeCodeFailed:)];
    
    [requestObj startAsynchronous];
}

-(void) validateMeCodeComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 201 ) {
        NSLog(@"MeCode Creation Success!");
        
        [MeCodeCreateCompleteDelegate meCodeCreateSuccess];
        
    } else
    {
        NSLog(@"%@", [request responseStatusMessage]);
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [MeCodeCreateCompleteDelegate meCodeCreateDidFail: message withErrorCode:errorCode];
        
        NSLog(@"User Registration Failed, Error Code %d, ReasonPhrase: %@", [request responseStatusCode], message);
    }
}
-(void) validateMeCodeFailed:(ASIHTTPRequest *)request
{
    NSLog(@"MeCode Creation failed with Exception");
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [MeCodeCreateCompleteDelegate meCodeCreateDidFail: message withErrorCode:errorCode];
    
}
@end
