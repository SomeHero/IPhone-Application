//
//  UserSignInCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserSignInCompleteProtocol;

@protocol UserSignInCompleteProtocol <NSObject>

<<<<<<< HEAD
-(void)userSignInDidComplete:(NSString*) userId withPaymentAccountId:(NSString*) paymentAccountId withMobileNumber: (NSString*) mobileNumber;
=======
-(void)userSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserId: (NSString*) userId withPaymentAccountId:(NSString*) paymentAccountId withMobileNumber: (NSString*) mobileNumber;
>>>>>>> origin/web-api-chris

-(void)userSignInDidFail:(NSString *) reason;

@end

