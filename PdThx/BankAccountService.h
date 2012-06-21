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

@interface BankAccountService : NSObject {
    ASIHTTPRequest *requestObj;
    id<BankAccountRequestProtocol> bankAccountRequestDelegate;
}

@property(retain) id bankAccountRequestDelegate;

-(void) getUserAccounts:(NSString*) userId;

@end
