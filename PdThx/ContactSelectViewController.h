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


@interface ContactSelectViewController : UIBaseViewController <UITableViewDelegate, UITableViewDataSource, FBRequestDelegate, IconDownloaderDelegate>
{
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *tvSubview;
    Facebook * fBook;
    NSMutableArray * allResults;
    NSMutableArray * filteredResults;
    NSMutableDictionary *fbIconsDownloading;
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
@property (nonatomic, retain) PhoneNumberFormatting *phoneNumberFormatter;
@property (nonatomic, retain) NSMutableDictionary *fbIconsDownloading;
@property (assign) id contactSelectChosenDelegate;
@property (nonatomic, retain) UITextField *txtSearchBox;
@property (nonatomic, assign) bool isFiltered;
@property (nonatomic, assign) bool foundFiltered;

- (IBAction)textBoxChanged:(id)sender;

@end