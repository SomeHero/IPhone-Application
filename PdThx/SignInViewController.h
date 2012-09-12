//
//  SignInViewController.h
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"
#import "UserInformationCompleteProtocol.h"
#import "SignInCompleteProtocol.h"
#import "SignInUserService.h"
#import "SignInWithFBService.h"
#import "FacebookSignIn.h"

#import "SetupACHAccountController.h"
#import "UserSetupACHAccountComplete.h"
#import "FacebookSignIn.h"
#import "SecurityQuestionChallengeViewController.h"
#import "SecurityQuestionChallengeProtocol.h"
#import "FaceBookSignInOverlayViewController.h"
#import "ForgotPasswordViewController.h"
#import "SignedOutTabBarManager.h"

@interface SignInViewController : UIBaseViewController<UserInformationCompleteProtocol, SecurityQuestionChallengeProtocol, UITextFieldDelegate, FBSignInCompleteProtocol, UINavigationBarDelegate, FBHelperReturnProtocol, SignedOutTabBarDelegate>
{
    IBOutlet UITextField *txtEmailAddress;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIView *viewPanel;
    IBOutlet UIButton *loginFBButton;
    IBOutlet UIImageView *facebookOverlay;
    IBOutlet UIButton *forgotPassword;
    SignInUserService *signInUserService;
    SignInWithFBService* fbSignInService;
    FacebookSignIn* fbSignInHelper;
    
    UIAlertView * bankAlert;
    float animatedDistance;
    FacebookSignIn* faceBookSignInHelper;
}

@property(nonatomic, retain) UITextField *txtEmailAddress;
@property(nonatomic, retain) UITextField *txtPassword;
@property(nonatomic, assign) UIView* viewPanel;

@property(nonatomic, retain) FacebookSignIn* fbSignInHelper;
@property(nonatomic, retain) SignInWithFBService* fbSignInService;

@property(nonatomic, retain) UIAlertView * bankAlert;
//@property(nonatomic, retain) SetupACHAccountController * setupACHAccountController;
@property(nonatomic, assign) float animatedDistance;
@property(nonatomic, assign) int numFailedFB;

@property (nonatomic, retain) SignedOutTabBarManager *tabBar;

-(IBAction) bgTouched:(id)sender;
-(IBAction) btnSignInClicked:(id)sender;
- (IBAction)forgotPasswordClicked:(id)sender;
-(BOOL)isValidUserName:(NSString *)userNameToTest;
-(BOOL)isValidPassword:(NSString *)passwordToTest;
-(IBAction)signInWithFacebookClicked:(id)sender;

@end
