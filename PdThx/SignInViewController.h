//
//  SignInViewController.h
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"
#import "UserSignInCompleteProtocol.h"
#import "SignInCompleteProtocol.h"
#import "ACHSetupCompleteProtocol.h"
#import "SignInUserService.h"
#import "SignInWithFBService.h"
#import "Facebook.h"
#import "SetupACHAccountController.h"
#import "UserSetupACHAccountComplete.h"

@interface SignInViewController : UIBaseViewController<UserSignInCompleteProtocol, ACHSetupCompleteProtocol, UITextFieldDelegate, FBRequestDelegate, UserSetupACHAccountComplete, UINavigationBarDelegate>
{
    IBOutlet UITextField *txtEmailAddress;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIView *viewPanel;
    IBOutlet UIButton *loginFBButton;
    id<SignInCompleteProtocol> signInCompleteDelegate;
    //id<ACHSetupCompleteProtocol> achSetupCompleteDelegate;
    SignInUserService *signInUserService;
    SignInWithFBService *service;
    Facebook *fBook;
    UIAlertView * bankAlert;
    //SetupACHAccountController * setupACHAccountController;
}

@property(nonatomic, retain) UITextField *txtEmailAddress;
@property(nonatomic, retain) UITextField *txtPassword;
@property(retain) id signInCompleteDelegate;
//@property(retain) id achSetupCompleteDelegate;
@property(nonatomic, assign) UIView* viewPanel;
@property(nonatomic, retain) Facebook * fBook;
@property(nonatomic, retain) SignInWithFBService* service;
@property(nonatomic, retain) UIAlertView * bankAlert;
//@property(nonatomic, retain) SetupACHAccountController * setupACHAccountController;

-(IBAction) bgTouched:(id)sender;
-(IBAction) btnSignInClicked:(id)sender;
-(BOOL)isValidUserName:(NSString *)userNameToTest;
-(BOOL)isValidPassword:(NSString *)passwordToTest;
- (IBAction)doFBLogin:(id)sender;

@end
