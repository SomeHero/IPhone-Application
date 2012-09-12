//
//  ContactSelectViewController.h
//  PdThx
//
//  Created by James Rhodes on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewControllerV2.h"
#import "PayStreamViewController.h"
#import "SendMoneyController.h"
#import "RequestMoneyController.h"
#import "DoGoodViewController.h"

#import <UIKit/UIKit.h>

#import "PhoneNumberFormatting.h"
#import "IconDownloader.h"
#import "ContactSelectChosenProtocol.h"
#import "DoGoodUITableCellViewController.h"
#import "DetailInfoButtonClicked.h"
#import "UIBaseViewController.h"
#import "CauseSelectDidCompleteProtocol.h"
#import "ContactSelectWasSelectedDelegate.h"
#import "SetContactAndAmountProtocol.h"
#import "SetContactProtocol.h"

@interface DonationContactSelectViewController : UIBaseViewController <UITableViewDelegate, UITableViewDataSource, ContactSelectChosenProtocol, FBRequestDelegate, IconDownloaderDelegate, DetailInfoButtonClicked, SetContactProtocol, SetContactAndAmountProtocol>
{
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *tvSubview;
    
    TSPopoverController *popoverController;
    
    NSMutableArray * allResults;
    NSMutableArray * filteredResults;
    NSMutableDictionary *fbIconsDownloading;
    id<CauseSelectDidCompleteProtocol> causeSelectDidComplete;
    id<SetContactAndAmountProtocol> didSetContactAndAmount;
    id<SetContactProtocol> didSetContact;
    IBOutlet UITextField *txtSearchBox;
    bool isFiltered;
    bool foundFiltered;
    
    NSString* merchantId;
    
}

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tvSubview;
@property (nonatomic, retain) NSMutableArray * allResults;
@property (nonatomic, retain) NSMutableArray * filteredResults;

@property (nonatomic, retain) PhoneNumberFormatting *phoneNumberFormatter;
@property (nonatomic, retain) NSMutableDictionary *fbIconsDownloading;
@property (assign) id causeSelectDidComplete;
@property (assign) id didSetContactAndAmount;
@property(assign) id didSetContact;
@property (nonatomic, retain) UITextField *txtSearchBox;
@property (nonatomic, assign) bool isFiltered;
@property (nonatomic, assign) bool foundFiltered;
@property(nonatomic, retain) NSString* merchant;

- (IBAction)textBoxChanged:(id)sender;

@end