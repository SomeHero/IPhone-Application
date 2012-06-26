//
//  BankAccountService.h
//  PdThx
//
//  Created by James Rhodes on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "BankAccount.h"
#import "BankAccountRequestProtocol.h"
#import "UpdateBankAccountProtocol.h"
#import "DeleteBankAccountProtocol.h"

@interface BankAccountService : NSObject {
    ASIHTTPRequest *requestObj;
    id<BankAccountRequestProtocol> bankAccountRequestDelegate;
    id<UpdateBankAccountProtocol> updateBankAccountDelegate;
    id<DeleteBankAccountProtocol> deleteBankAccountDelegate;
}

@property(retain) id bankAccountRequestDelegate;
@property(retain) id updateBankAccountDelegate;
@property(retain) id deleteBankAccountDelegate;

-(void) getUserAccounts:(NSString*) userId;
-(void) deleteBankAccount: (NSString*)accountId forUserId: (NSString*) userId;
-(void) updateBankAccount:(NSString *) accountId forUserId: (NSString*) userId withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType withSecurityPin : (NSString*) securityPin;

@end
