//
//  UserService.m
//  PdThx
//
//  Created by James Rhodes on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserService.h"
#import "User.h"
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"

@implementation UserService

@synthesize userInformationCompleteDelegate;

-(id)init {
    self = [super init];
    
    return self;
}

-(void) getUserInformation:(NSString*) userId {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getUserInformationComplete:)];
    [requestObj setDidFailSelector:@selector(getUserInformationFailed:)];
    [requestObj startAsynchronous];
}
-(void) getUserInformationComplete:(ASIHTTPRequest *)request
{
    NSString *theJSON = [request responseString];
    
    NSLog ( @"Got user information of %@" , theJSON );
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    User* user = [[[User alloc] initWithDictionary:jsonDictionary] autorelease];
    
    
    [userInformationCompleteDelegate userInformationDidComplete:user];

}
-(void) getUserInformationFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Setup Password Failed");
}
- (void)dealloc
{
    [userInformationCompleteDelegate release];
    [requestObj release];

    [super dealloc];
}



@end
