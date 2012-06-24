//
//  SetupACHAccountController.h
//  PdThx
//
//  Created by James Rhodes on 4/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACHSetupCompleteProtocol.h"
#import "UIBaseViewController.h"
#import "UserSetupACHAccount.h"
#import "UserSetupACHAccountComplete.h"
#import "ACHAccountReminderProtocol.h"
#import "CustomSecurityPinSwipeController.h"
#import "CustomSecurityPinSwipeProtocol.h"
#import "UISetupUserBaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SecurityQuestionInputProtocol.h"
#import "AddSecurityQuestionViewController.h"
#import "ValidationHelper.h"

@interface SetupACHAccountController : UISetupUserBaseViewController<UITextFieldDelegate, SecurityQuestionInputProtocol> {
    IBOutlet UITextField* txtNameOnAccount;
    IBOutlet UITextField* txtRoutingNumber;
    IBOutlet UITextField* txtAccountNumber;
    IBOutlet UITextField* txtConfirmAccountNumber;
    IBOutlet UIButton* btnSetupACHAccount;
    IBOutlet UIView* viewPanel;
    UserSetupACHAccount* userSetupACHAccountService;
    UIAlertView * skipBankAlert;
    IBOutlet UIBarButtonItem *skipButton;
    CustomSecurityPinSwipeController *controller;
    AddSecurityQuestionViewController *securityQuestionController;
    NSString* securityPin;
    ValidationHelper* validationHelper;
}

@property(nonatomic, retain) UITextField* txtNameOnAccount;
@property(nonatomic, retain) UITextField* txtRoutingNumber;
@property(nonatomic, retain) UITextField* txtAccountNumber;
@property(nonatomic, retain) UITextField* txtConfirmAccountNumber;
@property(retain) id<UserSetupACHAccountComplete> userSetupACHAccountComplete;
@property (retain) id<ACHSetupCompleteProtocol> achSetupCompleteDelegate;
@property(nonatomic, retain) NSString*securityPin;

@property(nonatomic,retain) UIAlertView* skipBankAlert;

-(IBAction) bgTouched:(id) sender;

-(IBAction) btnSetupACHAccountClicked:(id) sender;
-(void) setupACHAccount:(NSString *) accountNumber forUser:(NSString *) userId withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType;


- (IBAction)doSkip:(id)sender;

@end
