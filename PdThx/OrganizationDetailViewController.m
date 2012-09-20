//
//  OrganizationDetailViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OrganizationDetailViewController.h"

@interface OrganizationDetailViewController ()

@end

@implementation OrganizationDetailViewController

@synthesize contact;
@synthesize detailInfoButtonClicked;
@synthesize didSetContactAndAmount;
@synthesize didSetContact;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    merchantServices = [[MerchantServices alloc] init];
    [merchantServices setMerchantServicesCompleteProtocol: self];
    
    [merchantImage.layer setCornerRadius:5.0];
    [merchantImage.layer setMasksToBounds:YES];
    [merchantImage.layer setBorderWidth:0.2];
    [merchantImage.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    merchantName.lineBreakMode = UILineBreakModeWordWrap;
    merchantName.numberOfLines = 0;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    Merchant* merchant = contact.merchant;
    MerchantListing* listing = [merchant.merchantListings objectAtIndex: 0];
    MerchantOffer* offer = [listing.Offers objectAtIndex: 0];
    
    [merchantName setText: merchant.name];
    if(merchant.imageUrl != nil) {
        [merchantImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:merchant.imageUrl]]] forState:UIControlStateNormal];
    } else {
        [merchantImage setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
    }
    [merchantTagLine setText: listing.TagLine];
    [merchantDescription setText: listing.Description];
    
    [btnSuggestedAmounted setTitle: [NSString stringWithFormat: @"Donate $%0.2f (suggested)", [offer.Amount doubleValue]] forState:UIControlStateNormal];
    [btnSuggestedAmounted setContact:contact];
    [btnSuggestedAmounted setAmount: [offer.Amount doubleValue]];
    
    [btnSuggestedAmounted addTarget:self action:@selector(setContactAndAmountClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnOtherAmount setContact:contact];
    [btnOtherAmount addTarget:self action:@selector(setContactClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void) setContactAndAmountClicked: (id) sender {
    UICustomSetContactAndAmountButton* btn = (UICustomSetContactAndAmountButton*)sender;
    
    [didSetContactAndAmount didSetContactAndAmount:btn.contact amount:btn.amount];
}
- (void) setContactClicked: (id) sender {
    UICustomSetContactButton* btn = (UICustomSetContactButton*)sender;
    
    [didSetContact didSetContact: btn.contact];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
