//
//  EmailAccountDetailViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmailAccountDetailViewController.h"

@interface EmailAccountDetailViewController ()

@end

@implementation EmailAccountDetailViewController

@synthesize payPoint;
@synthesize deletePayPointComplete;
@synthesize resendVerifciationLinkDelegate;

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
    
    txtEmailAddress.text = payPoint.uri;
    
    payPointService = [[PayPointService alloc] init];
    [payPointService setDeletePayPointCompleteDelegate: self];
    [payPointService setResendVerificationLinkDelegate: self];
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    txtEmailAddress.text = payPoint.uri;
    
    if(payPoint.verified)
    {
        [ctrlHeader addSubview: ctrlHeaderVerified];
        
        txtStatus.text = @"Verified";
        
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeButton setBackgroundImage: [UIImage imageNamed:@"buttonTallStandardNA.png"] forState:UIControlStateNormal];
        
        [removeButton addTarget:self 
                         action:@selector(btnRemovePayPoint:)
               forControlEvents:UIControlEventTouchDown];
        [removeButton setTitle:@"Remove Pay Point" forState:UIControlStateNormal];
        [[removeButton titleLabel] setTextColor: [UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:115.0/255.0 alpha:1.0]];
        
        removeButton.frame = CGRectMake(10, 0, 298.0, 62.0);
        
        [ctrlButtonsView addSubview:removeButton];
    }
    else {
        [ctrlHeader addSubview: ctrlHeaderPending];
        
        txtStatus.text = @"Pending Verification";
        
        UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [verifyButton setBackgroundImage: [UIImage imageNamed:@"buttonTallStandardNA.png"] forState:UIControlStateNormal];
        
        [verifyButton addTarget:self 
                         action:@selector(btnResendCodes:)
               forControlEvents:UIControlEventTouchDown];
        [verifyButton setTitle:@"Resend Verification Email" forState:UIControlStateNormal];
        [[verifyButton titleLabel] setTextColor: [UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:115.0/255.0 alpha:1.0]];
        
        verifyButton.frame = CGRectMake(10, 0, 298.0, 62.0);
        
        [ctrlButtonsView addSubview:verifyButton];
        
        UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeButton setBackgroundImage: [UIImage imageNamed:@"buttonTallStandardNA.png"] forState:UIControlStateNormal];
        
        [removeButton addTarget:self 
                         action:@selector(btnRemovePayPoint:)
               forControlEvents:UIControlEventTouchDown];
        [removeButton setTitle:@"Remove Pay Point" forState:UIControlStateNormal];
        [[removeButton titleLabel] setTextColor: [UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:115.0/255.0 alpha:1.0]];
        
        removeButton.frame = CGRectMake(10, 70, 298.0, 62.0);
        
        [ctrlButtonsView addSubview:removeButton];
        
    }
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

-(IBAction)btnRemovePayPoint:(id) sender {
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showWithStatus: @"Removing Pay Point" withDetailedStatus: @"We're un-linking this pay point from your account."];
    
    [payPointService deletePayPoint: payPoint.payPointId forUserId: user.userId];
}
-(IBAction)btnResendCodes:(id)sender
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showWithStatus: @"Sending Verification Email" withDetailedStatus: @"We're sending a verification email to this email account."];
    
    [payPointService resendEmailVerificationLink:payPoint.payPointId forUserId:user.userId];
}
-(void)deletePayPointCompleted {
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [appDelegate dismissProgressHUD];
        
        [deletePayPointComplete deletePayPointCompleted];
    });
}
-(void)deletePayPointFailed: (NSString*) errorMessage withErrorCode:(int)errorCode {
    [deletePayPointComplete deletePayPointFailed:errorMessage withErrorCode:errorCode];
}
-(void)resendVerificationLinkDidComplete {
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [appDelegate dismissProgressHUD];
        
        [appDelegate showSimpleAlertView: YES withTitle:@"Verification Email Sent" withSubtitle: @"" withDetailedText: @"We re-sent your verification email for this pay point.  To complete verification of this email address, click the verification link in the email."  withButtonText: @"OK" withDelegate:self];
        
    });
}
-(void)resendVerificationLinkDidFail: (NSString*) message withErrorCode:(int)errorCode {

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [appDelegate dismissProgressHUD];
            
            [appDelegate handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Sending Link"];
            
        });
    });
}
-(void)didSelectButtonWithIndex:(int)index
{
    
    // Successfully saved image, just go back to personalize screen and load the image.
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate dismissAlertView];
    

}
@end
