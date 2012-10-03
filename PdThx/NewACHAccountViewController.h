//
//  NewACHAccountViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"
#import "CustomAlertViewProtocol.h"
#import "MIPController.h"
#import "SecurityQuestionInputProtocol.h"
#import "CustomSecurityPinSwipeProtocol.h"
#import "ValidationHelper.h"
#import "UserSetupACHAccount.h"
#import "UserACHSetupCompleteProtocol.h"
#import "BankAccountRequestProtocol.h"

@interface NewACHAccountViewController : UIBaseViewController<CustomSecurityPinSwipeProtocol, SecurityQuestionInputProtocol,MIPControllerDelegate,CustomAlertViewProtocol, BankAccountRequestProtocol>
{
    IBOutlet UIView* mainView;
    IBOutlet UIView* navBar;
    IBOutlet UITextField* txtAccountNickname;
    IBOutlet UITextField* txtNameOnAccount;
    IBOutlet UITextField* txtRoutingNumber;
    IBOutlet UITextField* txtAccountNumber;
    IBOutlet UITextField* txtConfirmAccountNumber;
    IBOutlet UISegmentedControl* ctrlAccountType;
    IBOutlet UITextView* ctrlHeaderText;
    MIPController*mipControllerInstance;
    
    NSString* securityPin;
    UserSetupACHAccount* accountService;
    ValidationHelper* validationHelper;
    
    id<UserACHSetupCompleteProtocol> achSetupDidComplete;
}

@property(nonatomic, retain) id<UserACHSetupCompleteProtocol> achSetupDidComplete;
@property(nonatomic, retain) MIPController*mipControllerInstance;

-(IBAction) btnCreateAccountClicked:(id)sender;

- (void)takePictureOfCheck;

@end
