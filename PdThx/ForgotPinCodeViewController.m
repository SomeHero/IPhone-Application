//
//  ForgotPinCodeViewController.m
//  PdThx
//
//  Created by Edward Mitchell on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForgotPinCodeViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ForgotPinCodeViewController
@synthesize viewPinLock;
@synthesize securityPinSwipeDelegate;
@synthesize tag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)unlockPatternView:(ALUnlockPatternView *)patternView selectedCode:(NSString *)code{
    newSecurityPin = [NSString stringWithString:[code copy]];
    
    controller =[[[CustomSecurityPinSwipeController alloc] init] autorelease];
    [controller setSecurityPinSwipeDelegate: self];
    [controller setNavigationTitle: @"Confirm your New Pin"];
    [controller setHeaderText: @"Confirm your new pin by swiping it again below"];
    
    [self presentModalViewController:controller animated:YES];
    
}
-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin;
{
    if ([newSecurityPin isEqualToString:pin])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Updating" withDetailedStatus:@"Changing security pin"];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        
        [userService setupSecurityPin:[prefs stringForKey:@"userId"] WithPin:newSecurityPin];
    }
    else {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failure" withDetailedStatus:@"New Pin Didn't Match."];
        
    }
}
-(void)swipeDidCancel: (id)sender
{
    [self.navigationController dismissModalViewControllerAnimated: YES];
}
- (void)dealloc
{
    [super dealloc];
    
    [viewPinLock release];
    [securityPinSwipeDelegate release];
    [lblHeader release];
    [headerText release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)viewDidDisappear:(BOOL)animated {
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    userService = [[UserService alloc] init];
    [userService setUserSecurityPinCompleteDelegate:self];
    
    didCancel = false;
    
    ALUnlockPatternView *custom=[[[ALUnlockPatternView alloc] initWithFrame:CGRectMake(0, 0, viewPinLock.frame.size.width, viewPinLock.frame.size.height)] autorelease];
    custom.lineColor= UIColorFromRGB(0xb5e3f0);
    custom.lineWidth=15;
    custom.repeatSelection=YES;
    custom.radiusPercentage=10;
    custom.delegate=self;
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-70x70.png"] forState:UIControlStateNormal];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-selected-70x70.png"] forState:UIControlStateSelected];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-pressed-70x70.png"] forState:UIControlStateHighlighted];
    for (int i=0;i<[custom.cells count];i++) {
        UIButton* b=(UIButton*)[custom.cells objectAtIndex:i];        
        
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        //[b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        b.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        b.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    }
    
    [self.viewPinLock addSubview:custom];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"ChangeSecurityPinController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    //[self.view addSubview: header];
    //[self.view addSubview:body];
}
-(void)viewDidAppear:(BOOL)animated {
    
    //lblHeader.text = headerText;
}
-(void)cancelClicked {
    didCancel = true;
    
    [self dismissModalViewControllerAnimated:YES];
}
-(void) userSecurityPinDidComplete {
    //[spinner stopAnimating];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showSuccessWithStatus:@"Success!" withDetailedStatus:@"Security pin changed"];
}

-(void) userSecurityPinDidFail: (NSString*) message {
    //[spinner stopAnimating];
    
    [self.navigationController popViewControllerAnimated:YES]; 
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Pin change failed"];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:100.0 alpha:0.5];
        titleView.shadowOffset = CGSizeMake(0.0,1.5);
        
        //52.0 54.0 61.0 is the grey he wanted
        titleView.textColor = [UIColor colorWithRed:52.0/255.0 green:54.0/255.0 blue:61.0/255.0 alpha:1.0];
        
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    
    titleView.text = title;
    [titleView sizeToFit];
}@end
