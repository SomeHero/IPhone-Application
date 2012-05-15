//
//  RequestMoneyService.h
//  PdThx
//
//  Created by James Rhodes on 5/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "RequestMoneyCompleteProtocol.h"

@interface RequestMoneyService : NSObject {
    ASIHTTPRequest* requestObj;
    id<RequestMoneyCompleteProtocol> requestMoneyCompleteDelegate;
}

@property(retain) id requestMoneyCompleteDelegate;

-(void) requestMoney:(NSString *)theAmount toRecipient:(NSString *)theRecipientUri fromSender:(NSString *)theSenderUri withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
       fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount;

@end
