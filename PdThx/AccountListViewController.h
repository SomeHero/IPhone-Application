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
#import "NewACHAccountViewController.h"
#import "AddACHAccountViewController.h"
#import "EditACHAccountViewController.h"
#import "UISetupUserBaseViewController.h"
#import "UAModalPanel.h"
#import "SelectAccountModalViewControllerViewController.h"
#import "ModalSelectProtocol.h"
#import "UIProfileTableViewCell.h"

@interface AccountListViewController : UISetupUserBaseViewController<UITextFieldDelegate, BankAccountRequestProtocol, ACHSetupCompleteProtocol, DeleteBankAccountProtocol, UpdateBankAccountProtocol, SetPreferredAccountProtocol, ModalSelectProtocol, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UserInformationCompleteProtocol>{
    IBOutlet UIScrollView* scrollview;
    IBOutlet UIPickerView *senderAccountPickerView;
    IBOutlet UIPickerView *receiveAccountPickerView;
    IBOutlet UITableView *userAccountsTableView;
    IBOutlet UIView* viewPanel;
    IBOutlet UIView* editAccountView;
    NSMutableArray *arrayColors;
    BankAccountService *bankAccountService;
    UserService* userService;
    UIPickerView *myPickerView;
    SelectAccountModalViewControllerViewController* selectModal;
    NSString* selectedOption;
    NSString* accountType;
    
    bool newAccountAdded;
}


@end
