//
//  BankAccount.h
//  PdThx
//
//  Created by James Rhodes on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BankAccount : NSObject {
@private
    NSString* nickName;
    NSString* bankAccountId;
    NSString* routingNumber;
    NSString* accountNumber;
    NSString* nameOnAccount;
    NSString* accountType;
    NSString* status;
}

@property(nonatomic, retain) NSString* nickName;
@property(nonatomic, retain) NSString* bankAccountId;
@property(nonatomic, retain) NSString* routingNumber;
@property(nonatomic, retain) NSString* accountNumber;
@property(nonatomic, retain) NSString* nameOnAccount;
@property(nonatomic, retain) NSString* accountType;
@property(nonatomic, retain) NSString* status;

-(BankAccount *) initWithDictionary : (NSDictionary *) dictionary;

@end
