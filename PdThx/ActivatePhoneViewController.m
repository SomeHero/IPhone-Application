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
    // Do any additional setup after loading the view from its nib.
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    [self setTitle: @"Activate"];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"ActivatePhontViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}

- (void)viewDidUnload
{
    [activateButton release];
    activateButton = nil;
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
            NSLog(@"Complete");
            
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
            
            
			break;
            
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}

@end
