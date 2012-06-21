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


@interface FacebookSignIn : NSObject<FBRequestDelegate> {
    SignInWithFBService *service;
    Facebook *fBook;
}

- (void)signInWithFacebook:(id)sender;

@end
