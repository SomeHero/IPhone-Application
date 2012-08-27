//
//  VerifyPhoneNumberViewController.m
//  PdThx
//
//  Created by Justin Cheng on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VerifyPhoneNumberViewController.h"
#import "EnterVerificationCodeViewController.h"
#import "UIProfileTableViewCell.h"
#import "PhoneListViewController.h"
#import "PdThxAppDelegate.h"
#import "PayPoint.h"

@interface VerifyPhoneNumberViewController ()
@end
@implementation VerifyPhoneNumberViewController

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
   
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;

    txtPhoneNumber.text = [phoneNumberFormatter stringToFormattedPhoneNumber: payPoint.uri];
    
    payPointService = [[PayPointService alloc] init];
   
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [txtPhoneNumber release];
    txtPhoneNumber = nil;
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
    
    controller.payPoint = payPoint;
    
    [controller setTitle : @"Verify"];

    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    
    [self.navigationController presentModalViewController:navBar animated:YES]; 
    
    [controller release];
    [navBar release];
}
-(IBAction)btnResendCodes
{
    [payPointService resendMobileVerificationCode:payPoint.payPointId forUserId:user.userId];
}
- (void)dealloc {
    [txtPhoneNumber release];
    [super dealloc];
}
@end
