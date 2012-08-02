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

@synthesize payPoint;

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
    
    payPointService = [[PayPointService alloc] init];
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;

    txtEmailAddress.text = payPoint.uri;
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
    controller.phoneNumber = payPoint.uri;
    [self.navigationController pushViewController:controller animated:YES]; 
    [controller setTitle : @"Verify"];
   
    [controller release];
}
-(IBAction)btnResendCodes
{
    [payPointService resendEmailVerificationLink:payPoint.payPointId forUserId:user.userId];
}
- (void)dealloc {
    [txtEmailAddress release];
    [super dealloc];
}
@end
