//
//  ActivatePhoneViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivatePhoneViewController.h"
#import "PdThxAppDelegate.h"

@interface ActivatePhoneViewController ()

@end

@implementation ActivatePhoneViewController

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
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];
    
    // Do any additional setup after loading the view from its nib.
    
    SetupNavigationView *setupNavBar = [[SetupNavigationView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
    [setupNavBar setActiveState:@"Activate" withJoinComplete:YES whereActivateComplete:NO wherePersonalizeComplete:NO whereEnableComplete:NO];
    
    [navBar addSubview:setupNavBar];
    
    [self setTitle: @"Activate Phone"];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"ActivatePhontViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}

- (void)viewDidUnload
{
    [remindMeLaterButton release];
    remindMeLaterButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [activateButton release];
    [remindMeLaterButton release];
    [registrationKey release];
    [super dealloc];
}
- (IBAction)pressedActivate:(id)sender 
{
    [self sendInAppSMS: self];
}

- (IBAction)pressedRemindMeLater:(id)sender
{
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
    
}

-(IBAction) sendInAppSMS:(id) sender
{
	MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
	if([MFMessageComposeViewController canSendText])
	{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        controller.title = @"Verify Device";
		controller.body = [prefs stringForKey: @"userId"];
		controller.recipients = [NSArray arrayWithObjects:@"2892100266", nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) 
    {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
            
			break;
		case MessageComposeResultFailed:
            
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
            
			break;
		case MessageComposeResultSent:
            NSLog(@"Text Message Sent!");
            /*
            PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate showSuccessWithStatus:@"Message Sent" withDetailedStatus:@"Thank you"];
            */
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}

@end
