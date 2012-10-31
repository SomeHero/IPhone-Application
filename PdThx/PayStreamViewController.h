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
#import "PaystreamDetailBaseViewController.h"
#import "StyledPullableView.h"
#import "HBTabBarManager.h"

@class UITransactionTableViewCell;

@interface PayStreamViewController : UIBaseViewController <GetPayStreamCompleteProtocol, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IconDownloaderDelegate, PullableViewDelegate, UpdateSeenMessagesProtocol, HBTabBarDelegate> {
    IBOutlet UIView *viewPanel;
    IBOutlet UITableView *transactionsTableView;
    NSMutableData *responseData;
    NSMutableArray *transactions;
    NSMutableArray *filteredTransactions;
    NSMutableArray *sections;
    NSMutableDictionary* transactionsDict;
    NSMutableDictionary * psImagesDownloading;
    NSMutableDictionary* storedTransactionImages;
    
    SignInViewController* signInViewController;
    GetPayStreamService* getPayStreamService;
    IBOutlet UISegmentedControl* ctrlPaystreamTypes;
    
    PaystreamDetailBaseViewController* ctrlDetailView;
    
    UIView *shadedLayer;
    
    //Pull to refresh variables.
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    PaystreamService* streamService;
    UserService *findUserService;
    
    // Track seen paystream items
    NSMutableArray* seenItems;
}

@property (nonatomic, retain) PaystreamDetailBaseViewController* ctrlDetailView;
//Pull to refresh properties
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, retain) NSMutableArray* seenItems;

@property (nonatomic, retain) UserService *findUserService;

@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITableView *transactionsTableView;
@property (nonatomic, retain) NSMutableDictionary * psImagesDownloading;
@property (nonatomic, retain) UISegmentedControl* ctrlPaystreamTypes;

@property (nonatomic, retain) UIView *shadedLayer;

@property (nonatomic, retain) HBTabBarManager *tabBar;

@property (nonatomic, retain) NSMutableDictionary* storedTransactionImages;

-(IBAction)segmentedControlChanged;

-(void)buildTransactionDictionary:(NSMutableArray*) array;

@end
