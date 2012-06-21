//
//  BankAccountService.m
//  PdThx
//
//  Created by James Rhodes on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BankAccountService.h"


@implementation BankAccountService

@synthesize bankAccountRequestDelegate;

-(void) getUserAccounts:(NSString*) userId {
    
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"GET"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(getUserAccountsComplete:)];
    [requestObj setDidFailSelector:@selector(getUserAccountsFailed:)];
    [requestObj startAsynchronous];
}
-(void) getUserAccountsComplete:(ASIHTTPRequest *)request
{
    if([request responseStatusCode] == 200 ) {
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSArray *tempArray = [[parser objectWithString:theJSON] copy];
        
        NSMutableArray* tempAccounts = [[[NSMutableArray alloc] initWithArray:tempArray] copy];
        
        NSMutableArray* userAccounts = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[tempAccounts count]; i++)
        {
            [userAccounts addObject: [[[BankAccount alloc] initWithDictionary: [tempAccounts objectAtIndex:(NSUInteger) i]] autorelease]];
        }
        
        [parser release];
        
        [bankAccountRequestDelegate getUserAccountsDidComplete:userAccounts];

    }
    else {
        NSLog(@"Error Getting User Accounts");
        
        [bankAccountRequestDelegate getUserAccountsDidFail: [request responseStatusMessage]];

    }
    
    
}
-(void) getUserAccountsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error Getting User Accounts");
    
    [bankAccountRequestDelegate getUserAccountsDidFail: [request responseStatusMessage]];
}


@end
