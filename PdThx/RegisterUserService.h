//
//  RegisterUserService.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "UserRegistrationCompleteProtocol.h"

@interface RegisterUserService : NSObject {
    ASIHTTPRequest *requestObj;
    id<UserRegistrationCompleteProtocol> userRegistrationCompleteDelegate;
}

@property(retain) id userRegistrationCompleteDelegate;


-(void) registerUser:(NSString *) newUserName withPassword:(NSString *) newPassword withMobileNumber:(NSString *) newMobileNumber withSecurityPin : (NSString *) newSecurityPin;

@end
