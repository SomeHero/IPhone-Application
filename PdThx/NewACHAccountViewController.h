//
//  NewACHAccountViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIModalBaseViewController.h"
#import "CustomSecurityPinSwipeProtocol.h"
#import "ValidationHelper.h"
#import "UserSetupACHAccount.h"
#import "UserACHSetupCompleteProtocol.h"

@interface NewACHAccountViewController : UIModalBaseViewController<CustomSecurityPinSwipeProtocol>
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
    
    NSString* securityPin;
    UserSetupACHAccount* accountService;
    ValidationHelper* validationHelper;
    
    id<UserACHSetupCompleteProtocol> achSetupDidComplete;
}

@property(nonatomic, retain) id<UserACHSetupCompleteProtocol> achSetupDidComplete;

-(IBAction) btnCreateAccountClicked:(id)sender;

@end
