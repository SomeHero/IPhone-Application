//
//  UserSetupACHAccount.m
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserSetupACHAccount.h"
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "JSON.h"

@implementation UserSetupACHAccount

@synthesize userACHSetupCompleteDelegate;

-(id)init {
    self = [super init];
    
    return self;
}
- (void)dealloc
{
    [requestObj release];
    
    [super dealloc];
}


-(void) setupACHAccount:(NSString *) accountNumber forUser:(NSString *) userId withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType
{
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,  userId, apiKey]] autorelease];  
    
    [rootUrl release];
    [apiKey release];
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userId, @"userId",
                                 //deviceId, @"deviceId",
                                 nameOnAccount, @"nameOnAccount",
                                 routingNumber, @"routingNumber",
                                 accountNumber, @"accountNumber",
                                 accountType, @"accountType",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(setupACHAccountComplete:)];
    [request setDidFailSelector:@selector(setupACHAccountFailed:)];
    
    [request startAsynchronous];
}
-(void) setupACHAccountComplete: (ASIHTTPRequest *) request {
    
    
    if([request responseStatusCode] == 201 ) {
        NSLog(@"ACH Account Setup Success");
        
        NSString *theJSON = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        [parser release];
        
        NSString *paymentAccountId = [jsonDictionary objectForKey:@"paymentAccountId"];
        
        [userACHSetupCompleteDelegate userACHSetupDidComplete: paymentAccountId];
        
    }
    else {
        NSString* message = [NSString stringWithFormat: @"Unable to setup ACH Account"];
        
        [userACHSetupCompleteDelegate userACHSetupDidFail: message];
        
        NSLog(@"ACH Account Setup Failed");
    
    }
    
}
-(void) setupACHAccountFailed:(ASIHTTPRequest *)request
{
    NSString* message = [NSString stringWithFormat: @"Unable to setup ACH Account"];
    
    [userACHSetupCompleteDelegate userACHSetupDidFail: message];
    
    NSLog(@"Setup ACH Account Failed with Exception");
}

@end
