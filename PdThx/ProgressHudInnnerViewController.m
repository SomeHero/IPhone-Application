//
//  ProgressHudInnnerViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressHudInnnerViewController.h"
#import "PdThxAppDelegate.h"

@interface ProgressHudInnnerViewController ()

@end

@implementation ProgressHudInnnerViewController


@synthesize topLabel, detailLabel, activityIndicator, imgView, dismissButton;

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [dismissButton release];
    dismissButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [dismissButton release];
    [super dealloc];
}
- (IBAction)pressedDismiss:(id)sender {
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) dismissProgressHUD];
}
@end
