//
//  DoGoodViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewControllerV2.h"
#import "PayStreamViewController.h"
#import "SendMoneyController.h"
#import "RequestMoneyController.h"
#import "DoGoodViewController.h"
#import "PdThxAppDelegate.h"

@interface DoGoodViewController ()

@end

@implementation DoGoodViewController
@synthesize tabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view = viewPanel;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tabBar = [[HBTabBarManager alloc]initWithViewController:self topView:self.view delegate:self selectedIndex:4];
    
    [self setTitle:@"Do Good"];
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [viewPanel.layer setMasksToBounds:YES];
    [[viewPanel layer] setBorderWidth:0.0]; // Old Width 1.0
    [[viewPanel layer] setCornerRadius: 8.0];
    
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"DoGoodViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}


- (void)viewDidUnload
{
    tabBar = nil;
    [viewPanel release];
    viewPanel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tabBar release];
    [viewPanel release];
    [super dealloc];
}

-(IBAction)btnDonateClicked:(id)sender
{
    SendDonationViewController* controller = [[SendDonationViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

-(IBAction)btnAcceptPledgeClicked:(id)sender
{
    AcceptPledgeViewController* controller = [[AcceptPledgeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
    
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
