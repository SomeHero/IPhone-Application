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
    [payPointService deletePayPoint: payPoint.payPointId forUserId: user.userId];
}
-(void)deletePayPointCompleted {
    [deletePayPointComplete deletePayPointCompleted];
}
-(void)deletePayPointFailed: (NSString*) errorMessage {
    [deletePayPointComplete deletePayPointFailed:errorMessage];
}
@end
