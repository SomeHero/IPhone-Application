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
#import "Facebook.h"
#import "SetupACHAccountController.h"
#import "UserSetupACHAccountComplete.h"
#import "FacebookSignIn.h"
#import "SecurityQuestionChallengeViewController.h"
#import "SecurityQuestionChallengeProtocol.h"
#import "FaceBookSignInOverlayViewController.h"
#import "ForgotPasswordViewController.h"

@interface SignInViewController : UIBaseViewController<UserInformationCompleteProtocol, SecurityQuestionChallengeProtocol, UITextFieldDelegate, FBSessionDelegate, FBRequestDelegate, FBSignInCompleteProtocol, UINavigationBarDelegate>
{
    IBOutlet UITextField *txtEmailAddress;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIView *viewPanel;
    IBOutlet UIButton *loginFBButton;
    IBOutlet UIImageView *facebookOverlay;
    IBOutlet UIButton *forgotPassword;
    SignInUserService *signInUserService;
    SignInWithFBService *service;
    Facebook *fBook;
    UIAlertView * bankAlert;
    float animatedDistance;
    FacebookSignIn* faceBookSignInHelper;
}

@property(nonatomic, retain) UITextField *txtEmailAddress;
@property(nonatomic, retain) UITextField *txtPassword;
@property(nonatomic, assign) UIView* viewPanel;
@property(nonatomic, retain) Facebook * fBook;
@property(nonatomic, retain) SignInWithFBService* service;
@property(nonatomic, retain) UIAlertView * bankAlert;
//@property(nonatomic, retain) SetupACHAccountController * setupACHAccountController;
@property(nonatomic, assign) float animatedDistance;

-(IBAction) bgTouched:(id)sender;
-(IBAction) btnSignInClicked:(id)sender;
- (IBAction)forgotPasswordClicked:(id)sender;
-(BOOL)isValidUserName:(NSString *)userNameToTest;
-(BOOL)isValidPassword:(NSString *)passwordToTest;
-(IBAction)signInWithFacebookClicked:(id)sender;

@end
