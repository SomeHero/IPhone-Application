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

-(id)init {
    self = [super init];
    if(self) {
        userId = [[NSString alloc] init];
        mobileNumber = [[NSString alloc] init];
        emailAddress = [[NSString alloc] init];
        userName = [[NSString alloc] init];
        userStatus = [[NSString alloc] init];
        firstName = [[NSString alloc] init];
        lastName = [[NSString alloc] init];
        totalMoneySent = [[NSDecimalNumber alloc] init];
        totalMoneyReceived = [[NSDecimalNumber alloc] init];
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
    firstName = [dictionary valueForKey:@"firstName"];
    lastName = [dictionary valueForKey:@"lastName"];
    totalMoneySent = [dictionary objectForKey:@"totalMoneySent"];
    totalMoneyReceived = [dictionary objectForKey: @"totalMoneyReceived"];
    }
    
    return self;
}
@end
