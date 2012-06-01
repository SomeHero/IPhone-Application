//
//  ContactSelectViewController.h
//  PdThx
//
//  Created by James Rhodes on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "PhoneNumberFormatting.h"
#import "IconDownloader.h"
#import "ContactSelectChosenProtocol.h"

@interface ContactSelectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FBRequestDelegate, IconDownloaderDelegate>
{
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *tvSubview;
    Facebook * fBook;
    NSMutableArray * allResults;
    PhoneNumberFormatting *phoneNumberFormatter;
    NSMutableDictionary *fbIconsDownloading;
    id<ContactSelectChosenProtocol> contactSelectChosenDelegate;
<<<<<<< HEAD
=======
    IBOutlet UITextField *txtSearchBox;
>>>>>>> origin/web-api-chris
}

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tvSubview;
@property (nonatomic, retain) NSMutableArray * allResults;
@property (nonatomic, retain) Facebook * fBook;
@property (nonatomic, retain) PhoneNumberFormatting *phoneNumberFormatter;
@property (nonatomic, retain) NSMutableDictionary *fbIconsDownloading;
@property (assign) id contactSelectChosenDelegate;
<<<<<<< HEAD

@end
=======
@property (nonatomic, retain) UITextField *txtSearchBox;

@end
>>>>>>> origin/web-api-chris
