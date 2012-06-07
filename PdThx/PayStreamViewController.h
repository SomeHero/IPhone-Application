//
//  PayStreamViewController.h
//  PdThx
//
//  Created by James Rhodes on 4/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"
#import "Transaction.h"
#import "SignInViewController.h"
#import "GetPayStreamService.h"
#import "GetPayStreamCompleteProtocol.h"
#import "PhoneNumberFormatting.h"
#import "IconDownloader.h"
#import "PaystreamBaseViewController.h"
#import "PaystreamIncomingPaymentViewController.h"
#import "PaystreamIncomingRequestViewController.h"
#import "PaystreamOutgoingPaymentViewController.h"
#import "PaystreamOutgoingRequestViewController.h"

@class UITransactionTableViewCell;

@interface PayStreamViewController : UIBaseViewController <GetPayStreamCompleteProtocol, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IconDownloaderDelegate> {
    IBOutlet UIView *viewPanel;
    IBOutlet UITableView *transactionsTableView;
    NSMutableData *responseData;
    NSMutableArray *transactions;
    NSMutableArray *filteredTransactions;
    NSMutableArray *sections;
    NSMutableDictionary* transactionsDict;
    NSMutableDictionary * psImagesDownloading;
    SignInViewController* signInViewController;
    GetPayStreamService* getPayStreamService;
    IBOutlet UISegmentedControl* ctrlPaystreamTypes;
    PaystreamBaseViewController* ctrlDetailView;
}

@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITableView *transactionsTableView;
@property (nonatomic, retain) NSMutableDictionary * psImagesDownloading;
@property (nonatomic, retain) UISegmentedControl* ctrlPaystreamTypes;

-(IBAction)segmentedControlChanged;
-(void)buildTransactionDictionary:(NSMutableArray*) array;

@end
