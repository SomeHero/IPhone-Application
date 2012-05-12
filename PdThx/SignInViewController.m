//
//  SignInViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SignInViewController.h"
#import "CreateAccountViewController.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "Environment.h"
#import <QuartzCore/QuartzCore.h>


@interface SignInViewController ()
- (void)signInUser;

@end

@implementation SignInViewController

@synthesize txtEmailAddress, txtPassword;
@synthesize signInCompleteDelegate, achSetupCompleteDelegate;
@synthesize viewPanel;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    //[signInCompleteDelegate release];
    //[achSetupCompleteDelegate release];

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
    [self setTitle:@"Sign In"];
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [self setTitle:@"Sign In"];
    [self.navigationItem setHidesBackButton:YES];    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userId"];
    
    if([userId length] > 0)
    {
        UINavigationController* navController = self.navigationController;
        [self removeCurrentViewFromNavigation:navController];
    }
    
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
    NSString* username = [NSString stringWithString: @""];
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
        [self signInUser:username withPassword:password];
    }
}

-(IBAction) btnSignInClicked:(id) sender {
    [self signInUser];

}
-(IBAction) btnCreateAnAccountClicked:(id) sender {
    CreateAccountViewController *createAccountViewController = [[[CreateAccountViewController alloc] initWithNibName:@"CreateAccountViewController" bundle: nil] autorelease];
    
    [createAccountViewController setAchSetupCompleteDelegate: self];
    [self.navigationController pushViewController:createAccountViewController animated:YES];
    
}
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
-(void) signInUser:(NSString*) myUserName withPassword:(NSString *) myPassword {
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = myEnvironment.pdthxWebServicesBaseUrl;
    NSString *apiKey = myEnvironment.pdthxAPIKey;
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Services/UserService/SignIn?apiKey=%@", rootUrl, apiKey]] autorelease];  
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              myUserName, @"userName",
                              myPassword, @"password",
                              nil];
    
    NSString *newJSON = [userData JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(signInUserComplete:)];
    [request setDidFailSelector:@selector(signInUserFailed:)];
    
    [request startAsynchronous]; 
}
-(void) signInUserComplete:(ASIHTTPRequest *)request
{
    NSString *theJSON = [request responseString];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    BOOL isValid = [[jsonDictionary objectForKey:@"isValid"] boolValue];
    NSString* userId = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"userId"]];
    NSString* mobileNumber = [[NSString alloc] initWithString:[jsonDictionary objectForKey: @"mobileNumber"]];
    NSString* paymentAccountId = [[NSString alloc] initWithString:[jsonDictionary objectForKey: @"paymentAccountId"]];
    
    if(isValid)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject: userId forKey:@"userId"];
        [prefs setObject: mobileNumber forKey:@"mobileNumber"];
        [prefs setObject: paymentAccountId forKey:@"paymentAccountId"];
        [prefs setBool:TRUE forKey:@"setupPassword"];
        [prefs setBool:TRUE forKey:@"setupSecurityPin"];
        
        [prefs synchronize];

        [signInCompleteDelegate signInDidComplete];
        
    }
    else {
        [self showAlertView:@"Failed to sign in" withMessage: @"Unable to valide user name and password.  Try again."];          
    }
    
    [userId release];
    [mobileNumber release];
    [paymentAccountId release];
}
-(void) signInUserFailed:(ASIHTTPRequest *)request
{
    // statsCommuniqueDoneProblem ... !
    NSLog(@"Setup Password Failed");
}
-(void)achSetupDidComplete {
    [achSetupCompleteDelegate achSetupDidComplete];
}

@end
