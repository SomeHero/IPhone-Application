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
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    [btnUserImage.layer setCornerRadius:6.0];
    [btnUserImage.layer setMasksToBounds:YES];

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

-(void)userInformationDidComplete:(User*) user 
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];

    ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user = [user copy];
    
    if(user.imageUrl != (id)[NSNull null] && [user.imageUrl length] > 0) {
        [btnUserImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: user.imageUrl]]] forState:UIControlStateNormal];
    }else {
        [btnUserImage setBackgroundImage:[UIImage imageNamed: @"avatar_unknown.jpg"] forState:UIControlStateNormal];
    }
    
    lblUserName.text = user.preferredName;
    if ( [[user.userName substringToIndex:3] isEqualToString:@"fb_"] )
        lblPayPoints.text = @"Facebook User";
    else
        lblPayPoints.text = user.userName;
    
    lblScore.text = @"80";
    lblIncreaseScore.text = @"+ Link your Facebook Account";
    lblPaystreamCount.text = [NSString stringWithFormat: @"%d", user.numberOfPaystreamUpdates];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];

    [numberFormatter release];
}

-(void)userInformationDidFail:(NSString*) message {
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
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate switchToRequestMoneyController];    
}
-(IBAction) btnSendMoneyClicked:(id) sender {
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate switchToSendMoneyController];
}
-(IBAction) btnProfileClicked:(id) sender {
    
    EditProfileViewController* controller = [[EditProfileViewController alloc] init];
    [controller setTitle: @"Me"];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
-(IBAction) btnPaystreamClicked: (id) sender {
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate switchToPaystreamController];
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
    if( buttonIndex == 0 )
    {
        //This is the home tab already so don't do anything
    }
    if( buttonIndex == 1 )
    {
        //Switch to the groups tab
        PayStreamViewController *gvc = [[PayStreamViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 2 )
    {
        //Switch to the groups tab
        SendMoneyController *gvc = [[SendMoneyController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 3 )
    {
        //Switch to the groups tab
        RequestMoneyController *gvc = [[RequestMoneyController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 4 )
    {
        //Switch to the groups tab
        DoGoodViewController *gvc = [[DoGoodViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
}



@end