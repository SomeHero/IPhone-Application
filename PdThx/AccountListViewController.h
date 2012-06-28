//
//  AccountListViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankAccount.h"
#import "BankAccountService.h"
#import "BankAccountRequestProtocol.h"
#import "SetPreferredAccountProtocol.h"
#import "User.h"
#import "PdThxAppDelegate.h"
#import "UIAccountTableCell.h"
#import "AddACHAccountViewController.h"
#import "EditACHAccountViewController.h"
#import "UISetupUserBaseViewController.h"

@interface AccountListViewController : UISetupUserBaseViewController<BankAccountRequestProtocol, SetPreferredAccountProtocol, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate>{
    IBOutlet UIScrollView* scrollview;
    IBOutlet UIPickerView *senderAccountPickerView;
    IBOutlet UIPickerView *receiveAccountPickerView;
    IBOutlet UITableView *userAccountsTableView;
    IBOutlet UIView* viewPanel;
    IBOutlet UIView* editAccountView;
    NSMutableArray *arrayColors;
    NSMutableArray *userBankAccounts;
    BankAccountService *bankAccountService;
    UIPickerView *myPickerView;
}


@end
