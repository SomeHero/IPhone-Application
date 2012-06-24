//
//  GetPayStreamService.m
//  PdThx
//
//  Created by James Rhodes on 5/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GetPayStreamService.h"
#import "Environment.h"
#import "SBJsonParser.h"
#import "JSON.h"
#import "PaystreamMessage.h"

@implementation GetPayStreamService

@synthesize getPayStreamCompleteDelegate;

-(id)init {
    self = [super init];
    
    return self;
}
- (void)dealloc
{
    [requestObj release];
    
    [super dealloc];
}
-(void)getPayStream:(NSString*) userId {
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [NSString stringWithFormat:@"/%@/PayStreamMessages", userId];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, rootUrl, apiKey]] autorelease];  

    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setRequestMethod: @"GET"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(getPayStreamComplete:)];
    [request setDidFailSelector:@selector(getPayStreamFailed:)];
    
    [request startAsynchronous];
}
-(void) getPayStreamComplete:(ASIHTTPRequest *)request
{
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        //[self.scrollView scrollsToTop];
        //[securityPinModalPanel hide];
        
        //[txtRecipientUri setText: @""];
        //[txtAmount setText: @"$0.00"];
        //[txtComments setText: @""];
        
        //[[self scrollView] setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        //[self showAlertView:@"Money Sent!" withMessage: message];
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];

        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *tempArray = [[parser objectWithString:theJSON] copy];
        
        NSMutableArray* tempTransactions = [[[NSMutableArray alloc] initWithArray:tempArray] copy];
        
        NSMutableArray* transactions = [[NSMutableArray alloc] init];

        for(int i = 0; i <[tempTransactions count]; i++)
        {
            [transactions addObject: [[[PaystreamMessage alloc] initWithDictionary: [tempTransactions objectAtIndex:(NSUInteger) i]] autorelease]];
        }

        [parser release];
        
        [getPayStreamCompleteDelegate getPayStreamDidComplete:transactions];
        
        NSLog(@"Money Sent");
        
    }
    else {
        NSLog(@"Error Sending Money");
    }
    
}
-(void) getPayStreamFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSLog(@"Send Money Failed");
}


@end
