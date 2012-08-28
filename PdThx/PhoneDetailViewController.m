//
//  PhoneDetailViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhoneDetailViewController.h"

@interface PhoneDetailViewController ()

@end

@implementation PhoneDetailViewController

@synthesize payPoint;
@synthesize deletePayPointComplete;
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
    // Do any additional setup after loading the view from its nib.
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    
    payPointService = [[PayPointService alloc] init];
    [payPointService setDeletePayPointCompleteDelegate:self];
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    txtPhoneNumber.text = [phoneNumberFormatter stringToFormattedPhoneNumber: payPoint.uri];
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
                         action:@selector(btnVerify:)
               forControlEvents:UIControlEventTouchDown];
        [verifyButton setTitle:@"Verify Pay Point" forState:UIControlStateNormal];
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
-(IBAction)btnRemovePayPoint:(id)sender {
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];

    [appDelegate showWithStatus: @"Removing Pay Point" withDetailedStatus: @"We're un-linking this pay point from your account."];
    
    [payPointService deletePayPoint: payPoint.payPointId forUserId: user.userId];
}
-(IBAction)btnVerify:(id)sender
{
    EnterVerificationCodeViewController* controller = [[EnterVerificationCodeViewController alloc] init];
    
    controller.payPoint = payPoint;
    [controller setVerifyMobilePayPointDelegate: self];
    [controller setTitle : @"Verify"];
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    
    [self.navigationController presentModalViewController:navBar animated:YES]; 
    
    [controller release];
    [navBar release];
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
-(void)deletePayPointFailed: (NSString*) errorMessage {
    [deletePayPointComplete deletePayPointFailed:errorMessage];
}
-(void)verifyMobilePayPointDidComplete: (bool) verified {
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    [verifyMobilePayPointDelegate verifyMobilePayPointDidComplete:YES];
}
-(void)verifyMobilePayPointDidFail: (NSString*) errorMessage {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end
