//
//  PayStreamService.h
//  PdThx
//
//  Created by James Rhodes on 5/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SendMoneyCompleteProtocol.h"


@interface SendMoneyService : NSObject {
    ASIHTTPRequest* requestObj;
    id<SendMoneyCompleteProtocol> sendMoneyCompleteDelegate;
}

@property(retain) id sendMoneyCompleteDelegate;

-(void) sendMoney:(NSString *)theAmount toRecipient:(NSString*)recipientId withRecipientUri:(NSString *)theRecipientUri fromSender:(NSString *)theSenderUri withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount withFromLatitude:(double)latitude
withFromLongitude:(double)longitude withRecipientFirstName: (NSString*) recipientFirstName withRecipientLastName: (NSString*) recipientLastName withRecipientImageUri:(NSString*) recipientImageUri;

@end