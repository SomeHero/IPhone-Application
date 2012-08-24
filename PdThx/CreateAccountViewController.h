//
//  CreateAccountViewController.h
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupACHAccountController.h"
#import "ASIHTTPRequest.h"
#import "RegisterUserService.h"
#import "UserService.h"
#import <MessageUI/MessageUI.h>
#import "FacebookSignIn.h"
#import "SignedOutTabBarManager.h"

@interface CreateAccountViewController : UIBaseViewController<UIAlertViewDelegate, UITextFieldDelegate, MFMessageComposeViewControllerDelegate,SignedOutTabBarDelegate, UserInformationCompleteProtocol> {
    IBOutlet UIButton *btnCreateAccount;
    IBOutlet UITextField *txtEmailAddress;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    UIActivityIndicatorView* spinner;
    NSString* userName;
    NSString* password;
    NSString* securityPin;
    IBOutlet UIView *viewPanel;
    ASIHTTPRequest *requestObj;
    SignInWithFBService *service;
    RegisterUserService* registerUserService;
    UserService* userService;
    NSString* registrationKey;
    float animatedDistance;
    FacebookSignIn* faceBookSignInHelper;
    
}

@property(nonatomic, retain) UIButton *btnCreateAccount;
@property(nonatomic, retain) UITextField *txtEmailAddress;
@property(nonatomic, retain) UITextField *txtPassword;
@property(nonatomic, retain) UITextField *txtConfirmPassword;
@property(nonatomic, assign) UIView* viewPanel;
@property(retain) id achSetupCompleteDelegate;
@property(nonatomic, assign) float animatedDistance;

@property (nonatomic, retain) SignedOutTabBarManager *tabBar;

-(IBAction) bgTouched:(id) sender;
- (IBAction)signInWithFacebookClicked:(id)sender;
-(IBAction) btnCreateAccountClicked:(id) sender;
-(BOOL) isValidEmailAddress:(NSString*) emailAddressToTest;
-(BOOL)isValidPassword:(NSString *) passwordToTest;
-(BOOL)doesPasswordMatch:(NSString *) passwordToTest passwordToMatch: (NSString *) confirmPassword;
-(void)getUserInformation: (NSString*) userId;

@end
