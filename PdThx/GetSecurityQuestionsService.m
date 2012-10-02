//
//  GetSecurityQuestionsService.m
//  PdThx
//
//  Created by James Rhodes on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetSecurityQuestionsService.h"
#import "Environment.h"
#import "SBJsonParser.h"
#import "JSON.h"

@implementation GetSecurityQuestionsService

@synthesize questionsLoadedDelegate;

-(id)init {
    self = [super init];
    
    return self;
}

- (void)dealloc
{
    [requestObj release];
    
    [super dealloc];
}

-(void)getSecurityQuestions:(bool)onlyActive
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/securityquestions?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setRequestMethod: @"GET"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getSecurityQuestionsComplete:)];
    [request setDidFailSelector:@selector(getSecurityQuestionsFailed:)];
    
    [request startAsynchronous];
}

-(void) getSecurityQuestionsComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *tempArray = [[parser objectWithString:theJSON] copy];
        
        NSMutableArray* TempQuestions = [[[NSMutableArray alloc] initWithArray:tempArray] mutableCopy];
        
        [questionsLoadedDelegate loadedSecurityQuestions:TempQuestions];
        
        [parser release];
        
        
        NSLog(@"Security Questions Loaded");
    }
    else {
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        NSLog(@"Error Getting Security Questions");
    }
}
-(void) getSecurityQuestionsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    
    NSLog(@"Error Getting Security Questions");
}

@end
