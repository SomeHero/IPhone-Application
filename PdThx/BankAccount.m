//
//  BankAccount.m
//  PdThx
//
//  Created by James Rhodes on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BankAccount.h"

@implementation BankAccount

@synthesize bankAccountId;
@synthesize nameOnAccount;
@synthesize accountNumber;
@synthesize routingNumber;
@synthesize accountType;

-(id)init {
    self = [super init];
    if(self) {
        
        bankAccountId = [[NSString alloc] init];
        nameOnAccount = [[NSString alloc] init];
        accountNumber = [[NSString alloc] init];
        routingNumber = [[NSString alloc] init];
        accountType = [[NSString alloc] init];
        
        
    }
    
    return self;
}
-(BankAccount *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        bankAccountId = [[dictionary valueForKey:@"Id"] copy];
        accountNumber = [[dictionary valueForKey:@"AccountNumber"] copy];
        routingNumber = [[dictionary valueForKey:@"RoutingNumber"] copy];
        accountType = [[dictionary valueForKey:@"accountType"] copy];
        nameOnAccount = [[dictionary objectForKey:@"nameOnAccount"] copy];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    BankAccount *another = [[BankAccount alloc] init];
    
    another.bankAccountId = bankAccountId;
    another.accountNumber = accountNumber;
    another.routingNumber = routingNumber;
    another.accountType = accountType;
    another.nameOnAccount = nameOnAccount;
    
    return another;
}

@end
