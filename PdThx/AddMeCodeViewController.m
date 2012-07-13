//
//  AddMeCodeViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddMeCodeViewController.h"

@interface AddMeCodeViewController ()

@end

@implementation AddMeCodeViewController

@synthesize addPayPointComplete;

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
    payPointService = [[PayPointService alloc] init];
    [payPointService setAddPayPointCompleteDelegate:self];
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
-(IBAction)btnSubmitClicked {
    [payPointService addPayPoint:txtMeCode.text ofType:@"MeCode" forUserId: user.userId];
}
-(void)addPayPointsDidComplete {
    [addPayPointComplete addPayPointsDidComplete];
}
-(void)addPayPointsDidFail: (NSString*) errorMessage {
    [addPayPointComplete addPayPointsDidFail:errorMessage];
}
@end
