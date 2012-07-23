//
//  FacebookSignIn.h
//  PdThx
//
//  Created by James Rhodes on 6/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignInWithFBService.h"
#import "Facebook.h"
#import "PdThxAppDelegate.h"
#import "FBHelperReturnProtocol.h"


@interface FacebookSignIn : NSObject<FBSessionDelegate, FBRequestDelegate> {
    SignInWithFBService *service;
    Facebook *fBook;
    id<FBHelperReturnProtocol> cancelledDelegate;
    id userInfoDelegate;
}

- (void)signInWithFacebook:(id)sender;

@property (assign) id cancelledDelegate;

@end
