//
//  SignInViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.

#import "SignInViewController.h"
#import "CreateAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SignInUserService.h"
#import "SetupACHAccountController.h"
#import "SignInWithFBService.h"
#import "Environment.h"
#import "PdThxAppDelegate.h"
#import "Facebook.h"
#import "HomeViewController.h"
#import "SVProgressHUD.h"


#define KEYBOARD_ANIMATION_DURATION 0.3
#define MINIMUM_SCROLL_FRACTION 0.2
#define MAXIMUM_SCROLL_FRACTION 0.8
#define KEYBOARD_HEIGHT 162

@interface SignInViewController ()

- (void)signInUser;

@end

@implementation SignInViewController

@synthesize txtEmailAddress, txtPassword, animatedDistance;
@synthesize signInCompleteDelegate; // setupACHAccountController
@synthesize viewPanel, fBook, service, bankAlert; // achSetupCompleteDelegate

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setTitle:@"Sign In"];
}

- (void)dealloc
{
    [txtEmailAddress release];
    [txtPassword release];
    [signInUserService release];
    [fBook release];
    [signInCompleteDelegate release];
    [signInUserService release];
    [SignInWithFBService release];
    [faceBookSignInHelper release];
    
    [loginFBButton release];
    [loginFBButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    faceBookSignInHelper = [[FacebookSignIn alloc] init];
    signInUserService = [[SignInUserService alloc] init];
    [signInUserService setUserSignInCompleteDelegate:self];
    service = [[SignInWithFBService alloc] init];
    service.fbSignInCompleteDelegate = self;
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    
    fBook = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fBook;
}

-(void)viewDidAppear:(BOOL)animated 
{
    [self setTitle:@"Sign In"];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidUnload
{
    [loginFBButton release];
    loginFBButton = nil;
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
        
        [self signInUser];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)signInUser {
    NSString* username = [NSString stringWithString:@""];
    NSString* password = [NSString stringWithString: @""];
    
    if([txtEmailAddress.text length] > 0)
        username = txtEmailAddress.text;
    
    if([txtPassword.text length] > 0)
        password = txtPassword.text;
    
    BOOL isValid = YES;
    
    if(isValid && ![self isValidUserName:username])
    {
        [self showAlertView:@"Invalid UserName!" withMessage: @"You did not enter a user name.  Please try again."];
        
        isValid = NO;
    }
    if(isValid && ![self isValidPassword:password])
    {
        [self showAlertView:@"Invalid Password!" withMessage:@"You did not enter a password.  Please try again."];
        
        isValid = NO;
    }
    
    if(isValid) {
        //[SVProgressHUD showWithStatus:@"Logging in..."];
        [signInUserService validateUser:username withPassword:password];
    }
}


/*          FACEBOOK ACCOUNT SIGN IN HANDLING     */
-(void)fbSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserId:(NSString*) userId withPaymentAccountId:(NSString*) paymentAccountId withMobileNumber: (NSString*) mobileNumber isNewUser:(BOOL)isNewUser {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setValue:userId forKey:@"userId"];
    [prefs setBool:isNewUser forKey:@"isNewUser"];
    
    [prefs synchronize];
    
    UserService* userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
    
    [userService getUserInformation: userId];
    
    
}

-(void)fbSignInDidFail:(NSString *) reason {
    [self showAlertView:@"Facebook Sign In Failed" withMessage:[NSString stringWithFormat:@"%@. Check your username, password, and data connection.",reason]];
}


/*          NORMAL ACCOUNT SIGN IN HANDLING     */
-(void)userSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserId: (NSString*) userId withPaymentAccountId:(NSString*) paymentAccountId withMobileNumber: (NSString*) mobileNumber
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setValue:userId forKey:@"userId"];
    
    [prefs synchronize];
    
    
    txtPassword.text = @"";
    txtEmailAddress.text = @"";
    
    UserService* userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
    
    
    //[SVProgressHUD showWithStatus:@"Getting user information..."];
    [userService getUserInformation: userId];
}

-(void)userSignInDidFail:(NSString *) reason {
    [self showAlertView:@"User Validation Failed!" withMessage: reason];
}


-(void)userInformationDidComplete:(User*) user {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* paymentAccountAccount = [prefs valueForKey:@"paymentAccountId"];
    bool setupSecurityPin = [prefs boolForKey:@"setupSecurityPin"];
    
    if(paymentAccountAccount != (id)[NSNull null] && [paymentAccountAccount length] > 0)
        user.hasACHAccount = true;
    user.hasSecurityPin = setupSecurityPin;
    
    //[SVProgressHUD showSuccessWithStatus:@"Yay?"];
    
    ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user= [user copy];
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
    return;
}
-(void)userInformationDidFail:(NSString*) message {
    [self showAlertView: @"Error Sending Money" withMessage: message];
}

-(void)achAccountSetupDidComplete
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [signInCompleteDelegate signInDidComplete];
}

-(void)achAccountSetupDidSkip
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [signInCompleteDelegate signInDidComplete];
}


-(IBAction) btnSignInClicked:(id) sender {
    [self signInUser];
}
/*
 -(IBAction) btnCreateAnAccountClicked:(id) sender {
 CreateAccountViewController *createAccountViewController = [[[CreateAccountViewController alloc] initWithNibName:@"CreateAccountViewController" bundle: nil] autorelease];
 
 [createAccountViewController setAchSetupCompleteDelegate: self];
 [self.navigationController pushViewController:createAccountViewController animated:YES];
 }
 */

-(IBAction) bgTouched:(id) sender {
    [txtEmailAddress resignFirstResponder];
    [txtPassword resignFirstResponder];
}

-(BOOL)isValidUserName:(NSString *) userNameToTest {
    if([userNameToTest length] == 0)
        return false;
    
    return true;
}

-(BOOL)isValidPassword:(NSString *) passwordToTest {
    if([passwordToTest length] == 0)
        return false;
    
    return true;
}

- (IBAction)signInWithFacebookClicked:(id)sender {
    if ( ![fBook isSessionValid] )
        [faceBookSignInHelper signInWithFacebook:self];
}

-(void) request:(FBRequest *)request didLoad:(id)result
{
    [service validateUser:result];
}

-(void) request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog ( @"Error occurred -> %@" , [error description] );
}

/*
 -(void)achSetupDidComplete {
 [self.navigationController dismissModalViewControllerAnimated:YES];
 
 [achSetupCompleteDelegate achSetupDidComplete];
 }
 */


@end
