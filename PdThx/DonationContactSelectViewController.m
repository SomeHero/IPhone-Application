//
//  DonationContactSelectViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DonationContactSelectViewController.h"
#import "ContactTableViewCell.h"
#import "Contact.h"
#import "PhoneNumberFormatting.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>
#import "Facebook.h"
#import "PdThxAppDelegate.h"
#import "IconDownloader.h"

@interface DonationContactSelectViewController ()

@end

@implementation DonationContactSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableCellViewName = @"DoGoodUITableCellViewController";
        
        // Custom initialization
        fBook = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fBook;
        
        allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).organizations;
        
        filteredResults = [[NSMutableArray alloc] init];
        for ( int i = 0 ; i < 28 ; i ++ )
            [filteredResults addObject:[[NSMutableArray alloc] init]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    txtSearchBox.frame =  CGRectMake(txtSearchBox.frame.origin.x, txtSearchBox.frame.origin.y, txtSearchBox.frame.size.width, 40);
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          allResults forKey:@"contacts"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrganizationList" object:self userInfo:dict];

    self.fbIconsDownloading = [NSMutableDictionary dictionary];
}

@end
