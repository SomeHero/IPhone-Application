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
@synthesize verifyRoutingNumberDelegate;

-(void) getUserAccounts:(NSString*) userId
{
    
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
    
    if([request responseStatusCode] == 200 )
    {
        
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
    else
    {
        NSLog(@"Error Getting User Accounts");
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [bankAccountRequestDelegate getUserAccountsDidFail: message withErrorCode: errorCode];
    }
}

-(void) getUserAccountsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [bankAccountRequestDelegate getUserAccountsDidFail: message withErrorCode: errorCode];
}

-(void) deleteBankAccount: (NSString*)accountId forUserId: (NSString*) userId withSecurityPin: (NSString*) securityPin {
    
    Environment *myEnvironment = [Environment sharedInstance];

    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, accountId, myEnvironment.pdthxAPIKey]] autorelease];  
    
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 securityPin, @"securityPin",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj buildPostBody];
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
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [deleteBankAccountDelegate deleteBankAccountDidFail: message withErrorCode: errorCode];
        
    }
    
    
}
-(void) deleteBankAccountDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [deleteBankAccountDelegate deleteBankAccountDidFail: message withErrorCode: errorCode];
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
    [requestObj buildPostBody];
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
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [updateBankAccountDelegate updateBankAccountDidFail: message withErrorCode:errorCode];
        
    }
    
    
}
-(void) updateBankAccountDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [updateBankAccountDelegate updateBankAccountDidFail: message withErrorCode: errorCode];
}

-(void) setPreferredSendAccount:(NSString*) accountId forUserId: (NSString*) userId withSecurityPin: (NSString*) securityPin {
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts/set_preferred_send_account?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, myEnvironment.pdthxAPIKey]] autorelease];
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //deviceId, @"deviceId",
                                 accountId, @"PaymentAccountId",
                                 securityPin, @"SecurityPin",
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
-(void) setPreferredReceiveAccount:(NSString*) accountId forUserId: (NSString*) userId withSecurityPin: (NSString*) securityPin {
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Users/%@/PaymentAccounts/set_preferred_receive_account?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, myEnvironment.pdthxAPIKey]] autorelease];  
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //deviceId, @"deviceId",
                                 accountId, @"PaymentAccountId",
                                 securityPin, @"SecurityPin",
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
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [preferredAccountDelegate setPreferredAccountDidFail: message withErrorCode: errorCode];
        
    }
    
    
}
-(void) setPreferredAccountDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Error Getting User Accounts");
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [preferredAccountDelegate setPreferredAccountDidFail: message withErrorCode:errorCode];
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
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [verifyBankAccountDelegate verifyBankAccountsDidFail: message withErrorCode:errorCode];
        
    }
    
    
}
-(void) verifyBankAccountDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Error Verifying Bank Account");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [verifyBankAccountDelegate verifyBankAccountsDidFail: message withErrorCode:errorCode];
}
-(void)verifyRoutingNumber: (NSString*) routingNumber {
    Environment *myEnvironment = [Environment sharedInstance];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/routingnumber/validateapiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,  myEnvironment.pdthxAPIKey]] autorelease];
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //deviceId, @"deviceId",
                                 routingNumber, @"routingNumber",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(verifyRoutingNumberDidComplete:)];
    [requestObj setDidFailSelector:@selector(verifyRoutingNumberDidFail:)];
    [requestObj startAsynchronous];
    
}
-(void) verifyRoutingNumberDidComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200 ) {
        
        BOOL verified = [[request responseString] boolValue];
        [verifyRoutingNumberDelegate verifyRoutingNumberDidComplete: verified];
        
    }
    else {
        
        NSLog(@"Error Verifying Routing Number");
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [verifyRoutingNumberDelegate verifyRoutingNumberDidFail: message withErrorCode:errorCode];
        
    }
    
    
}
-(void) verifyRoutingNumberDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"Error Verifying Routing Number");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [verifyRoutingNumberDelegate verifyRoutingNumberDidFail: message withErrorCode:errorCode];
}
@end


