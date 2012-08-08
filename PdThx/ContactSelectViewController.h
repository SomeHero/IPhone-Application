//
//  ContactSelectViewController.h
//  PdThx
//
//  Created by James Rhodes on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"
#import "Facebook.h"
#import "PhoneNumberFormatting.h"
#import "IconDownloader.h"
#import "ContactSelectChosenProtocol.h"
#import "ContactTypeSelectViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "TestViewController.h"
#import "DoGoodViewController.h"
#import "DonationContactSelectViewController.h"
#import "SendDonationViewController.h"
#import "SetContactAndAmountProtocol.h"
#import "SetContactProtocol.h"

@interface ContactSelectViewController : UIBaseViewController <ContactTypeSelectWasSelectedDelegate, UITableViewDelegate, UITableViewDataSource, FBRequestDelegate, IconDownloaderDelegate,
    SetContactProtocol, SetContactAndAmountProtocol>
{
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *tvSubview;
    
    TSPopoverController *popoverController;
    Facebook * fBook;
    NSMutableArray * allResults;
    NSMutableArray * filteredResults;
    NSMutableDictionary *fbIconsDownloading;
    id<SetContactProtocol> didSetContact;
    id<SetContactAndAmountProtocol> didSetContactAndAmount;
    id<ContactSelectChosenProtocol> contactSelectChosenDelegate;
    IBOutlet UITextField *txtSearchBox;
    bool isFiltered;
    bool foundFiltered;
}

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tvSubview;
@property (nonatomic, retain) NSMutableArray * allResults;
@property (nonatomic, retain) NSMutableArray * filteredResults;
@property (nonatomic, retain) Facebook * fBook;
@property (nonatomic, retain) NSMutableDictionary *fbIconsDownloading;
@property(assign) id didSetContact;
@property(assign) id didSetContactAndAmount;
@property (assign) id contactSelectChosenDelegate;
@property (nonatomic, retain) UITextField *txtSearchBox;
@property (nonatomic, assign) bool isFiltered;
@property (nonatomic, assign) bool foundFiltered;

- (IBAction)textBoxChanged:(id)sender;

@end