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

#import "HomeViewController.h"
#import "HomeViewControllerV2.h"
#import "WelcomeScreenViewController.h"
#import "SignInViewController.h"
#import "AboutPageViewController.h"

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

@synthesize tabBar;


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
    [tabBar release];
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
    [fbSignInService release];
    
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

-(void)userInformationDidComplete:(User *)user
{    
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
    
    tabBar = [[SignedOutTabBarManager alloc]initWithViewController:self topView:self.view delegate:self selectedIndex:2];
    registerUserService = [[RegisterUserService alloc] init];
    [registerUserService setUserRegistrationCompleteDelegate: self];
    
    fbSignInService = [[SignInWithFBService alloc] init];
    fbSignInService.fbSignInCompleteDelegate = self;
    
    fbSignInHelper = [[FacebookSignIn alloc] init];
    [fbSignInHelper setReturnDelegate:self];
    
    userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
    
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Register"];
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:0.0]; // Old Width 1.0
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
    self.tabBar = nil;
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

- (void)createAccount
{
    NSString* confirmPassword = @"";
    
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
        [appDelegate showErrorWithStatus:@"Invalid Username" withDetailedStatus:@"Enter an email address"];
        
        isValid = NO;
    }
    if(isValid && ![self isValidPassword:password])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Invalid Password" withDetailedStatus:@"Passwords must contain: 6+ characters, at least 1 uppercase, an 1 number"];
        
        isValid = NO;
    }
    if(isValid && ![self doesPasswordMatch:password passwordToMatch:confirmPassword])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Invalid Password" withDetailedStatus:@"Your passwords don't match"];
        
        isValid = NO;
    }
    
    if(isValid)
    {
        [spinner startAnimating];
        
        
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Signing up" withDetailedStatus:@"Registering user"];
        
        [registerUserService registerUser:userName withPassword:password withMobileNumber:@"" withSecurityPin:@"" withDeviceId:@""];
    }
}
- (IBAction)signInWithFacebookClicked:(id)sender 
{
    
    [txtEmailAddress resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showWithStatus:@"Please wait..." withDetailedStatus:@"Connecting with Facebook"];
    
    [fbSignInHelper signInWithFacebook:self];
}


-(void)fbSignInCompleteWithMEResponse:(id)response
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    fbSignInService = [[SignInWithFBService alloc] init];
    [fbSignInService setFbSignInCompleteDelegate:self];
    [fbSignInService validateUser:response];
    
    FBRequest*friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if ( error )
        {
            NSLog(@"Facebook Friend Request Failed... %@",error.description);
        }
        else
        {
            [appDelegate facebookFriendsDidLoad:result];
        }
    }];
}


-(IBAction) btnCreateAccountClicked:(id) sender {
    
    
    [txtEmailAddress resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
    
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
-(void)userRegistrationDidFail:(NSString*) message withErrorCode:(int)errorCode
{
    [spinner stopAnimating];
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate handleError:message withErrorCode:errorCode withDefaultTitle: @"Unable to Create Account"];
    
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
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Please wait" withDetailedStatus:@"Getting user info"];
    [userService getUserInformation: userId];
}

-(void)fbSignInDidFail:(NSString *) message withErrorCode:(int)errorCode {
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate handleError:message withErrorCode:errorCode withDefaultTitle: @"Unable to Create Account"];
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
    if([passwordToTest length]  < 6)
        return false;
    
    if(![self validateOneUpperCaseLetter:passwordToTest])
        return false;
    
    if(![self validateOneInteger: passwordToTest])
        return false;
    
    return true;
}
-(BOOL) validateOneUpperCaseLetter:(NSString *)stringToTest {
    if ((stringToTest == nil) || ([stringToTest isEqualToString: @""])) {
        return NO;
    }
    
    NSRange upperCaseRange;
    NSCharacterSet *upperCaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    
    upperCaseRange = [stringToTest rangeOfCharacterFromSet: upperCaseSet];
    if (upperCaseRange.location == NSNotFound)
        return NO;

    return YES;
}
-(BOOL) validateOneInteger:(NSString *)stringToTest {
    if ((stringToTest == nil) || ([stringToTest isEqualToString: @""])) {
        return NO;
    }
    
    NSRange upperCaseRange;
    NSCharacterSet *upperCaseSet = [NSCharacterSet decimalDigitCharacterSet];
    
    upperCaseRange = [stringToTest rangeOfCharacterFromSet: upperCaseSet];
    if (upperCaseRange.location == NSNotFound)
        return NO;
    
    return YES;
}
-(BOOL)doesPasswordMatch:(NSString *) passwordToTest passwordToMatch: (NSString *) confirmPassword {
    if(![passwordToTest isEqualToString:confirmPassword])
        return false;
    
    return true;
}
-(void)achSetupDidComplete {
    [achSetupCompleteDelegate achSetupDidComplete];
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
    if( buttonIndex == 1 )
    {
        //Switch to the groups tab
        SignInViewController *gvc = [[SignInViewController alloc]init];
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
        /*
        //Switch to the groups tab
        CreateAccountViewController *gvc = [[CreateAccountViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigationcontroller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
        */
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
