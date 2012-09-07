//
//  EnablePaymentsNoMoneyWaitingViewController.m
//  PdThx
//
//  Created by Christopher Magee on 9/6/12.
//
//

#import "EnablePaymentsNoMoneyWaitingViewController.h"
#import "AddACHOptionsViewController.h"
#import "PdThxAppDelegate.h"

@interface EnablePaymentsNoMoneyWaitingViewController ()

@end

@implementation EnablePaymentsNoMoneyWaitingViewController

@synthesize addBankAccountButton, remindMeLaterButton, navBar;

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
    
    SetupNavigationView *setupNavBar = [[SetupNavigationView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
    [setupNavBar setActiveState:@"Enable Payments" withJoinComplete:YES whereActivateComplete:YES wherePersonalizeComplete:YES whereEnableComplete:NO];
    [navBar addSubview:setupNavBar];
    
    [self setTitle: @"Enable Payments"];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.leftBarButtonItem =nil;
}

- (void)viewDidUnload
{
    [addBankAccountButton release];
    addBankAccountButton = nil;
    [remindMeLaterButton release];
    remindMeLaterButton = nil;
    [navBar release];
    navBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [addBankAccountButton release];
    [remindMeLaterButton release];
    [navBar release];
    [super dealloc];
}

- (IBAction)pressedAddBankAccountButton:(id)sender
{
    [self.navigationController pushViewController:[[AddACHOptionsViewController alloc] init] animated:YES];
    
    // Get the list of view controllers
    NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [allViewControllers removeObjectIdenticalTo:self];
    [[self navigationController] setViewControllers:allViewControllers animated:NO];
    
    [allViewControllers release];
}

- (IBAction)pressedRemindMeLaterButton:(id)sender
{
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow:self];
}
@end