//
//  RequestMoneyController.m
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PdThxAppDelegate.h"
#import "HomeViewController.h"
#import "PayStreamViewController.h"
#import "SendMoneyController.h"
#import "RequestMoneyController.h"
#import "DoGoodViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "Contact.h"
#import "Environment.h"
#import "SignInViewController.h"
#import "RequestMoneyService.h"
#import "ContactSelectViewController.h"
#import "AmountSelectViewController.h"
#import "CustomSecurityPinSwipeController.h"

#define kOFFSET_FOR_KEYBOARD 100.0

@interface RequestMoneyController ()

@end

@implementation RequestMoneyController
@synthesize tabBar;

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
    [tabBar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void) viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;

}
- (void)viewDidLoad
{

    [super viewDidLoad];
    
    tabBar = [[HBTabBarManager alloc]initWithViewController:self topView:self.view delegate:self selectedIndex:3];
    
    /*                  View Setup              */
    /*  --------------------------------------- */
    mainScrollView.frame = CGRectMake(0, 0, 320, 420);
    [mainScrollView setContentSize:CGSizeMake(320, 420)];
    //[whiteBoxView.layer  setCornerRadius:7.0];
    
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    
    /*          Location Services Setup         */
    /*  --------------------------------------- */
    lm = [[CLLocationManager alloc] init];
    if ([lm locationServicesEnabled]) {
        lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyBest;
        lm.distanceFilter = 1000.0f;
        [lm startUpdatingLocation];
    }
    
    
    /*         Button Visiblity Handling        */
    /*  --------------------------------------- */
    chooseRecipientButton.backgroundColor = [UIColor clearColor];
    chooseAmountButton.backgroundColor = [UIColor clearColor];
    [recipientImageButton.layer setCornerRadius:5.0];
    [recipientImageButton.layer setMasksToBounds:YES];
    [recipientImageButton.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [recipientImageButton.layer setBorderWidth:0.7]; // 28 24 20
    
    
    
    /*          Services/ViewController Initialization         */
    /*  ------------------------------------------------------ */
    requestMoneyService = [[RequestMoneyService alloc] init];
    [requestMoneyService setRequestMoneyCompleteDelegate: self];
     

    /*                TextField Initialization                 */
    /*  ------------------------------------------------------ */
    autoCompleteArray = [[NSMutableArray alloc] init];
    recipientUri = [[NSString alloc] initWithString: @""];
    amount = [[NSString alloc] initWithString: @""];
    
    txtComments.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedCommentBox:) name:@"UITextViewTextDidChangeNotification" object:nil];
    
    
    comments = [[NSString alloc] initWithString: @""];
    
    [self setTitle:@"Request $"];
    
    [txtAmount setDelegate:self];
    txtAmount.text = @"0.00";
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"RequestMoneyController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    attachPictureButton.hidden = YES;
    /*          Image Attachment Handling           */
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
        attachPictureButton.hidden = NO;
}

- (void)viewDidUnload
{
    tabBar = nil;
    [lm stopUpdatingLocation];
    [attachPictureButton release];
    attachPictureButton = nil;
    [characterCountLabel release];
    characterCountLabel = nil;
    [characterCountLabel release];
    characterCountLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
        // Already the current view controller
        /*
        //Switch to the groups tab
        HomeViewController *gvc = [[HomeViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
        */
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
