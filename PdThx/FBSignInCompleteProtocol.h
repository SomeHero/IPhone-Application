//
//  FBSignInCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBSignInCompleteProtocol;

@protocol FBSignInCompleteProtocol <NSObject>

<<<<<<< HEAD
-(void)fbSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserID:(NSString*)userID;
=======
-(void)fbSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserId:(NSString*) userId withPaymentAccountId:(NSString*) paymentAccountId withMobileNumber: (NSString*) mobileNumber;
>>>>>>> origin/web-api-chris

-(void)fbSignInDidFail:(NSString *)reason;

@end
