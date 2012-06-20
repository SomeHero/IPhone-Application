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
    [securityPinModal release];
    [confirmSecurityPinModal release];
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
			//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MyApp" message:@"Unknown Error"
            // delegate:self cancelButtonTitle:@”OK” otherButtonTitles: nil];
			//[alert show];
			//[alert release];
			break;
		case MessageComposeResultSent:
            NSLog(@"Complete");
            
            SetupACHAccountController* setupACHAccountController = [[SetupACHAccountController alloc] initWithNibName:@"SetupACHAccountController" bundle:nil];
            
            [setupACHAccountController setAchSetupCompleteDelegate:self];
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
    
    ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user= [user copy];
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
    
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
        [self showAlertView:@"Invalid Email Address!" withMessage: @"You entered an invalid email address.  Please try again."];
        
        isValid = NO;
    }
    if(isValid && ![self isValidPassword:password])
    {
        [self showAlertView:@"Invalid Password!" withMessage:@"You entered an invalid password.  Please try again."];
        
        isValid = NO;
    }
    if(isValid && ![self doesPasswordMatch:password passwordToMatch:confirmPassword])
    {
        [self showAlertView:@"Passwords Don't Match!" withMessage:@"The passwords you entered don't match.  Please try again."];
        
        isValid = NO;
    }
    
    if(isValid) {
        [spinner startAnimating];
        
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
    [self createAccount];    
}

-(void) securityPinComplete:(SetupSecurityPin*) modalPanel 
               selectedCode:(NSString*) code {
    
    if([code length] < 4) {
        [self showAlertView:@"Invalid Pin" withMessage:@"Select atleast 4 dots when setting up a pin"];
    } else {
        [modalPanel hide];
        
        securityPin = [[NSString alloc] initWithString: code];
        
        modalPanel.lblTitle.text = @"Confirm Your Pin";
        modalPanel.lblHeading.text = @"Great, now let's confirm your pin, by connecting the same dots in the same pattern";
        
        [modalPanel setNeedsDisplay];
        
        [self showConfirmSecurityPin];
    }
    
    
}
-(void) confirmSecurityPinComplete:(ConfirmSecurityPinDialog*) modalPanel 
                      selectedCode:(NSString*) code {
    
    if([code length] < 4) {
        [self showAlertView:@"Invalid Pin" withMessage:@"Your pin is atleast 4 dots"];
    }
    else if(![code isEqualToString:securityPin])
        [self showAlertView: @"Pin Mismatch" withMessage:@"The pins don't match. Try again"];
    else {
        [modalPanel hide];
        [modalPanel removeFromSuperview];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // I do this because I'm in landscape mode
        [self.view addSubview:spinner]; // spinner is not visible until started
        
        [spinner startAnimating];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSLog(@"Prefs currenty stores: %@" , [prefs stringForKey:@"deviceToken"]);
        
        [registerUserService registerUser:userName withPassword:password withMobileNumber:@"" withSecurityPin:securityPin withDeviceId:[prefs stringForKey:@"deviceToken"]];
    }
    
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
    
    [userService setUserInformationCompleteDelegate: self];
    [userService getUserInformation: userId];
}
-(void)userRegistrationDidFail:(NSString*) response
{
    [spinner stopAnimating];
    
    [self showAlertView: @"User Registration Failed" withMessage: response];
}
/*          FACEBOOK ACCOUNT SIGN IN HANDLING     */
-(void)fbSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserId:(NSString*) userId withPaymentAccountId:(NSString*) paymentAccountId withMobileNumber: (NSString*) mobileNumber isNewUser:(BOOL)isNewUser
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setValue:userId forKey:@"userId"];
    
    [prefs synchronize];
    
    [userService setUserInformationCompleteDelegate: self];
    [userService getUserInformation: userId];
    
    
}

-(void)fbSignInDidFail:(NSString *) reason {
    [self showAlertView:@"Facebook Sign In Failed" withMessage:[NSString stringWithFormat:@"%@. Check your username, password, and data connection.",reason]];
}
-(void) showConfirmSecurityPin {
    confirmSecurityPinModal = [[ConfirmSecurityPinDialog alloc] initWithFrame:self.view.bounds];
    
    confirmSecurityPinModal.tag = 1;
    confirmSecurityPinModal.delegate = self;
    
    ///////////////////////////////////
    // Add the panel to our view
    [self.view addSubview:confirmSecurityPinModal];
    
    ///////////////////////////////////
    // Show the panel from the center of the button that was pressed
    [confirmSecurityPinModal show];
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
