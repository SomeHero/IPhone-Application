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
#import "SetPreferredAccountProtocol.h"
#import "VerifyBankAccountProtocol.h"
#import "VerifyRoutingNumberProtocol.h"

@interface BankAccountService : NSObject
{
    ASIHTTPRequest *requestObj;
    id<BankAccountRequestProtocol> bankAccountRequestDelegate;
    id<UpdateBankAccountProtocol> updateBankAccountDelegate;
    id<DeleteBankAccountProtocol> deleteBankAccountDelegate;
    id<SetPreferredAccountProtocol> preferredAccountDelegate;
    id<VerifyBankAccountProtocol> verifyBankAccountDelegate;
    id<VerifyRoutingNumberProtocol> verifyRoutingNumberDelegate;
}

@property(retain) id bankAccountRequestDelegate;
@property(retain) id updateBankAccountDelegate;
@property(retain) id deleteBankAccountDelegate;
@property(retain) id preferredAccountDelegate;
@property(retain) id verifyBankAccountDelegate;
@property(retain) id verifyRoutingNumberDelegate;

-(void) getUserAccounts:(NSString*)userId;

-(void) deleteBankAccount: (NSString*)accountId forUserId: (NSString*) userId withSecurityPin: (NSString*) securityPin;
-(void) updateBankAccount:(NSString *) accountId forUserId: (NSString*) userId withNickname: (NSString*) nickname withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType withSecurityPin : (NSString*) securityPin;
-(void) setPreferredSendAccount:(NSString*) accountId forUserId: (NSString*) userId withSecurityPin: (NSString*) securityPin;
-(void) setPreferredReceiveAccount:(NSString*) accountId forUserId: (NSString*) userId withSecurityPin: (NSString*) securityPin;
-(void)verifyBankAccount:(NSString*)accountId forUserId: (NSString*)userId withFirstAmount:(NSString*)firstAmount withSecondAmount:(NSString*)secondAmount;
-(void)verifyRoutingNumber: (NSString*) routingNumber;

@end
