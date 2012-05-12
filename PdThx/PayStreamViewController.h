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

@class UITransactionTableViewCell;

@interface PayStreamViewController : UIBaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    IBOutlet UIView *viewPanel;
    IBOutlet UITableView *transactionsTableView;
    NSMutableData *responseData;
    NSMutableArray *transactions;
    NSMutableArray *sections;
    NSMutableDictionary* transactionsDict;
    NSURLConnection *transactionConnection;
    SignInViewController* signInViewController;
}
@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITableView *transactionsTableView;


@end
