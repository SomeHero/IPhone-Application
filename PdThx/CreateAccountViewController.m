//
//  CreateAccountViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SetupACHAccountController.h"
#import "AddACHAccountViewController.h"
#import "PdThxAppDelegate.h"

#define kScreenWidth  320
#define kScreenHeight  400

#define KEYBOARD_ANIMATION_DURATION 0.3
#define MINIMUM_SCROLL_FRACTION 0.0
#define MAXIMUM_SCROLL_FRACTION 0.8
#define KEYBOARD_HEIGHT 162

@interface CreateAccountViewController ()
- (void)createAccount;

@end

@implementation CreateAccountViewController

@synthesize txtEmailAddress,  txtPassword, txtConfirmPassword;
@synthesize btnCreateAccount, viewPanel;
@synthesize achSetupCompleteDelegate, animatedDistance;


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
    [txtEmailAddress release];
    [txtPassword release];
    [txtConfirmPassword release];
    [btnCreateAccount release];
    [viewPanel release];
    [spinner release];
    [securityPin release];
    
    [password release];
    [userName release];
    //[achSetupCompleteDelegate release];
    [requestObj release];
    [registerUserService release]; 
    [registrationKey release];
    [userService release];
    [service release];
    [faceBookSignInHelper release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(IBAction) sendInAppSMS:(id) sender
{
	MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
	if([MFMessageComposeViewController canSendText])
	{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        controller.     title = @"Verify Device";
		controller.body = [prefs stringForKey: @"userId"];
		controller.recipients = [NSArray arrayWithObjects:@"2892100266", nil];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			break;
		case MessageComposeResultSent:
            NSLog(@"Complete");
            
            AddACHAccountViewController* setupACHAccountController = [[AddACHAccountViewController alloc] init];
            
            [self.navigationController pushViewController:setupACHAccountController animated:true];
            
            [setupACHAccountController release];
            
			break;
            
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}
-(void)getUserInformation:(NSString*) userId
{
    [userService getUserInformation:userId];
}
-(void)userInformationDidComplete:(User*) user {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* paymentAccountAccount = [prefs valueForKey:@"paymentAccountId"];
    bool setupSecurityPin = [prefs boolForKey:@"setupSecurityPin"];
    
    if(paymentAccountAccount != (id)[NSNull null] && [paymentAccountAccount length] > 0)
        user.hasACHAccount = true;
    user.hasSecurityPin = setupSecurityPin;
    
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showSuccessWithStatus:@"Account Created" withDetailedStatus:@"Welcome to PaidThx"];
    
    ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user= [user copy];
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) switchToMainAreaTabbedView];
    
    return;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    faceBookSignInHelper = [[FacebookSignIn alloc] init];
    registerUserService = [[RegisterUserService alloc] init];
    [registerUserService setUserRegistrationCompleteDelegate: self];
    
    service = [[SignInWithFBService alloc] init];
    service.fbSignInCompleteDelegate = self;
    
    userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
    
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Register"];
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    

    
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"CreateAccountViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}
-(void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
        
        [self createAccount];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)createAccount {
    NSString* confirmPassword = [NSString stringWithString: @""];
    
    if([txtEmailAddress.text length] > 0)
        userName = [NSString stringWithString: txtEmailAddress.text];
    
    if([txtPassword.text length] > 0)
        password = [NSString stringWithString: txtPassword.text];
    
    if([txtConfirmPassword.text length] > 0)
        confirmPassword = [NSString stringWithString: txtConfirmPassword.text];
    
    BOOL isValid = YES;
    
    if(isValid && ![self isValidEmailAddress:userName])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Enter an email address"];
        
        isValid = NO;
    }
    if(isValid && ![self isValidPassword:password])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid password"];
        
        isValid = NO;
    }
    if(isValid && ![self doesPasswordMatch:password passwordToMatch:confirmPassword])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Password mismatch"];
        
        isValid = NO;
    }
    
    if(isValid) {
        [spinner startAnimating];
        
        
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Signing up" withDetailedStatus:@"Registering user"];
        
        [registerUserService registerUser:userName withPassword:password withMobileNumber:@"" withSecurityPin:@"" withDeviceId:@""];
        
        //securityPinModal = [[SetupSecurityPin alloc] initWithFrame:self.view.bounds];
        
        //securityPinModal.tag = 0;
        //securityPinModal.delegate = self;
        
        ///////////////////////////////////
        // Add the panel to our view
        //[self.view addSubview:securityPinModal];
        
        ///////////////////////////////////
        // Show the panel from the center of the button that was pressed
        //[securityPinModal show];
    }
}
- (IBAction)signInWithFacebookClicked:(id)sender 
{
    [faceBookSignInHelper signInWithFacebook: self];
}

-(void) request:(FBRequest *)request didLoad:(id)result
{
    [service validateUser:result];
}

-(void) request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog ( @"Error occurred -> %@" , [error description] );
}

-(IBAction) btnCreateAccountClicked:(id) sender {
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Signing up" withDetailedStatus:@"Checking connection"];
    
    [self createAccount];    
}
-(void)userRegistrationDidComplete:(NSString*) userId withSenderUri:(NSString*) senderUri 
{
    [spinner stopAnimating];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:userId forKey:@"userId"];
    [prefs setBool:YES forKey: @"isNewUser"];
    
    [prefs synchronize];

    txtEmailAddress.text = @"";
    txtPassword.text = @"";
    txtConfirmPassword.text = @"";
    
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Signing Up" withDetailedStatus:@"Loading profile"];
    
    [userService setUserInformationCompleteDelegate: self];
    [userService getUserInformation: userId];
}
-(void)userRegistrationDidFail:(NSString*) response
{
    [spinner stopAnimating];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Username in use"];
}
/*          FACEBOOK ACCOUNT SIGN IN HANDLING     */
-(void)fbSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserId:(NSString*) userId withPaymentAccountId:(NSString*) paymentAccountId withMobileNumber: (NSString*) mobileNumber isNewUser:(BOOL)isNewUser
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setValue:userId forKey:@"userId"];
    [prefs setBool:isNewUser forKey:@"isNewUser"];
    
    [prefs synchronize];
    
    userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
        
    [userService getUserInformation: userId];
}

-(void)fbSignInDidFail:(NSString *) reason {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Signup Failed!" withDetailedStatus:@"Check username/password"];
}
-(IBAction) bgTouched:(id) sender {
    [txtEmailAddress resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
}
-(BOOL)isValidEmailAddress:(NSString *) emailAddressToTest {
    if([emailAddressToTest length] == 0)
        return false;
    
    return true;
}
-(BOOL)isValidPassword:(NSString *) passwordToTest {
    if([passwordToTest length]  == 0)
        return false;
    
    return true;
}
-(BOOL)doesPasswordMatch:(NSString *) passwordToTest passwordToMatch: (NSString *) confirmPassword {
    if(![passwordToTest isEqualToString:confirmPassword])
        return false;
    
    return true;
}
-(void)achSetupDidComplete {
    [achSetupCompleteDelegate achSetupDidComplete];
}


@end
