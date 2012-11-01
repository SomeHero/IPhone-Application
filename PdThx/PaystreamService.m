//
//  PaystreamService.m
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PaystreamService.h"
#import "Environment.h"
#import "JSON.h"

@implementation PaystreamService

@synthesize acceptPaymentRequestProtocol;
@synthesize rejectPaymentRequestProtocol;
@synthesize cancePaymentRequestProtocol;
@synthesize cancelPaymentProtocol;
@synthesize sendMoneyCompleteDelegate;
@synthesize updateSeenMessagesDelegate;

-(void) sendMoney:(NSString *)theAmount toRecipient:(NSString*)recipientId withRecipientUri:(NSString *)theRecipientUri fromSender:(NSString *)theSenderUri withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
       fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount withFromLatitude:(double)latitude
withFromLongitude:(double)longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName: (NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri
{
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [NSString stringWithFormat:@"PaystreamMessages"];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/%@?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl,rootUrl, apiKey]] autorelease];
    
    NSDictionary *paymentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 userId, @"senderId",
                                 recipientId, @"recipientId",
                                 fromAccount, @"senderAccountId",
                                 theRecipientUri, @"recipientUri",
                                 theAmount, @"amount",
                                 theComments, @"comments",
                                 [NSString stringWithFormat:@"%f",latitude], @"latitude",
                                 [NSString stringWithFormat:@"%f",longitude], @"longitude",
                                 securityPin, @"securityPin",
                                 @"Payment", @"messageType",
                                 recipientFirstName, @"recipientFirstName",
                                 recipientLastName, @"recipientLastName",
                                 recipientImageUri, @"recipientImageUri",
                                 nil];
    
    
    NSString *newJSON = [paymentData JSONRepresentation];
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(sendMoneyComplete:)];
    [request setDidFailSelector:@selector(sendMoneyFailed:)];
    
    [request startAsynchronous];
    
    [paymentData release];
}
-(void) acceptPledge:(NSString*)senderId onBehalfOfId:(NSString*) behalfOfId toRecipientUri:(NSString*) recipientUri withAmount: (NSString*) amount withComments:(NSString*) comments fromLatitude:(double) latitude fromLongitude: (double)longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName:(NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri withSecurityPin:(NSString*) securityPin
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/pledge?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];
    
    NSDictionary *requestBody = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 senderId, @"senderId",
                                 behalfOfId, @"onBehalfOfId",
                                 recipientUri, @"recipientUri",
                                 amount, @"amount",
                                 comments, @"comments",
                                 [NSString stringWithFormat:@"%f",latitude], @"latitude",
                                 [NSString stringWithFormat:@"%f",longitude], @"longitude",
                                 recipientFirstName, @"recipientFirstName",
                                 recipientLastName, @"recipientLastName",
                                 recipientImageUri, @"recipientImageUri",
                                 securityPin, @"securityPin",
                                 nil];
    
    
    NSString *newJSON = [requestBody JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(sendMoneyComplete:)];
    [requestObj setDidFailSelector:@selector(sendMoneyFailed:)];
    
    [requestObj startAsynchronous];
}
-(void) sendDonation:(NSString*)senderId toOrganizationId:(NSString*) organizationId  fromSenderAccount:(NSString*)senderAccountId withAmount: (NSString*) amount withComments:(NSString*) comments fromLatitude:(double) latitude fromLongitude: (double)longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName:(NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri withSecurityPin:(NSString*) securityPin
{
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/donate?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];
    
    NSDictionary *requestBody = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 senderId, @"senderId",
                                 organizationId, @"organizationId",
                                 senderAccountId, @"senderAccountId",
                                 amount, @"amount",
                                 comments, @"comments",
                                 [NSString stringWithFormat:@"%f",latitude], @"latitude",
                                 [NSString stringWithFormat:@"%f",longitude], @"longitude",
                                 recipientFirstName, @"recipientFirstName",
                                 recipientLastName, @"recipientLastName",
                                 recipientImageUri, @"recipientImageUri",
                                 securityPin, @"securityPin",
                                 nil];
    
    
    NSString *newJSON = [requestBody JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(sendMoneyComplete:)];
    [requestObj setDidFailSelector:@selector(sendMoneyFailed:)];
    
    [requestObj startAsynchronous];
}
-(void) sendMoneyComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 201 ) {
        
        [sendMoneyCompleteDelegate sendMoneyDidComplete];
        
        NSLog(@"Money Sent");
        
    }
    else {
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [sendMoneyCompleteDelegate sendMoneyDidFail:message withErrorCode:errorCode];
        
        NSLog(@"Error Sending Money");
    }
    
}
-(void) sendMoneyFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [sendMoneyCompleteDelegate sendMoneyDidFail: message withErrorCode:errorCode];
    
    NSLog(@"Send Money Failed");
}
-(void) cancelPayment:(NSString*) messageId withUserId:(NSString*) userId  withSecurityPin:(NSString*) securityPin {
    
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/cancel_payment?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];
    
    NSDictionary *requestBody = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 userId, @"userId",
                                 securityPin, @"securityPin",
                                 nil];
    
    NSString *newJSON = [requestBody JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(cancelPaymentComplete:)];
    [requestObj setDidFailSelector:@selector(cancelPaymentFailed:)];
    [requestObj startAsynchronous];
}
-(void) cancelPaymentComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Payment Complete");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        [cancelPaymentProtocol cancelPaymentDidComplete];
    }
    else {
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [cancelPaymentProtocol cancelPaymentDidFail:message withErrorCode:errorCode];
    }

}
-(void) cancelPaymentFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Payment Failed");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [cancelPaymentProtocol cancelPaymentDidFail:message withErrorCode:errorCode];
}
-(void) acceptRequest:(NSString*) messageId withUserId: (NSString*) userId fromPaymentAccount : (NSString*) paymentAccountId withSecurityPin : (NSString*) securityPin {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/accept_request?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];
    
    NSDictionary *requestBody = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 userId, @"userId",
                                 paymentAccountId, @"paymentAccountId",
                                 securityPin, @"securityPin",
                                 nil];
    
    
    NSString *newJSON = [requestBody JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(acceptRequestComplete:)];
    [requestObj setDidFailSelector:@selector(acceptRequestFailed:)];
    
    [requestObj startAsynchronous];
}
-(void) acceptRequestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Accept Request Complete");
        
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);

    if([request responseStatusCode] == 200) {
        [acceptPaymentRequestProtocol acceptPaymentRequestDidComplete];
    }
    else {
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [acceptPaymentRequestProtocol acceptPaymentRequestDidFail:message withErrorCode:errorCode];
    }
    
}
-(void) acceptRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [acceptPaymentRequestProtocol acceptPaymentRequestDidFail:message withErrorCode:errorCode];
    
}
-(void) rejectRequest:(NSString*) messageId withUserId:(NSString*) userId withSecurityPin: (NSString*) securityPin {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/reject_request?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];
    
    NSDictionary *requestBody = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 userId, @"userId",
                                 securityPin, @"securityPin",
                                 nil];
    
    
    NSString *newJSON = [requestBody JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(rejectRequestComplete:)];
    [requestObj setDidFailSelector:@selector(rejectRequestFailed:)];
    [requestObj startAsynchronous];
}
-(void) rejectRequestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        [rejectPaymentRequestProtocol rejectPaymentRequestDidComplete];
    }
    else {
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [rejectPaymentRequestProtocol rejectPaymentRequestDidFail:message withErrorCode:errorCode];
    }
    
}
-(void) rejectRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [rejectPaymentRequestProtocol rejectPaymentRequestDidFail:message withErrorCode:errorCode];
}
-(void) cancelRequest:(NSString*) messageId withUserId:(NSString*) userId withSecurityPin: (NSString*) securityPin {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/cancel_request?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
    NSDictionary *requestBody = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 userId, @"userId",
                                 securityPin, @"securityPin",
                                 nil];
    
    NSString *newJSON = [requestBody JSONRepresentation];
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(cancelRequestComplete:)];
    [requestObj setDidFailSelector:@selector(cancelRequestFailed:)];
    [requestObj startAsynchronous];
}
-(void) cancelRequestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        [cancePaymentRequestProtocol cancelPaymentRequestDidComplete];
    }
    else {
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        [parser release];
        
        NSString* message = [jsonDictionary valueForKey: @"Message"];
        int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
        
        [cancePaymentRequestProtocol cancelPaymentRequestDidFail:message withErrorCode:errorCode];
    }
    
}
-(void) canelRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    [parser release];
    
    NSString* message = [jsonDictionary valueForKey: @"Message"];
    int errorCode = [[jsonDictionary valueForKey:@"ErrorCode"] intValue];
    
    [cancePaymentRequestProtocol cancelPaymentRequestDidFail:message withErrorCode:errorCode];
}


-(void)updateSeenItems:(NSString*) userId withArray:(NSMutableArray*)seenItems
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PaystreamMessages/%@/update_messages_seen?apikey=%@", myEnvironment.pdthxWebServicesBaseUrl, userId, apiKey]] autorelease];

    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 userId, @"userId",
                                 seenItems, @"messageIds",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation];

    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestObj appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];
    [requestObj setRequestMethod: @"POST"];
    
    [requestObj setDelegate:self];
    [requestObj setDidFinishSelector:@selector(updateSeenItemsComplete:)];
    [requestObj setDidFailSelector:@selector(updateSeenItemsFailed:)];
    [requestObj startAsynchronous];
}

-(void) updateSeenItemsComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Saved paystream seen messages/payments");
    
    if ( [request responseStatusCode] == 200 )
        [updateSeenMessagesDelegate paystreamUpdated:YES]; // SUCCEEDED_ctx.
    else
        [self updateSeenItemsFailed:request];
}
-(void) updateSeenItemsFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Failed updating seen paystream items with %@", [request responseStatusMessage]);
    
    // return delegate function
    [updateSeenMessagesDelegate paystreamUpdated:NO]; // FAILED
}

@end
