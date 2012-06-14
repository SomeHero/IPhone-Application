//
//  User.h
//  PdThx
//
//  Created by James Rhodes on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
@private
    NSString* userId;
    NSString* mobileNumber;
    NSString* emailAddress;
    NSString* userName;
    bool isLockedOut;
    NSString* userStatus;
    NSString* firstName;
    NSString* lastName;
    NSDecimalNumber* totalMoneySent;
    NSDecimalNumber* totalMoneyReceived;
}

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* mobileNumber;
@property(nonatomic, retain) NSString* emailAddress;
@property(nonatomic, retain) NSString* userName;
@property bool isLockedOut;
@property(nonatomic, retain) NSString* userStatus;
@property(nonatomic, retain) NSString* firstName;
@property(nonatomic, retain) NSString* lastName;
@property(nonatomic, retain) NSDecimalNumber* totalMoneySent;
@property(nonatomic, retain) NSDecimalNumber* totalMoneyReceived;

-(User *) initWithDictionary : (NSDictionary *) dictionary;

@end
