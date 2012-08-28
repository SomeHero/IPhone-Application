//
//  VerifyBankAccountDelegate.h
//  PdThx
//
//  Created by James Rhodes on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VerifyBankAccountProtocol;

@protocol VerifyBankAccountProtocol <NSObject>

-(void)verifyBankAccountsDidComplete;
-(void)verifyBankAccountsDidFail:(NSString*)errorMessage;

@end
