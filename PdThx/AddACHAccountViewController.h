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

@interface AddACHAccountViewController : UISetupUserBaseViewController<CustomSecurityPinSwipeProtocol, SecurityQuestionInputProtocol>
{
    IBOutlet UIScrollView* mainScrollView;
    IBOutlet UITextField* txtNameOnAccount;
    IBOutlet UITextField* txtRoutingNumber;
    IBOutlet UITextField* txtAccountNumber;
    IBOutlet UITextField* txtConfirmAccountNumber;
    IBOutlet UISegmentedControl* ctrlAccountType;
    IBOutlet UITextView* ctrlHeaderText;
    NSString* navBarTitle;
    NSString* headerText;
    NSString* securityPin;
    UserSetupACHAccount* accountService;
    CustomSecurityPinSwipeController* controller;
    AddSecurityQuestionViewController* addSecurityQuestionController;
    ValidationHelper* validationHelper;
}

@property(nonatomic, retain) NSString* navBarTitle;
@property(nonatomic, retain) NSString* headerText;

-(IBAction) btnCreateAccountClicked:(id)sender;
-(IBAction) bgClicked:(id)sender;

@end
