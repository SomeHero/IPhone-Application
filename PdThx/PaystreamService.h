//
//  PaystreamService.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "AcceptPaymentRequestProtocol.h"
#import "RejectPaymentRequestProtocol.h"
#import "CancelPaymentProtocol.h"
#import "CancelPaymentRequestProtocol.h"
#import "SendMoneyCompleteProtocol.h"
#import "UpdateSeenMessagesProtocol.h"

@interface PaystreamService : NSObject
{
    ASIHTTPRequest *requestObj;
    id<AcceptPaymentRequestProtocol> acceptPaymentRequestProtocol;
    id<RejectPaymentRequestProtocol> rejectPaymentRequestProtocol;
    id<CancelPaymentProtocol> cancelPaymentProtocol;
    id<CancelPaymentRequestProtocol> cancePaymentRequestProtocol;
    id<SendMoneyCompleteProtocol> sendMoneyCompleteDelegate;
    id<UpdateSeenMessagesProtocol> updateSeenMessagesDelegate;
}

@property(retain) id sendMoneyCompleteDelegate;
@property(retain) id acceptPaymentRequestProtocol;
@property(retain) id rejectPaymentRequestProtocol;
@property(retain) id cancePaymentRequestProtocol;
@property(retain) id cancelPaymentProtocol;
@property(retain) id updateSeenMessagesDelegate;

-(void) acceptPledge:(NSString*)senderId onBehalfOfId:(NSString*) behalfOfId toRecipientUri:(NSString*) recipientUri withAmount: (NSString*) amount withComments:(NSString*) comments fromLatitude:(double) latitude fromLongitude: (double)longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName:(NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri withSecurityPin:(NSString*) securityPin;
-(void) sendDonation:(NSString*)senderId toOrganizationId:(NSString*) organizationId  fromSenderAccount:(NSString*)senderAccountId withAmount: (NSString*) amount withComments:(NSString*) comments fromLatitude:(double) latitude fromLongitude: (double)longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName:(NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri withSecurityPin:(NSString*) securityPin;


-(void) cancelPayment:(NSString*) messageId;
-(void) acceptRequest:(NSString*) messageId withUserId: (NSString*) userId fromPaymentAccount : (NSString*) paymentAccountId withSecurityPin : (NSString*) securityPin;
-(void) rejectRequest:(NSString*) messageId;
-(void) cancelRequest:(NSString*) messageId;

-(void)updateSeenItems:(NSString*) userId withArray:(NSMutableArray*)seenItems;

@end
