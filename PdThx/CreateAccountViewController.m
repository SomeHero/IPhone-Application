//
//  CreateAccountViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateAccountViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kScreenWidth  320
#define kScreenHeight  400

@interface CreateAccountViewController ()
- (void)createAccount;

@end

@implementation CreateAccountViewController

@synthesize txtEmailAddress, txtMobileNumber, txtPassword, txtConfirmPassword;
@synthesize btnCreateAccount, viewPanel;
@synthesize achSetupCompleteDelegate;


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
    [txtMobileNumber release];
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
    [mobileNumber release];
    [userName release];
    //[achSetupCompleteDelegate release];
    [requestObj release];
    [registerUserService release]; 
    
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
    
    registerUserService = [[RegisterUserService alloc] init];
    [registerUserService setUserRegistrationCompleteDelegate: self];
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

    if([txtMobileNumber.text length] > 0)
        mobileNumber = [NSString stringWithString: txtMobileNumber.text];

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
    if(isValid && ![self isValidMobileNumber:mobileNumber])
    {
        [self showAlertView:@"Invalid Mobile Number!" withMessage:@"You entered an invalid mobile number.  Please try again."];

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
        securityPinModal = [[SetupSecurityPin alloc] initWithFrame:self.view.bounds];

        securityPinModal.tag = 0;
        securityPinModal.delegate = self;

        ///////////////////////////////////
        // Add the panel to our view
        [self.view addSubview:securityPinModal];

        ///////////////////////////////////
        // Show the panel from the center of the button that was pressed
        [securityPinModal show];
    }
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
        
        [registerUserService registerUser:userName withPassword:password withMobileNumber:mobileNumber withSecurityPin:securityPin withDeviceId:[prefs stringForKey:@"deviceToken"]];
    }
    
}
-(void)userRegistrationDidComplete:(NSString*) userId withSenderUri:(NSString*) senderUri 
{
    [spinner stopAnimating];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:userId forKey:@"userId"];
    [prefs setObject:senderUri forKey: @"mobileNumber"];
    [prefs synchronize];
    
    SetupACHAccountController *setupACHAccountController = [[SetupACHAccountController alloc] initWithNibName:@"SetupACHAccountController" bundle: nil];
    
    [setupACHAccountController setAchSetupCompleteDelegate:self];
    [self.navigationController pushViewController:setupACHAccountController animated:true];
    
    [setupACHAccountController release];
}
-(void)userRegistrationDidFail:(NSString*) response
{
    [spinner stopAnimating];
    
    [self showAlertView: @"User Registration Failed" withMessage: response];
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
    [txtMobileNumber resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
}
-(BOOL)isValidEmailAddress:(NSString *) emailAddressToTest {
    if([emailAddressToTest length] == 0)
        return false;
    
    return true;
}
-(BOOL)isValidMobileNumber:(NSString *) mobileNumberToTest {
    if([mobileNumberToTest length]  == 0)
        return false;
    
    if(isnumber([mobileNumberToTest characterAtIndex:0])) {
        NSCharacterSet *numSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-"];
        
        @try {
            if(([[mobileNumberToTest stringByTrimmingCharactersInSet:numSet] isEqualToString:@""]) && ([[mobileNumberToTest stringByReplacingOccurrencesOfString:@"-" withString:@""] length] == 10))
                return true;
            else
                return false;
        }
        @catch (NSException *exception) {
            return false;
        }   
    }
    
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
