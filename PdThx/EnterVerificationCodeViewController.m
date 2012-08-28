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
    [txtVerificationCode becomeFirstResponder];
    
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
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [payPointService verifyMobilePayPoint: txtVerificationCode.text forPayPointId:payPoint.payPointId forUserId: user.userId];
    
    [appDelegate showWithStatus: @"Verifying Mobile #" withDetailedStatus: @""];
}
-(void)verifyMobilePayPointDidComplete: (bool) verified {
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [appDelegate dismissProgressHUD];
        
        if(verified)
        {
            [appDelegate showSuccessWithStatus: @"Mobile Number Verified!" withDetailedStatus: @"We successfully verified this pay point.  You will now be able to receive money at this mobile number."]; 
            
            payPoint.verified = true;
            
            [verifyMobilePayPointDelegate verifyMobilePayPointDidComplete:YES];
        }
        else {
            [appDelegate showTwoButtonAlertView:NO withTitle: @"Verification Failed" withSubtitle: @"Unable to verify this pay point"  withDetailedText:@"The verification code that you entered did not match our records.  Until you verify this mobile # you will not be able to receive funds at this pay point.  Please try again." withButton1Text: @"Try Again" withButton2Text:@"Cancel" withDelegate:self];
        }
    });


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
        
        [txtVerificationCode becomeFirstResponder];
    } else {
        // Successful error Phone Number
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        
        [verifyMobilePayPointDelegate verifyMobilePayPointDidFail: @""];
        
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
