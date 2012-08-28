//
//  VerifyACHAccountViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIModalBaseViewController.h"
#import "BankAccountService.h"
#import "BankAccount.h"
#import "VerifyBankAccountProtocol.h"
#import "CustomAlertViewProtocol.h"

@interface VerifyACHAccountViewController : UIModalBaseViewController<VerifyBankAccountProtocol, CustomAlertViewProtocol>
{
    IBOutlet UITextField* txtAmount1;
    IBOutlet UITextField* txtAmount2;
    
    BankAccountService* bankAccountService;
    BankAccount* bankAccount;
    
    id<VerifyBankAccountProtocol> verifyBankAccountDelegate;
}

@property(retain) id verifyBankAccountDelegate;
@property(nonatomic, retain) BankAccount* bankAccount;

-(IBAction) btnVerifyAmountsClicked:(id)sender;


@end
