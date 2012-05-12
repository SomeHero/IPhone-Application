//
//  HomeViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "PdThxAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation HomeViewController

@synthesize moneyView, lblUserName, lblMoneySent, lblMoneyReceived;
@synthesize viewPanel;
@synthesize btnRequestMoney, btnSendMoney;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)dealloc
{
    [viewPanel release];
    [moneyView release];
    [lblUserName release];
    [lblMoneySent release];
    [lblMoneyReceived release];
    [btnRequestMoney release];
    [btnSendMoney release];
    [userService release];
    [signInViewController release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    //setup internal viewpanel
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    [[moneyView layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[moneyView layer] setBorderWidth:1];
    
    [lblUserName setTextColor: UIColorFromRGB(0x51a5ba)];
    [lblMoneySent setTextColor: UIColorFromRGB(0x196779)]; 
    [lblMoneyReceived setTextColor: UIColorFromRGB(0x1c8839)];
    
    [self setTitle: @"Home"];
    //[self.parentViewController.navigationItem setHidesBackButton:YES animated:NO];

    userService = [[UserService alloc] init];

}
#pragma mark - View lifecycle
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userId"];
    
    if([userId length] == 0)
    {
        signInViewController = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        
        [signInViewController setSignInCompleteDelegate: self];
        [signInViewController setAchSetupCompleteDelegate:self];
        
        [self.navigationController pushViewController:signInViewController animated:NO];
        
        [self.navigationItem setBackBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];
                                       
    } else {
        [userService setUserInformationCompleteDelegate: self];
        
        [userService getUserInformation:userId];
    }
}
-(void)userInformationDidComplete:(User*) user {

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];

    lblUserName.text = user.mobileNumber;
    lblMoneySent.text = [numberFormatter stringFromNumber:user.totalMoneySent];
    lblMoneyReceived.text = [numberFormatter stringFromNumber:user.totalMoneyReceived];

    [numberFormatter release];
}
-(void)signInDidComplete {
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}
-(void)achSetupDidComplete {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}
-(void) signOutClicked {
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate signOut];
   
    UINavigationController *navController = self.navigationController;

    signInViewController = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    [signInViewController setSignInCompleteDelegate: self];
    [signInViewController setAchSetupCompleteDelegate:self];
    
    [navController pushViewController:signInViewController animated: YES];
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

-(IBAction) btnRequestMoneyClicked:(id) sender {
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate switchToRequestMoneyController];    
}
-(IBAction) btnSendMoneyClicked:(id) sender {
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate switchToSendMoneyController];
}

@end
