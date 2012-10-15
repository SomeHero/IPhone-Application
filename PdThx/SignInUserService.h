//
//  SignInUserService.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SignInCompleteProtocol.h"

@interface SignInUserService : NSObject {
    ASIHTTPRequest *requestObj;
    id<SignInCompleteProtocol> userSignInCompleteDelegate;
}

@property(retain) id userSignInCompleteDelegate;

-(void) validateUser:(NSString*) userName withPassword:(NSString*) password withDeviceId:(NSString*) deviceId;

@end