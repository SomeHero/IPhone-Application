//
//  PayStreamViewController.h
//  PdThx
//
//  Created by James Rhodes on 4/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITransactionTableViewCell.h"
#import "UIBaseViewController.h"
#import "Transaction.h"
#import "SignInViewController.h"
#import "GetPayStreamService.h"
#import "GetPayStreamCompleteProtocol.h"
#import "PhoneNumberFormatting.h"

@class UITransactionTableViewCell;

@interface PayStreamViewController : UIBaseViewController<GetPayStreamCompleteProtocol, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    IBOutlet UIView *viewPanel;
    IBOutlet UITableView *transactionsTableView;
    NSMutableData *responseData;
    NSMutableArray *transactions;
    NSMutableArray *sections;
    NSMutableDictionary* transactionsDict;
    NSURLConnection *transactionConnection;
    SignInViewController* signInViewController;
    GetPayStreamService* getPayStreamService;
}
@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITableView *transactionsTableView;


@end
