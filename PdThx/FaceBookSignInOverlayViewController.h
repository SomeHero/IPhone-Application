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

#import "FacebookSignIn.h"

@interface FaceBookSignInOverlayViewController : UIViewController
{
    SignInUserService *signInUserService;
    SignInWithFBService *service;
    
    FacebookSignIn* faceBookSignInHelper;
    
    id<FBSignInCompleteProtocol> facebookSignInCompleteDelegate;
}

@property(nonatomic, retain) id<FBSignInCompleteProtocol> facebookSignInCompleteDelegate;

@end
