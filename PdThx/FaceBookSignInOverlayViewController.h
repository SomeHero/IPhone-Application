//
//  FaceBookSignInOverlayViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInUserService.h"
#import "SignInWithFBService.h"
#import "Facebook.h"
#import "FacebookSignIn.h"

@interface FaceBookSignInOverlayViewController : UIViewController<FBRequestDelegate>
{
    SignInUserService *signInUserService;
    SignInWithFBService *service;
    Facebook *fBook;
    FacebookSignIn* faceBookSignInHelper;
    
    id<FBSignInCompleteProtocol> facebookSignInCompleteDelegate;
}

@property(nonatomic, retain) id<FBSignInCompleteProtocol> facebookSignInCompleteDelegate;

@end
