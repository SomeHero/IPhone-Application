//
//  AddACHOptionsViewController.m
//  PdThx
//
//  Created by Christopher Magee on 9/5/12.
//
//

#import "AddACHOptionsViewController.h"
#import "PdThxAppDelegate.h"

@interface AddACHOptionsViewController ()

@end

@implementation AddACHOptionsViewController

@synthesize takePictureButton, enterManuallyButton, navBar;
@synthesize achSetupComplete;

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
    
    SetupNavigationView *setupNavBar = [[SetupNavigationView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
    [setupNavBar setActiveState:@"Enable Payments" withJoinComplete:YES whereActivateComplete:YES wherePersonalizeComplete:YES whereEnableComplete:NO];
    [navBar addSubview:setupNavBar];
    
    [self setTitle: @"Enable Payments"];
}

- (void)viewDidUnload
{
    [takePictureButton release];
    takePictureButton = nil;
    [enterManuallyButton release];
    enterManuallyButton = nil;
    [navBar release];
    navBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.leftBarButtonItem =nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [takePictureButton release];
    [enterManuallyButton release];
    [navBar release];
    [super dealloc];
}


- (IBAction)pressedTakePictureButton:(id)sender
{
    AddACHAccountViewController *achController = [[[AddACHAccountViewController alloc] init] autorelease];
    [self.navigationController pushViewController:achController animated:YES];
    [achController takePictureOfCheck];

}

- (IBAction)pressedEnterManuallyButton:(id)sender
{
    // Load the exact same view controller, but call the camera function manually (no button press)
    AddACHAccountViewController* achController = [[[AddACHAccountViewController alloc] init] autorelease];
    [achController setAchSetupComplete: self];
    
    [self.navigationController pushViewController:achController animated:YES];
}
-(void)achSetupDidComplete {
    [self.navigationController popViewControllerAnimated:NO];
    [achSetupComplete achSetupDidComplete];
}
-(void)userACHSetupDidFail:(NSString*) message withErrorCode:(int)errorCode {
    [achSetupComplete achSetupDidFail:message withErrorCode:errorCode];
}



@end
