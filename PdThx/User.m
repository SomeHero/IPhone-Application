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
@synthesize securityQuestionId;

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
        securityQuestionId = -1;
    }
    
    return self;
}
-(User *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        userId = [[dictionary valueForKey:@"userId"] copy];
        mobileNumber = [dictionary valueForKey:@"mobileNumber"];
        emailAddress = [dictionary valueForKey:@"emailAddress"];
        userName = [dictionary valueForKey:@"userName"];
        isLockedOut = [dictionary objectForKey:@"isLockedOut"];
        userStatus = [dictionary valueForKey:@"userStatus"];
        preferredName = [dictionary valueForKey: @"senderName"];
        firstName = [dictionary valueForKey:@"firstName"];
        lastName = [dictionary valueForKey:@"lastName"];
        imageUrl = [dictionary valueForKey:@"imageUrl"];
        totalMoneySent = [dictionary objectForKey:@"totalMoneySent"];
        totalMoneyReceived = [dictionary objectForKey: @"totalMoneyReceived"];
        preferredPaymentAccountId = [dictionary valueForKey: @"preferredPaymentAccountId"];
        preferredReceiveAccountId = [dictionary valueForKey: @"preferredReceiveAccountId"];
        limit = [dictionary objectForKey: @"upperLimit"];
        hasSecurityPin = [[dictionary valueForKey: @"setupSecurityPin"] boolValue];
        if ( [dictionary objectForKey:@"securityQuestionId"] == (id)[NSNull null] || [dictionary objectForKey:@"securityQuestionId"] == NULL )
            securityQuestionId = -1;
        else
            securityQuestionId = [[dictionary valueForKey:@"securityQuestionId"] intValue];
        
        if(mobileNumber != (id)[NSNull null] && [mobileNumber length] > 0)
        {
            userUri = mobileNumber;
        }
        else {
            userUri = userName;
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
    
    return another;
}

@end
