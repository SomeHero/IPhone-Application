//
//  AddACHAccountViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSetupACHAccount.h"
#import "GenericSecurityPinSwipeController.h"
#import "CustomSecurityPinSwipeProtocol.h"
#import "ACHSetupCompleteProtocol.h"
#import "User.h"
#import "PdThxAppDelegate.h"
#import "AddSecurityQuestionViewController.h"
#import "ValidationHelper.h"
#import "UISetupUserBaseViewController.h"
#import "SetupNavigationView.h"
#import "CheckImageReturnProtocol.h"
#import "MIPController.h"
#import "BankAccountService.h"
#import "UserService.h"
#import "UserInformationCompleteProtocol.h"

@interface AddACHAccountViewController : UISetupUserBaseViewController<CustomSecurityPinSwipeProtocol, SecurityQuestionInputProtocol, UITextFieldDelegate, CheckImageReturnProtocol,MIPControllerDelegate, CustomAlertViewProtocol,
    UserInformationCompleteProtocol>
{
    IBOutlet UIView* mainView;
    IBOutlet UIView* navBar;
    IBOutlet UITextField* txtNameOnAccount;
    IBOutlet UITextField* txtRoutingNumber;
    IBOutlet UITextField* txtAccountNumber;
    IBOutlet UITextField* txtConfirmAccountNumber;
    IBOutlet UISegmentedControl* ctrlAccountType;
    IBOutlet UITextView* ctrlHeaderText;
    MIPController*mipControllerInstance;
    
    NSString* navBarTitle;
    NSString* securityPin;
    UserSetupACHAccount* accountService;
    BankAccountService* bankAccountService;
    UserService* userService;
    GenericSecurityPinSwipeController* controller;
    AddSecurityQuestionViewController* addSecurityQuestionController;
    ValidationHelper* validationHelper;
    BOOL newUserFlow;
    
    id<ACHSetupCompleteProtocol> achSetupComplete;
}

@property(nonatomic, retain) NSString* navBarTitle;
@property(nonatomic, retain) MIPController*mipControllerInstance;

@property(nonatomic, retain) NSString* headerText;
@property(nonatomic) BOOL newUserFlow;

@property(nonatomic, retain) id<ACHSetupCompleteProtocol> achSetupComplete;

-(IBAction)btnRemindMeLaterClicked:(id)sender;
-(IBAction) btnCreateAccountClicked:(id)sender;
-(IBAction) bgClicked:(id)sender;


- (void)takePictureOfCheck;

@end
