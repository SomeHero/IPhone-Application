//
//  SignInUserService.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "UserSignInCompleteProtocol.h"

@interface SignInUserService : NSObject {
    ASIHTTPRequest *requestObj;
    id<UserSignInCompleteProtocol> signInCompleteDelegate;
}

@property(retain) id userSignInCompleteDelegate;

-(void) validateUser:(NSString*) userName withPassword:(NSString*) password;

@end
