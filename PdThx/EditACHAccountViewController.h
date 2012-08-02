//
//  EditACHAccountViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankAccount.h"
#import "BankAccountService.h"
#import "User.h"
#import "PdThxAppDelegate.h"
#import "UISetupUserBaseViewController.h"
#import "VerifyACHAccountViewController.h"

@interface EditACHAccountViewController : UISetupUserBaseViewController {
    IBOutlet UIView* mainView;
    IBOutlet UITextField* txtNickName;
    IBOutlet UITextField* txtNameOnAccount;
    IBOutlet UITextField* txtRoutingNumber;
    IBOutlet UITextField* txtAccountNumber;
    IBOutlet UISegmentedControl* ctrlAccountType;
    IBOutlet UIView* ctrlVerifyView;
    IBOutlet UIView* ctrlUpdateView;
    BankAccount* bankAccount;
    BankAccountService* bankAccountService;
    
}

@property(nonatomic, retain) BankAccount* bankAccount;

-(IBAction)btnSaveChangesClicked :(id)sender;
-(IBAction)btnDeleteAccountClicked:(id)sender;
-(IBAction) bgTouched:(id) sender;
-(IBAction)btnVerifyClicked:(id)sender;

@end
