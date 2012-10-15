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
#import "VerifyBankAccountProtocol.h"

@interface EditACHAccountViewController : UISetupUserBaseViewController <UITextFieldDelegate,
     VerifyBankAccountProtocol>
{
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
    NSString* pendingAction;
    
    id<DeleteBankAccountProtocol> deleteBankAccountProtocol;
    id<UpdateBankAccountProtocol> updateBankAccountProtocol;
}

@property(nonatomic, retain) id<DeleteBankAccountProtocol> deleteBankAccountProtocol;
@property(nonatomic, retain) id<UpdateBankAccountProtocol> updateBankAccountProtocol;

@property(nonatomic, retain) BankAccount* bankAccount;

-(IBAction)btnSaveChangesClicked :(id)sender;
-(IBAction)btnDeleteAccountClicked:(id)sender;
-(IBAction) bgTouched:(id) sender;
-(IBAction)btnVerifyClicked:(id)sender;

@end
