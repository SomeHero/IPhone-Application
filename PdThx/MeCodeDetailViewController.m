//
//  MeCodeDetailViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeCodeDetailViewController.h"

@interface MeCodeDetailViewController ()

@end

@implementation MeCodeDetailViewController

@synthesize payPoint;
@synthesize deletePayPointComplete;

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
    
    txtMeCode.text = payPoint.uri;
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
-(IBAction)btnRemovePayPoint {
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showWithStatus: @"Removing Pay Point" withDetailedStatus: @"We're un-linking this pay point from your account."];
    
    [payPointService deletePayPoint: payPoint.payPointId forUserId: user.userId];
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
@end
