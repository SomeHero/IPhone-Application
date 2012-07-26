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

@synthesize detailInfoButtonClicked;

@synthesize merchantId;

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
    [merchantImage.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [merchantImage.layer setBorderWidth:0.7];
    
    merchantName.lineBreakMode = UILineBreakModeWordWrap;
    merchantName.numberOfLines = 0;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [merchantServices getNonProfitDetail:merchantId];
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
-(void)getNonProfitDetailDidComplete: (NonProfitDetail*) nonProfitDetail {
    merchantName.text = nonProfitDetail.name;
    merchantTagLine.text = nonProfitDetail.tagLine;
    [merchantImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:nonProfitDetail.imageUrl]]] forState:UIControlStateNormal];
    merchantDescription.text = nonProfitDetail.description;
    btnSuggestedAmounted.titleLabel.text = [NSString stringWithFormat:@"Donate %$%0.2f (suggested)", [nonProfitDetail.suggestedAmount doubleValue]];
}
-(void)getNonProfitDetailDidFail: (NSString*) errorMessage {
    
}

@end
