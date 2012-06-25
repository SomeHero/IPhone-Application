//
//  PersonalizeViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonalizeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PdThxAppDelegate.h"
#import "User.h"
#import "ASIFormDataRequest.h"
#import "ChoosePictureViewController.h"

@interface PersonalizeViewController ()

@end

@implementation PersonalizeViewController

@synthesize firstNameField, lastNameField, userImageButton, saveContinueButton;

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
    
    [self setTitle: @"Personalize"];
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    
    userService = [[UserService alloc] init];
    [userService setPersonalizeUserCompleteDelegate: self];
    
    [userImageButton.layer setCornerRadius:6.0];
    [userImageButton.layer setMasksToBounds:YES];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"PersonalizeViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}   
-(void)viewDidAppear:(BOOL)animated {

    if(user.firstName != (id)[NSNull null] && [user.firstName length] > 0)
        firstNameField.text = user.firstName;
    else
        firstNameField.text = @"";
    
    if(user.lastName != (id)[NSNull null] && [user.lastName length] > 0)
        lastNameField.text = user.lastName;
    else
        lastNameField.text = @"";
    
    if([user.imageUrl length] > 0)
    {
        [userImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: user.imageUrl]]] forState:UIControlStateNormal];
    }
    else {
        [userImageButton setBackgroundImage:[UIImage imageNamed: @"avatar_unknown.jpg"] forState:UIControlStateNormal];
    }
}
- (void)viewDidUnload
{
    [userImageButton release];
    userImageButton = nil;
    [firstNameField release];
    firstNameField = nil;
    [lastNameField release];
    lastNameField = nil;
    [saveContinueButton release];
    saveContinueButton = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [userImageButton release];
    [firstNameField release];
    [lastNameField release];
    [saveContinueButton release];
    [userService release];
    [super dealloc];
}
- (IBAction)pressedSaveContinue:(id)sender 
{
    [userService personalizeUser:user.userId WithFirstName:firstNameField.text withLastName:lastNameField.text withImage: @""];
}
-(void) personalizeUserDidComplete {
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
}
-(void) personalizeUserDidFail:(NSString*) response {
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
}
-(IBAction) bgTouched:(id) sender {
    [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
}


- (void)uploadRequestFinished:(ASIHTTPRequest *)request{    
    NSString *responseString = [request responseString];
    NSLog(@"Upload response %@", responseString);
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[[request error] localizedDescription]); 
}

-(IBAction) chooseImageClicked:(id) sender {
    ChoosePictureViewController* controller = [[ChoosePictureViewController alloc] init];
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    [controller setTitle: @"Select Picture"];
    
    [self presentModalViewController:navBar animated:YES];
    [navBar release];
    [controller release];
}
@end
