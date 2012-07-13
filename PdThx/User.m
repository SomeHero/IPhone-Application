//
//  User.m
//  PdThx
//
//  Created by James Rhodes on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"
@implementation User

@synthesize userId, mobileNumber, emailAddress,  userName, isLockedOut, userStatus, firstName, lastName, totalMoneySent, totalMoneyReceived;
@synthesize hasACHAccount, hasSecurityPin;
@synthesize preferredPaymentAccountId, preferredReceiveAccountId;
@synthesize preferredName;
@synthesize imageUrl;
@synthesize limit;
@synthesize userUri;
@synthesize securityQuestion;
@synthesize securityQuestionId;
@synthesize numberOfPaystreamUpdates;
@synthesize outstandingPayments;
@synthesize payPoints;
@synthesize bankAccounts;
@synthesize userAttributes;
@synthesize userConfigurationItems;

-(id)init {
    self = [super init];
    if(self) {
        userId = [[NSString alloc] init];
        mobileNumber = [[NSString alloc] init];
        emailAddress = [[NSString alloc] init];
        userName = [[NSString alloc] init];
        userStatus = [[NSString alloc] init];
        preferredName = [[NSString alloc] init];
        firstName = [[NSString alloc] init];
        lastName = [[NSString alloc] init];
        imageUrl = [[NSString alloc] init];
        totalMoneySent = [[NSDecimalNumber alloc] init];
        totalMoneyReceived = [[NSDecimalNumber alloc] init];
        hasACHAccount = false;
        hasSecurityPin = false;
        preferredPaymentAccountId = [[NSString alloc] init];
        preferredReceiveAccountId = [[NSString alloc] init];
        userUri = [[NSString alloc] init];
        outstandingPayments = [[NSMutableArray alloc] init];
        userAttributes = [[NSMutableArray alloc] init];
        userConfigurationItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}
-(User *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        userId = [[dictionary valueForKey:@"userId"] copy];
        mobileNumber = [[dictionary valueForKey:@"mobileNumber"] copy];
        emailAddress = [[dictionary valueForKey:@"emailAddress"] copy];
        userName = [[dictionary valueForKey:@"userName"] copy];
        isLockedOut = [[dictionary valueForKey: @"isLockedOut"] boolValue];
        userStatus = [[dictionary valueForKey:@"userStatus"] copy];
        preferredName = [[dictionary valueForKey: @"senderName"] copy];
        firstName = [[dictionary valueForKey:@"firstName"] copy];
        lastName = [[dictionary valueForKey:@"lastName"] copy];
        imageUrl = [[dictionary valueForKey:@"imageUrl"] copy];
        totalMoneySent = [[dictionary objectForKey:@"totalMoneySent"] copy];
        totalMoneyReceived = [[dictionary objectForKey: @"totalMoneyReceived"] copy];
        preferredPaymentAccountId = [[dictionary valueForKey: @"preferredPaymentAccountId"] copy];
        preferredReceiveAccountId = [[dictionary valueForKey: @"preferredReceiveAccountId"] copy];
        limit = [[dictionary objectForKey: @"upperLimit"] copy];
        hasSecurityPin = [[dictionary valueForKey: @"setupSecurityPin"] boolValue];
        
        if(mobileNumber != (id)[NSNull null] && [mobileNumber length] > 0) {
            userUri = mobileNumber;
        } else {
            userUri = userName;
        }
       // securityQuestionId =  [[dictionary objectForKey: @"securityQuestionId"] intValue];
        securityQuestion = [[dictionary valueForKey: @"securityQuestion"] copy];
        numberOfPaystreamUpdates = [[dictionary valueForKey: @"numberOfPaystreamUpdates"] intValue];
        
        NSArray *tempArray = [[dictionary valueForKey:@"pendingMessages"] copy];
        
        outstandingPayments = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[tempArray count]; i++)
        {
            [outstandingPayments addObject: [[[PaystreamMessage alloc] initWithDictionary: [tempArray objectAtIndex:(NSUInteger) i]] autorelease]];
        }
        
        NSArray *payPointsArray = [[dictionary valueForKey:@"userPayPoints"] copy];
        
        payPoints = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[payPointsArray count]; i++)
        {
            [payPoints addObject: [[[PayPoint alloc] initWithDictionary: [payPointsArray objectAtIndex:(NSUInteger) i]] autorelease]];
        }
        
        NSArray *bankAccountsArray = [[dictionary valueForKey:@"bankAccounts"] copy];
        
        bankAccounts = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[bankAccountsArray count]; i++)
        {
            [bankAccounts addObject: [[[BankAccount alloc] initWithDictionary: [bankAccountsArray objectAtIndex:(NSUInteger) i]] autorelease]];
        }

        NSArray *userAttributesArray = [[dictionary valueForKey:@"userAttributes"] copy];
        
        userAttributes = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[userAttributesArray count]; i++)
        {
            [userAttributes addObject: [[[UserAttribute alloc] initWithDictionary: [userAttributesArray objectAtIndex:(NSUInteger) i]] autorelease]];
        }
        
        NSArray *userConfigurationsArray = [[dictionary valueForKey:@"userConfigurationVariables"] copy];
        
        userConfigurationItems = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[userConfigurationsArray count]; i++)
        {
            [userConfigurationItems addObject: [[[UserConfiguration alloc] initWithDictionary: [userConfigurationsArray objectAtIndex:(NSUInteger) i]] autorelease]];
        }
        
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    User *another = [[User alloc] init];

    another.userId = userId;
    another.mobileNumber = mobileNumber;
    another.emailAddress = emailAddress;
    another.userName = userName;
    another.isLockedOut = isLockedOut;
    another.userStatus = userStatus;
    another.preferredName = preferredName;
    another.firstName = firstName;
    another.lastName = lastName;
    another.imageUrl = imageUrl;
    another.totalMoneySent = totalMoneySent;
    another.totalMoneyReceived = totalMoneyReceived;
    another.preferredPaymentAccountId = preferredPaymentAccountId;
    another.preferredReceiveAccountId = preferredReceiveAccountId;
    another.hasSecurityPin = hasSecurityPin;
    another.limit = limit;
    another.userUri = userUri;
    another.securityQuestionId = securityQuestionId;
    another.securityQuestion = securityQuestion;
    another.numberOfPaystreamUpdates = numberOfPaystreamUpdates;
    another.outstandingPayments = [outstandingPayments copy];
    another.payPoints = [payPoints copy];
    another.bankAccounts = [bankAccounts copy];
    another.userAttributes = [userAttributes copy];
    another.userConfigurationItems = [userConfigurationItems copy];

    return another;
}
-(void)dealloc {
    [super dealloc];
    

}

@end
