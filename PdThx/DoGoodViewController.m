//
//  DoGoodViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DoGoodViewController.h"
#import "PdThxAppDelegate.h"

@interface DoGoodViewController ()

@end

@implementation DoGoodViewController

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
@end
