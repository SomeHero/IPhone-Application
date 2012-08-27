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
@synthesize deleteBankAccountDelegate, updateBankAccountDelegate;
@synthesize preferredAccountDelegate;
@synthesize verifyBankAccountDelegate;

-(void) getUserAccounts:(NSString*) userId {
    
    Environment *myEnvironment = [Environment sharedInstance];

    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, myEnvironment.pdthxAPIKey]] autorelease];  
    
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
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
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
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [bankAccountRequestDelegate getUserAccountsDidFail: [request responseStatusMessage]];
}
-(void) deleteBankAccount: (NSString*)accountId forUserId: (NSString*) userId {
    
    Environment *myEnvironment = [Environment sharedInstance];

    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, accountId, myEnvironment.pdthxAPIKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"DELETE"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(deleteBankAccountDidComplete:)];
    [requestObj setDidFailSelector:@selector(deleteBankAccountDidFail:)];
    [requestObj startAsynchronous];
}
-(void) deleteBankAccountDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        [deleteBankAccountDelegate deleteBankAccountDidComplete];
        
    }
    else {
        
        NSLog(@"Error Getting User Accounts");
        
        [deleteBankAccountDelegate deleteBankAccountDidFail: [request responseStatusMessage]];
        
    }
    
    
}
-(void) deleteBankAccountDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Error Getting User Accounts");
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [deleteBankAccountDelegate deleteBankAccountDidFail: [request responseStatusMessage]];
}
-(void) updateBankAccount:(NSString *) accountId forUserId: (NSString*) userId withNickname: (NSString*) nickname withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType withSecurityPin : (NSString*) securityPin {
    
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, accountId, myEnvironment.pdthxAPIKey]] autorelease];  
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //deviceId, @"deviceId",
                                 nickname, @"nickName",
                                 nameOnAccount, @"nameOnAccount",
                                 routingNumber, @"routingNumber",
                                 accountType, @"accountType",
                                 securityPin, @"securityPin",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"PUT"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(updateBankAccountDidComplete:)];
    [requestObj setDidFailSelector:@selector(updateBankAccountDidFail:)];
    [requestObj startAsynchronous];
    
}
-(void) updateBankAccountDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        [updateBankAccountDelegate updateBankAccountDidComplete];
        
    }
    else {
        
        NSLog(@"Error Getting User Accounts");
        
        [deleteBankAccountDelegate deleteBankAccountDidFail: [request responseStatusMessage]];
        
    }
    
    
}
-(void) updateBankAccountDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Error Getting User Accounts");
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [updateBankAccountDelegate updateBankAccountDidFail: [request responseStatusMessage]];
}

-(void) setPreferredSendAccount:(NSString*) accountId forUserId: (NSString*) userId {
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts/set_preferred_send_account?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, myEnvironment.pdthxAPIKey]] autorelease];  
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //deviceId, @"deviceId",
                                 accountId, @"PaymentAccountId",
                                 @"2589", @"SecurityPin",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(setPreferredAccountDidComplete:)];
    [requestObj setDidFailSelector:@selector(setPreferredAccountDidFail:)];
    [requestObj startAsynchronous];
}
-(void) setPreferredReceiveAccount:(NSString*) accountId forUserId: (NSString*) userId {
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts/set_preferred_receive_account?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, myEnvironment.pdthxAPIKey]] autorelease];  
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //deviceId, @"deviceId",
                                 accountId, @"PaymentAccountId",
                                 @"2589", @"SecurityPin",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(setPreferredAccountDidComplete:)];
    [requestObj setDidFailSelector:@selector(setPreferredAccountDidFail:)];
    [requestObj startAsynchronous];
}
-(void) setPreferredAccountDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        [preferredAccountDelegate setPreferredAccountDidComplete];
        
    }
    else {
        
        NSLog(@"Error Getting User Accounts");
        
        [preferredAccountDelegate setPreferredAccountDidFail: [request responseStatusMessage]];
        
    }
    
    
}
-(void) setPreferredAccountDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Error Getting User Accounts");
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [preferredAccountDelegate setPreferredAccountDidFail: [request responseStatusMessage]];
}
-(void)verifyBankAccount:(NSString*)accountId forUserId: (NSString*)userId withFirstAmount:(NSString*)firstAmount withSecondAmount:(NSString*)secondAmount
{
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts/%@/verify_account/?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, accountId, myEnvironment.pdthxAPIKey]] autorelease];  
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //deviceId, @"deviceId",
                                 firstAmount, @"depositAmount1",
                                 secondAmount, @"depositAmount2",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(verifyBankAccountDidComplete:)];
    [requestObj setDidFailSelector:@selector(verifyBankAccountDidFail:)];
    [requestObj startAsynchronous];
}
-(void) verifyBankAccountDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        [verifyBankAccountDelegate verifyBankAccountsDidComplete];
        
    }
    else {
        
        NSLog(@"Error Verifying Bank Account");
        
        [verifyBankAccountDelegate verifyBankAccountsDidFail: [request responseStatusMessage]];
        
    }
    
    
}
-(void) verifyBankAccountDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Error Verifying Bank Account");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [verifyBankAccountDelegate verifyBankAccountsDidFail: [request responseStatusMessage]];
}
@end
