//
//  BankAccountRequestProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BankAccountRequestProtocol;

@protocol BankAccountRequestProtocol <NSObject>

-(void)getUserAccountsDidComplete:(NSMutableArray*)bankAccounts;
-(void)getUserAccountsDidFail:(NSString*)errorMessage;

@end
