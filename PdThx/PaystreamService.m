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
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/%@?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl,rootUrl, apiKey]] autorelease];  
    
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
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/accept_pledge?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];
    
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
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/donate?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, apiKey]] autorelease];
    
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
        
        NSString* message = [NSString stringWithString: @"Unable to send money"];
        
        NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
        
        bool isLockedOut = [[jsonDictionary objectForKey: @"isLockedOut"] boolValue];
        NSInteger numberOfPinCodeFailures = [[jsonDictionary valueForKey: @"numberOfPinCodeFailures"] intValue];
        
        [sendMoneyCompleteDelegate sendMoneyDidFail:message isLockedOut:isLockedOut withPinCodeFailures:numberOfPinCodeFailures];
        
        NSLog(@"Error Sending Money");
    }
    
}
-(void) sendMoneyFailed:(ASIHTTPRequest *)request
{
    NSString* message = [NSString stringWithString: @"Unable to send money"];
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    NSString *theJSON = [[NSString alloc] initWithData: [request responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    BOOL isLockedOut = [[jsonDictionary valueForKey: @"isLockedOut"] boolValue];
    NSInteger numberOfPinCodeFailures = [[jsonDictionary valueForKey: @"numberOfPinCodeFailures"] intValue];
    
    [sendMoneyCompleteDelegate sendMoneyDidFail: message isLockedOut:isLockedOut withPinCodeFailures:numberOfPinCodeFailures];
    
    NSLog(@"Send Money Failed");
}
-(void) cancelPayment:(NSString*) messageId {
    
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/cancel_payment?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
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
        [cancelPaymentProtocol cancelPaymentDidFail];
    }

}
-(void) cancelPaymentFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Payment Failed");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [cancelPaymentProtocol cancelPaymentDidFail];
}
-(void) acceptRequest:(NSString*) messageId withUserId: (NSString*) userId fromPaymentAccount : (NSString*) paymentAccountId withSecurityPin : (NSString*) securityPin {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/accept_request?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
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
        [acceptPaymentRequestProtocol acceptPaymentRequestDidFail];
    }
    
}
-(void) acceptRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Accept Request Failed");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [acceptPaymentRequestProtocol acceptPaymentRequestDidFail];
}
-(void) rejectRequest:(NSString*) messageId {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/reject_request?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(rejectRequestComplete:)];
    [requestObj setDidFailSelector:@selector(rejectRequestFailed:)];
    [requestObj startAsynchronous];
}
-(void) rejectRequestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Reject Request Complete");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        [rejectPaymentRequestProtocol rejectPaymentRequestDidComplete];
    }
    else {
        [rejectPaymentRequestProtocol rejectPaymentRequestDidComplete];
    }
    
}
-(void) rejectRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Reject Request Failed");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [rejectPaymentRequestProtocol rejectPaymentRequestDidFail];
}
-(void) cancelRequest:(NSString*) messageId {
    Environment *myEnvironment = [Environment sharedInstance];
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PayStreamMessages/%@/cancel_request?apiKey=%@", myEnvironment.pdthxWebServicesBaseUrl, messageId, apiKey]] autorelease];  
    
    requestObj = [[ASIHTTPRequest alloc] initWithURL:urlToSend];
    [requestObj addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [requestObj addRequestHeader:@"Content-Type" value:@"application/json"]; 
    [requestObj setRequestMethod: @"POST"];	
    
    [requestObj setDelegate: self];
    [requestObj setDidFinishSelector:@selector(cancelRequestComplete:)];
    [requestObj setDidFailSelector:@selector(cancelRequestFailed:)];
    [requestObj startAsynchronous];
}
-(void) cancelRequestComplete:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Request Complete");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    if([request responseStatusCode] == 200) {
        [cancePaymentRequestProtocol cancelPaymentRequestDidComplete];
    }
    else {
        [cancePaymentRequestProtocol cancelPaymentRequestDidFail];
    }
    
}
-(void) canelRequestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Cancel Request Failed");
    
    NSLog(@"Response %d : %@ with %@", request.responseStatusCode, [request responseString], [request responseStatusMessage]);
    
    [cancePaymentRequestProtocol cancelPaymentRequestDidFail];
}


-(void)updateSeenItems:(NSString*) userId withArray:(NSMutableArray*)seenItems
{
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *apiKey = [NSString stringWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/PaystreamMessages/%@/update_messages_seen", myEnvironment.pdthxWebServicesBaseUrl, userId]] autorelease];
    
    NSLog(@"Sending to: %@", urlToSend);
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 userId, @"userId",
                                 seenItems, @"messageIds",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation];
    
    NSLog(@"JSON Being Sent:%@",newJSON);
    
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
