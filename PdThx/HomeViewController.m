//
//  HomeViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "PayStreamViewController.h"
#import "SendMoneyController.h"
#import "RequestMoneyController.h"
#import "DoGoodViewController.h"


#import "PdThxAppDelegate.h"
#import "PhoneNumberFormatting.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation HomeViewController

@synthesize lblUserName;
@synthesize viewPanel;
@synthesize btnRequestMoney, btnSendMoney, tabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"Home"];
    }
    return self;
}

- (void)dealloc
{
    [tabBar release];
    [viewPanel release];
    [lblUserName release];
    [btnRequestMoney release];
    [btnSendMoney release];
    [userService release];

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
    
    tabBar = [[HBTabBarManager alloc]initWithViewController:self topView:self.view delegate:self selectedIndex:0];
    
    // Do any additional setup after loading the view from its nib.
    //setup internal viewpanel
    userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:0.0]; // Old Width 1.0
    [[viewPanel layer] setCornerRadius: 8.0];
    
    [btnUserImage.layer setCornerRadius:6.0];
    [btnUserImage.layer setMasksToBounds:YES];
    [btnUserImage.layer setBorderWidth:0.2];
    [btnUserImage.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];

    UIImage *imgSendMoneyActive  = [UIImage imageNamed:@"btn-send-146x130-active.png"];
    [btnSendMoney setImage:imgSendMoneyActive forState:UIControlStateHighlighted];

    UIImage *imgRequestMoneyActive  = [UIImage imageNamed:@"btn-request-146x130-active.png"];
    [btnRequestMoney setImage:imgRequestMoneyActive forState:UIControlStateHighlighted];

    UIImage *imgProfileActive = [UIImage imageNamed: @"btn-profile-308x70-active.png"];
    [btnProfile setImage: imgProfileActive forState:UIControlStateHighlighted];
    
    UIImage *imgPaystreamActive = [UIImage imageNamed: @"btn-paystream-292x42-active.png"];
    [btnPaystream setImage:imgPaystreamActive forState:UIControlStateHighlighted];
    
    [self setTitle: @"Home"];
    //[self.parentViewController.navigationItem setHidesBackButton:YES animated:NO];
}
#pragma mark - View lifecycle
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userId"];

    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Loading" withDetailedStatus:@"Getting profile"];
    
    [userService getUserInformation:userId];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    lblUserName.text = @"";
    lblScore.text = @"";
    lblPayPoints.text = @"";
    lblPaystreamCount.text = @"";
}

-(void)userInformationDidComplete:(User*) currentUser
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];

    ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user = [currentUser mutableCopy];
    
    if (currentUser.securityQuestion != (id) [NSNull null] && currentUser.securityQuestion.length > 0) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setValue:currentUser.securityQuestion forKey:@"securityQuestion"];
        [prefs synchronize];
    }
    
    if(currentUser.imageUrl != (id)[NSNull null] && [currentUser.imageUrl length] > 0) {
        [btnUserImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: currentUser.imageUrl]]] forState:UIControlStateNormal];
    }else {
        [btnUserImage setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
    }
    
    lblUserName.text = currentUser.preferredName;
    if ( [[currentUser.userName substringToIndex:3] isEqualToString:@"fb_"] )
        lblPayPoints.text = @"Facebook User";
    else
        lblPayPoints.text = currentUser.userName;
    
    lblScore.text = [NSString stringWithFormat: @"%d", [user.instantLimit intValue]];
    lblIncreaseScore.text = @"+ Link your Facebook Account";
    lblPaystreamCount.text = [NSString stringWithFormat: @"%d", currentUser.numberOfPaystreamUpdates];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];

    [numberFormatter release];
}

-(void)userInformationDidFail:(NSString*) message withErrorCode:(int)errorCode {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
}
- (void)viewDidUnload
{
    self.tabBar = nil;
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
    [self tabBarClicked:3];
}
-(IBAction) btnSendMoneyClicked:(id) sender {
    [self tabBarClicked:2];
}
-(IBAction) btnProfileClicked:(id) sender {
    
    EditProfileViewController* controller = [[EditProfileViewController alloc] init];
    [controller setTitle: @"Me"];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
-(IBAction) btnPaystreamClicked: (id) sender {
    [self tabBarClicked:1];
}

-(IBAction) btnIncreaseScoreClicked: (id) sender {
    IncreaseProfileViewController* controller = [[IncreaseProfileViewController alloc] init];
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    //[controller setTitle: @"Add Your FaceBook Account"];
    //[controller setHeaderText: @"Add another bank account by entering the account information below"];
    
    [self presentModalViewController:navBar animated:YES];
    [navBar release];
    [controller release];
}


- (void)tabBarClicked:(NSUInteger)buttonIndex
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //NSLog(@"Switching to tab index:%d",buttonIndex);
    UIViewController* newView = [appDelegate switchMainAreaToTabIndex:buttonIndex fromViewController:self];
    
    //NSLog(@"NewView: %@",newView);
    if ( newView != nil  && ! [self isEqual:newView])
    {
        //NSLog(@"Switching views, validated that %@ =/= %@",[self class],[newView class]);
        
        [[self navigationController] pushViewController:newView animated:NO];
        
        // Get the list of view controllers
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
}




@end
