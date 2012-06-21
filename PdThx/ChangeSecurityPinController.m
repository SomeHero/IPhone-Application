//
//  ChangeSecurityPinController.m
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ChangeSecurityPinController.h"


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ChangeSecurityPinController

@synthesize viewPinLock;
@synthesize securityPinSwipeDelegate;
@synthesize lblHeader;
@synthesize navigationTitle;
@synthesize headerText;
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
    oldSecurityPin = [NSString stringWithString:[code copy]];

    controller =[[[CustomSecurityPinSwipeController alloc] init] autorelease];
    [controller setSecurityPinSwipeDelegate: self];
    [controller setNavigationTitle: @"Select a New Pin"];
    [controller setHeaderText: @"Select a new pin by connecting atleast 4 buttons below"];
    [controller setTag:1];
    
    [self presentModalViewController:controller animated:YES];
    
}
-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin;
{
    if([sender tag] == 1)
    {
        newSecurityPin = pin;
        
        controller=[[[CustomSecurityPinSwipeController alloc] init] autorelease];
        [controller setSecurityPinSwipeDelegate: self];
        [controller setNavigationTitle: @"Confirm your Pin"];
        [controller setHeaderText: [NSString stringWithFormat:@"To complete setting up your account, create a pin by connecting 4 buttons below."]];
        [controller setTag:2];    
        [self presentModalViewController:controller animated:YES];
    }
    else if([sender tag] == 2)
        [userService changeSecurityPin:user.userId WithOld:oldSecurityPin AndNew:newSecurityPin];
}
-(void)swipeDidCancel: (id)sender
{
    //do nothing
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
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-60x60.png"] forState:UIControlStateNormal];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-selected-60x60.png"] forState:UIControlStateSelected];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-pressed-60x60.png"] forState:UIControlStateHighlighted];
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
    
    [self showAlertView: @"Security Pin Change Success!" withMessage: @"Security Pin successfully changed."];
}

-(void) userSecurityPinDidFail: (NSString*) message {
    //[spinner stopAnimating];
    
    [self.navigationController popViewControllerAnimated:YES]; 
    
    [self showAlertView: @"Security Pin Change Failed" withMessage: message];
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

@end
