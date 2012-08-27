//
//  EnterVerificationCodeViewController.m
//  PdThx
//
//  Created by Justin Cheng on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnterVerificationCodeViewController.h"
#import "PdThxAppDelegate.h"
#import "PayPoint.h"

@interface EnterVerificationCodeViewController ()

@end

@implementation EnterVerificationCodeViewController
@synthesize payPoint;
@synthesize verifyMobilePayPointDelegate;

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

    payPointService = [[PayPointService alloc] init];
    [payPointService setVerifyMobilePayPointDelegate: self];
    
    txtPhoneNumber.text = payPoint.uri;
    // Do any additional setup after loading the view from its nib.
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
-(IBAction)btnSubmit
{
    [txtVerificationCode resignFirstResponder];
    
    [payPointService verifyMobilePayPoint: txtVerificationCode.text forPayPointId:payPoint.payPointId forUserId: user.userId];

}
-(void)verifyMobilePayPointDidComplete: (bool) verified {
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(verified)
    {
        [appDelegate showSuccessWithStatus: @"Mobile Number Verified!" withDetailedStatus: @"We successfully verified this pay point.  You will now be able to receive money at this mobile number."]; 
        
        payPoint.verified = true;
        
        [verifyMobilePayPointDelegate verifyMobilePayPointDidComplete:YES];
    }
    else {
        [appDelegate showErrorWithStatus: @"Unable to Verify Mobile Number" withDetailedStatus: @"We were unable to verify this pay point.  Please try again."];
    }
}
-(void)verifyMobilePayPointDidFail: (NSString*) errorMessage {
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showErrorWithStatus: @"Unable to Verify Mobile Number" withDetailedStatus: @"We were unable to verify this pay point.  Please try again."];
}

-(void)didSelectButtonWithIndex:(int)index
{
    if ( index == 0 ) {
        // Dismiss, error Phone Number validated
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
    } else {
        // Successful error Phone Number
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        
        // TODO: There needs to be a protocol here to load the image as being on top.
    }
}

- (void)dealloc {
    [txtVerificationCode release];
    [txtPhoneNumber release];
    [payPointService release];
    [payPoint release];
     
    [super dealloc];
}
@end
