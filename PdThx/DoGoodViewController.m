//
//  DoGoodViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
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
    [[viewPanel layer] setBorderWidth:1.5];
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

-(IBAction)btnDonateClicked:(id)sender {
    SendDonationViewController* controller = [[SendDonationViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}
-(IBAction)btnAcceptPledgeClicked:(id)sender {
    AcceptPledgeViewController* controller = [[AcceptPledgeViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}



- (void)tabBarClicked:(NSUInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        //Switch to the groups tab
        HomeViewController *gvc = [[HomeViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
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
        // Already the current view controller
        /*
        //Switch to the groups tab
        DoGoodViewController *gvc = [[DoGoodViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
         */
    }
}


@end
