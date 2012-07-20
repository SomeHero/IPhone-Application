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

@synthesize phoneNumber;


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
    phones = [[user.payPoints filteredArrayUsingPredicate:  predicate] copy];  
    txtPhoneNumber.text = phoneNumber; //((PayPoint*)[phones objectAtIndex:0]).uri;
   
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
    controller.phoneNumber = phoneNumber;
    [self.navigationController pushViewController:controller animated:YES]; 
    [controller setTitle : @"Verify"];
//    [[PhoneNumberTxt setText:[phones objectAtIndex: indexPath.row] uri] ];
    [controller release];
}
-(IBAction)btnResendCodes
{
    //Service to resend codes
}
- (void)dealloc {
    [txtPhoneNumber release];
    [super dealloc];
}
@end
