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

@interface PaystreamService : NSObject {
    ASIHTTPRequest *requestObj;
    id<AcceptPaymentRequestProtocol> acceptPaymentRequestProtocol;
    id<RejectPaymentRequestProtocol> rejectPaymentRequestProtocol;
    id<CancelPaymentProtocol> cancelPaymentProtocol;
    id<CancelPaymentRequestProtocol> cancePaymentRequestProtocol;
}

@property(retain) id acceptPaymentRequestProtocol;
@property(retain) id rejectPaymentRequestProtocol;
@property(retain) id cancePaymentRequestProtocol;
@property(retain) id cancelPaymentProtocol;

-(void) cancelPayment:(NSString*) messageId;
-(void) acceptRequest:(NSString*) messageId withUserId: (NSString*) userId fromPaymentAccount : (NSString*) paymentAccountId withSecurityPin : (NSString*) securityPin;
-(void) rejectRequest:(NSString*) messageId;
-(void) cancelRequest:(NSString*) messageId;

@end
