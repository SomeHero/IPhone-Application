//
//  SignInViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.

#import "WelcomeScreenViewController.h"
#import "CreateAccountViewController.h"
#import "AboutPageViewController.h"
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


#define KEYBOARD_ANIMATION_DURATION 0.3
#define MINIMUM_SCROLL_FRACTION 0.2
#define MAXIMUM_SCROLL_FRACTION 0.8
#define KEYBOARD_HEIGHT 162

@interface SignInViewController ()

- (void)signInUser;

@end

@implementation SignInViewController

@synthesize txtEmailAddress, txtPassword, animatedDistance;
@synthesize viewPanel, fBook, service, bankAlert;
@synthesize numFailedFB;

@synthesize tabBar;

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
    [signInUserService release];
    [SignInWithFBService release];
    [faceBookSignInHelper release];
    
    [loginFBButton release];
    [loginFBButton release];
    [forgotPassword release];
    
    
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
    
    tabBar = [[SignedOutTabBarManager alloc]initWithViewController:self topView:self.view delegate:self selectedIndex:1];
    
    faceBookSignInHelper = [[FacebookSignIn alloc] init];
    signInUserService = [[SignInUserService alloc] init];
    [signInUserService setUserSignInCompleteDelegate:self];
    service = [[SignInWithFBService alloc] init];
    service.fbSignInCompleteDelegate = self;
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"SignInViewController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    PdThxAppDelegate * appDelegate = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]);
    fBook = appDelegate.fBook;
    
    numFailedFB = 0;
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
    [forgotPassword release];
    forgotPassword = nil;
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
        // [self showAlertView:@"Invalid UserName!" withMessage: @"You did not enter a user name.  Please try again."];
        
        isValid = NO;
    }
    if(isValid && ![self isValidPassword:password])
    {
        // [self showAlertView:@"Invalid Password!" withMessage:@"You did not enter a password.  Please try again."];
        
        isValid = NO;
    }
    
    if(isValid) {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Signing in" withDetailedStatus:@"Accessing account"];
        [signInUserService validateUser:username withPassword:password];
    } else {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid username/password"];
    }
}

-(void)fbSignInCancelled
{
    numFailedFB++;
    if (numFailedFB == 3) {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Facebook Error" withDetailedStatus:@"Check Connection"];
        numFailedFB = 0;
    } else {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Cancelled" withDetailedStatus:@"Facebook Sign In Cancelled"];
    }
}

/*          FACEBOOK ACCOUNT SIGN IN HANDLING     */
-(void)fbSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserId:(NSString*) userId withPaymentAccountId:(NSString*) paymentAccountId withMobileNumber: (NSString*) mobileNumber isNewUser:(BOOL)isNewUser {
    [self.navigationController dismissModalViewControllerAnimated:NO];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setValue:userId forKey:@"userId"];
    [prefs setBool:isNewUser forKey:@"isNewUser"];
    
    [prefs synchronize];
    
    UserService* userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
    
    
    [userService getUserInformation: userId];
}

-(void)fbSignInDidFail:(NSString *) reason {
    
    [self.navigationController dismissModalViewControllerAnimated:NO];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Error!" withDetailedStatus:@"Facebook Login Failed"];
    
}


/*          NORMAL ACCOUNT SIGN IN HANDLING     */
-(void)userSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserId: (NSString*) userId withPaymentAccountId:(NSString*) paymentAccountId withMobileNumber: (NSString*) mobileNumber
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    [facebookOverlay setHidden:YES];
    
    [prefs setValue:userId forKey:@"userId"];
    [prefs setBool:false forKey:@"isNewUser"];

    [prefs synchronize];
    
    
    txtPassword.text = @"";
    txtEmailAddress.text = @"";
    
    UserService* userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
    
    
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Signing in" withDetailedStatus:@"Getting your profile"];
    
    [userService getUserInformation: userId];
}

-(void)userSignInDidFail:(NSString *) reason {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid user/pass"];
    //[self showAlertView:@"User Validation Failed!" withMessage: reason];
}


-(void)userInformationDidComplete:(User*) user {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* paymentAccountAccount = [prefs valueForKey:@"paymentAccountId"];
    bool setupSecurityPin = [prefs boolForKey:@"setupSecurityPin"];
    
    if(paymentAccountAccount != (id)[NSNull null] && [paymentAccountAccount length] > 0)
        user.hasACHAccount = true;
    user.hasSecurityPin = setupSecurityPin;
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showSuccessWithStatus:@"Complete!" withDetailedStatus:@""];
    
    ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user= [user copy];
    
    if(user.isLockedOut)
    {
        SecurityQuestionChallengeViewController* controller = [[SecurityQuestionChallengeViewController alloc] init];
        [controller setNavigationTitle: @"Security Question"];
        [controller setHeaderText: [NSString stringWithFormat:@"To continue, provide the answer to the security question you setup when you created your account."]]; 
        controller.currUser = [user copy];
        [controller setSecurityQuestionChallengeDelegate: self];
        
        [self presentModalViewController:controller animated:YES];
        
        [controller release];
    } else {
        [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) switchToMainAreaTabbedView];
    }
    
    return;
}
-(void)userInformationDidFail:(NSString*) message {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Error loading user"];
    //[self showAlertView: @"Error Sending Money" withMessage: message];
}


-(IBAction) btnSignInClicked:(id) sender {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Signing in" withDetailedStatus:@"Checking password"];
	
    [self signInUser];
}

- (IBAction)forgotPasswordClicked:(id)sender {
    ForgotPasswordViewController* controller = [[ForgotPasswordViewController alloc] init];
    [controller setTitle:@"Forgot Password"];
    [controller setHeaderText:@"To change your password, you must input your security question answer and then put in a new password"];
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    
    [self.navigationController presentModalViewController:navBar animated:YES];
    
    [navBar release];
    [controller release];
}

/*
 -(IBAction) btnCreateAnAccountClicked:(id) sender {
 CreateAccountViewController *createAccountViewController = [[[CreateAccountViewController alloc] initWithNibName:@"CreateAccountViewController" bundle: nil] autorelease];
 
 [createAccountViewController setAchSetupCompleteDelegate: self];
 [self.navigationController pushViewController:createAccountViewController animated:YES];
 }
 */

-(IBAction) bgTouched:(id) sender 
{
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
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showWithStatus:@"Please wait..." withDetailedStatus:@"Connecting with Facebook"];
    
    if ( ![fBook isSessionValid] ){
        NSLog(@"Facebook Session is NOT Valid, Signing in...");
        [faceBookSignInHelper setCancelledDelegate:self];
        [faceBookSignInHelper signInWithFacebook:self];
    } else {
        NSLog(@"Facebook Session is Valid, Getting info...");
        [fBook requestWithGraphPath:@"me" andDelegate:self];
        [fBook requestWithGraphPath:@"me/friends" andDelegate:appDelegate];
    }
}

-(void) request:(FBRequest *)request didLoad:(id)result
{
    NSLog(@"User info did load from Facebook, Logging in...");
    [service validateUser:result];
}

-(void) request:(FBRequest *)request didFailWithError:(NSError *)error
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog ( @"Error occurred2 -> %@" , [error description] );
    
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"FBAccessTokenKey"];
    [def removeObjectForKey:@"FBExpirationDateKey"];
    [def synchronize];
    
    if ( ![fBook isSessionValid] ){
        NSLog(@"Facebook Session is NOT Valid, Signing in...");
        [faceBookSignInHelper setCancelledDelegate:self];
        [faceBookSignInHelper signInWithFacebook:self];
    } else {
        NSLog(@"Facebook Session is Valid, Getting info...");
        [fBook requestWithGraphPath:@"me" andDelegate:self];
        [fBook requestWithGraphPath:@"me/friends" andDelegate:appDelegate];
    }
}

-(void)securityQuestionAnsweredCorrect {
    [self dismissModalViewControllerAnimated: YES];
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
}
-(void)securityQuestionAnsweredInCorrect:(NSString*)errorMessage {
        
}


- (void)tabBarClicked:(NSUInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        //This is the home tab already so don't do anything
        WelcomeScreenViewController *gvc = [[WelcomeScreenViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 2 )
    {
        
        //Switch to the groups tab
        CreateAccountViewController *gvc = [[CreateAccountViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigationcontroller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
        
    }
    if( buttonIndex == 3 )
    {
        //Switch to the groups tab
        AboutPageViewController *gvc = [[AboutPageViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigationcontroller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
}


@end
