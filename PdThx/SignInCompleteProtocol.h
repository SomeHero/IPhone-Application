//
//  SignInCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SignInCompleteProtocol;

@protocol SignInCompleteProtocol <NSObject>

-(void) userSignInDidComplete:hasBankAccount withSecurityPin:hasSecurityPin withUserId:userId withPaymentAccountId:paymentAccountId withMobileNumber:mobileNumber;
-(void) userSignInDidFail:response;

@end
