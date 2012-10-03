//
//  ChooseAddACHMethodViewController.m
//  PdThx
//
//  Created by Christopher Magee on 9/7/12.
//
//

#import "ChooseAddACHMethodViewController.h"
#import "NewACHAccountViewController.h"

@interface ChooseAddACHMethodViewController ()

@end

@implementation ChooseAddACHMethodViewController

@synthesize takePictureButton, enterManuallyButton, achSetupDidComplete;

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
    
    [self setTitle: @"Add Bank Account"];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"ACH Delegate in Choose: %@", achSetupDidComplete);
}

- (void)viewDidUnload
{
    [takePictureButton release];
    takePictureButton = nil;
    [enterManuallyButton release];
    enterManuallyButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [takePictureButton release];
    [enterManuallyButton release];
    [super dealloc];
}


- (IBAction)pressedTakePictureButton:(id)sender
{
    NewACHAccountViewController *achController = [[NewACHAccountViewController alloc] init];
    [self.navigationController pushViewController:achController animated:YES];
    
    [achController setAchSetupDidComplete:achSetupDidComplete];
    [achController takePictureOfCheck];
    
    // Get the list of view controllers
    NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [allViewControllers removeObjectIdenticalTo:self];
    [[self navigationController] setViewControllers:allViewControllers animated:NO];
    
    [allViewControllers release];
    [achController release];
}

- (IBAction)pressedEnterManuallyButton:(id)sender
{
    // Load the exact same view controller, but call the camera function manually (no button press)
    NewACHAccountViewController*achController = [[NewACHAccountViewController alloc] init];

    [achController setAchSetupDidComplete:achSetupDidComplete];
    [achController setTitle:@"Add Bank Account"];
    
    [self.navigationController pushViewController:achController animated:YES];
}

@end
