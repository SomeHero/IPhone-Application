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
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];

    SetupNavigationView *setupNavBar = [[SetupNavigationView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
    [setupNavBar setActiveState:@"Personalize" withJoinComplete:YES whereActivateComplete:YES wherePersonalizeComplete:NO whereEnableComplete:NO];

    [navBar addSubview:setupNavBar];
    
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:[[UIView new] autorelease]] autorelease]];
    
    [self setTitle: @"Personalize"];
    firstNameField.delegate = self;
    lastNameField.delegate = self;
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    NSLog(@"User objects: %@ %@ %@", user.firstName, user.lastName, user.imageUrl);
    
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
        [userImageButton setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
    }
        
    self.navigationItem.leftBarButtonItem = nil;   
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}
- (IBAction)pressedSaveContinue:(id)sender 
{
    [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString* imageUrl = @"";
    
    if(user.imageUrl != (id)[NSNull null])
        imageUrl = user.imageUrl;
    
    // Update user for next time.
    appDelegate.user.firstName = firstNameField.text;
    appDelegate.user.lastName = lastNameField.text;
    appDelegate.user.imageUrl = imageUrl;
    
    [appDelegate showWithStatus:@"Updating Profile" withDetailedStatus:@""];
    [userService personalizeUser:user.userId WithFirstName:firstNameField.text withLastName:lastNameField.text withImage: imageUrl];
}
-(void) personalizeUserDidComplete {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showSuccessWithStatus:@"Profile Updated" withDetailedStatus:@""];
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow:self];
}
-(void) personalizeUserDidFail:(NSString*) response {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Failed!" withDetailedStatus:@"Check data connection"];
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow:self];
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
    [controller setChooseMemberImageDelegate: self];
    UINavigationController *naviBar=[[UINavigationController alloc]initWithRootViewController:controller];
    [controller setTitle: @"Select Picture"];
    
    [self presentModalViewController:naviBar animated:YES];
    [naviBar release];
    [controller release];
}
-(void)chooseMemberImageDidComplete: (NSString*) imageUrl 
{
    [userImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrl]]] forState:UIControlStateNormal];
    
    user.imageUrl = imageUrl;
    [self dismissModalViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [textField resignFirstResponder];
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self pressedSaveContinue:self];
    }
    return NO; // We do not want UITextField to insert line-breaks.
    
}


@end
