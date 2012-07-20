//
//  VerifyEmailViewController.m
//  PdThx
//
//  Created by Justin Cheng on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VerifyEmailViewController.h"
#import "EnterVerificationCodeViewController.h"
#import "UIProfileTableViewCell.h"
#import "PhoneListViewController.h"
#import "PdThxAppDelegate.h"
#import "PayPoint.h"
@interface VerifyEmailViewController ()

@end

@implementation VerifyEmailViewController
@synthesize emailAddress;
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
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"payPointType == 'Phone'"];
    emailAddresses = [[user.payPoints filteredArrayUsingPredicate:  predicate] copy];  
    txtEmailAddress.text = emailAddress;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [txtEmailAddress release];
    txtEmailAddress = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)btnVerify
{
    EnterVerificationCodeViewController* controller = [[EnterVerificationCodeViewController alloc] init];
    controller.phoneNumber = emailAddress;
    [self.navigationController pushViewController:controller animated:YES]; 
    [controller setTitle : @"Verify"];
   
    [controller release];
}
-(IBAction)btnResendCodes
{
    //Service to resend codes
}
- (void)dealloc {
    [txtEmailAddress release];
    [super dealloc];
}
@end
