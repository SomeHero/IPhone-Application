//
//  User.h
//  PdThx
//
//  Created by James Rhodes on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaystreamMessage.h"
#import "PayPoint.h"
#import "BankAccount.h"
#import "UserAttribute.h"
#import "UserConfiguration.h"
#import "SocialNetworkAccount.h"

@interface User : NSObject<NSCopying> {
@private
    NSString* userId;
    NSString* mobileNumber;
    NSString* emailAddress;
    NSString* userName;
    bool isLockedOut;
    NSString* userStatus;
    NSString* preferredName;
    NSString* firstName;
    NSString* lastName;
    NSString* imageUrl;
    NSDecimalNumber* totalMoneySent;
    NSDecimalNumber* totalMoneyReceived;
    NSString* preferredPaymentAccountId;
    NSString* preferredReceiveAccountId;
    bool hasACHAccount;
    bool hasSecurityPin;
    NSDecimalNumber *limit;
    NSDecimalNumber* instantLimit;
    NSString* userUri;
    NSString* securityQuestion;
    int securityQuestionId;
    int numberOfPaystreamUpdates;
    
    NSString* facebookId;
    NSString* facebookToken;
    
    NSMutableArray* outstandingPayments;
    NSMutableArray* payPoints;
    NSMutableArray* bankAccounts;
    NSMutableArray* userAttributes;
    NSMutableArray* userConfigurationItems;
    
    NSMutableDictionary* socialNetworks;
}

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* mobileNumber;
@property(nonatomic, retain) NSString* emailAddress;
@property(nonatomic, retain) NSString* userName;
@property(nonatomic, retain) NSString* facebookId;
@property(nonatomic, retain) NSString* facebookToken;

@property bool isLockedOut;
@property(nonatomic, retain) NSString* userStatus;
@property(nonatomic, retain) NSString* preferredName;
@property(nonatomic, retain) NSString* firstName;
@property(nonatomic, retain) NSString* lastName;
@property(nonatomic, retain) NSString* imageUrl;
@property(nonatomic, retain) NSDecimalNumber* totalMoneySent;
@property(nonatomic, retain) NSDecimalNumber* totalMoneyReceived;
@property(nonatomic, retain) NSString* preferredPaymentAccountId;
@property(nonatomic, retain) NSString* preferredReceiveAccountId;
@property(nonatomic) bool hasACHAccount;
@property(nonatomic) bool hasSecurityPin;
@property(nonatomic, retain) NSDecimalNumber* limit;
@property(nonatomic, retain) NSDecimalNumber* instantLimit;
@property(nonatomic, retain) NSString* userUri;
@property(nonatomic, retain) NSString* securityQuestion;
@property int securityQuestionId;
@property int numberOfPaystreamUpdates;
@property(nonatomic, retain) NSMutableArray* outstandingPayments;
@property(nonatomic, retain) NSMutableArray* payPoints;
@property(nonatomic, retain) NSMutableArray* bankAccounts;
@property(nonatomic, retain) NSMutableArray* userAttributes;
@property(nonatomic, retain) NSMutableArray* userConfigurationItems;

@property(nonatomic, retain) NSMutableDictionary* socialNetworks;

-(User *) initWithDictionary : (NSDictionary *) dictionary;

@end
