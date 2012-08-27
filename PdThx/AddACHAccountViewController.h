//
//  AddACHAccountViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSetupACHAccount.h"
#import "CustomSecurityPinSwipeController.h"
#import "CustomSecurityPinSwipeProtocol.h"
#import "UserSetupACHAccountComplete.h"
#import "User.h"
#import "PdThxAppDelegate.h"
#import "AddSecurityQuestionViewController.h"
#import "UIBaseViewController.h"
#import "ValidationHelper.h"
#import "UISetupUserBaseViewController.h"
#import "SetupNavigationView.h"
#import "CheckImageReturnProtocol.h"
#import "MIPController.h"

@interface AddACHAccountViewController : UISetupUserBaseViewController<CustomSecurityPinSwipeProtocol, SecurityQuestionInputProtocol, UITextFieldDelegate, CheckImageReturnProtocol,MIPControllerDelegate>
{
    IBOutlet UIView* mainView;
    IBOutlet UIView* navBar;
    IBOutlet UITextField* txtNameOnAccount;
    IBOutlet UITextField* txtRoutingNumber;
    IBOutlet UITextField* txtAccountNumber;
    IBOutlet UITextField* txtConfirmAccountNumber;
    IBOutlet UISegmentedControl* ctrlAccountType;
    IBOutlet UITextView* ctrlHeaderText;
    IBOutlet UIButton *TakePictureOfCheckButton;
    MIPController*mipControllerInstance;
    
    NSString* navBarTitle;
    NSString* headerText;
    NSString* securityPin;
    UserSetupACHAccount* accountService;
    CustomSecurityPinSwipeController* controller;
    AddSecurityQuestionViewController* addSecurityQuestionController;
    ValidationHelper* validationHelper;
    BOOL newUserFlow;
}

@property(nonatomic, retain) NSString* navBarTitle;
@property(nonatomic, retain) UIButton *TakePictureOfCheckButton;
@property(nonatomic, retain) MIPController*mipControllerInstance;

@property(nonatomic, retain) NSString* headerText;
@property(nonatomic) BOOL newUserFlow;

-(IBAction)btnRemindMeLaterClicked:(id)sender;
-(IBAction) btnCreateAccountClicked:(id)sender;
-(IBAction) bgClicked:(id)sender;
- (IBAction)takePictureOfCheck:(id)sender;

@end
