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

@interface VerifyACHAccountViewController : UIModalBaseViewController  
{
    IBOutlet UITextField* txtAmount1;
    IBOutlet UITextField* txtAmount2;
    
    BankAccountService* bankAccountService;
    BankAccount* bankAccount;
}

-(IBAction) btnVerifyAmountsClicked:(id)sender;

@end
