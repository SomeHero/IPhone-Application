//
//  CustomAlertViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertViewController.h"

@interface CustomAlertViewController ()

@end

@implementation CustomAlertViewController

@synthesize topTitleLabel, subTitleLabel, resultImageView, detailedTextView, leftButton, rightButton, alertViewDelegate;

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
}

- (void)viewDidUnload
{
    [resultImageView release];
    resultImageView = nil;
    [topTitleLabel release];
    topTitleLabel = nil;
    [subTitleLabel release];
    subTitleLabel = nil;
    [detailedTextView release];
    detailedTextView = nil;
    [leftButton release];
    leftButton = nil;
    [rightButton release];
    rightButton = nil;
    [txtField release];
    txtField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [resultImageView release];
    [topTitleLabel release];
    [subTitleLabel release];
    [detailedTextView release];
    [leftButton release];
    [rightButton release];
    [txtField release];
    [super dealloc];
}
- (IBAction)pressedLeftButton:(id)sender {
    if ( self.txtField.hidden == NO )
        [alertViewDelegate didSelectButtonWithIndex:0 withEnteredText:self.txtField.text];
    else
        [alertViewDelegate didSelectButtonWithIndex:0];
}

- (IBAction)pressedRightButton:(id)sender {
    if ( self.txtField.hidden == NO )
        [alertViewDelegate didSelectButtonWithIndex:1 withEnteredText:self.txtField.text];
    else
        [alertViewDelegate didSelectButtonWithIndex:0];
}
@end
