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

@synthesize takePictureButton, enterManuallyButton;

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
    // Load the exact same view controller, but call the camera function manually (no button press)
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
}

- (IBAction)pressedEnterManuallyButton:(id)sender
{
    // Load AddACHAccountController and push
    
}
@end
