//
//  ForgotPassword.m
//  PdThx
//
//  Created by Edward Mitchell on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@implementation ForgotPasswordViewController
@synthesize txtEmailAddress;
@synthesize btnSubmitForgotPassword;


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
    
    
}

- (void)viewDidUnload
{
    [self setTxtEmailAddress:nil];
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
        [self submitForgotPasswordClicked:self];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)submitForgotPasswordClicked:(id)sender
{
    int retVal = [self isValidFormattedPayPoint];
    [txtEmailAddress resignFirstResponder];
    if(retVal == 0)
    {
        [txtEmailAddress resignFirstResponder];
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
        // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
        // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
        // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
        [appDelegate showAlertWithResult:false withTitle:@"Invalid E-Mail Format" withSubtitle:@"" withDetailText:@"Please Enter an E-mail Address" withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Not shown" withRightButtonTitleColor:[UIColor clearColor]  withTextFieldPlaceholderText: @"" withDelegate:self];
    }
    else if(retVal != 2)
    {
        [txtEmailAddress resignFirstResponder];
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
        // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
        // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
        // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
        [appDelegate showAlertWithResult:false withTitle:@"Invalid E-Mail Format" withSubtitle:@"" withDetailText:@"E-Mail Incorrect Format" withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Not shown" withRightButtonTitleColor:[UIColor clearColor]  withTextFieldPlaceholderText: @"" withDelegate:self];
    }
    else
    {
        
        userService = [[UserService alloc] init];
        [userService setForgotPasswordCompleteDelegate:self];
        [txtEmailAddress resignFirstResponder];
        
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Sending email.." withDetailedStatus:@""];
        [userService forgotPasswordFor: txtEmailAddress.text];
    }
}
-(void)didSelectButtonWithIndex:(int)index
{
    if ( index == 0 ) {
        // Dismiss, error Email invalid
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
    } else {
        // Successful error Email
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        
        // TODO: There needs to be a protocol here to load the image as being on top.
    }
}

-(void) forgotPasswordDidComplete
{
    txtEmailAddress.text = @"";
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    [appDelegate showSimpleAlertView:YES withTitle:@"Email sent!" withSubtitle:@"Email successfully sent" withDetailedText:@"Check your email for a link to our website, and fill in the information to reset your password!" withButtonText:@"OK" withDelegate:self];
}

-(void) forgotPasswordDidFail:(NSString *)message
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:message];
}

- (void)dealloc {
    [btnSubmitForgotPassword release];
    [txtEmailAddress release];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}
-(int)isValidFormattedPayPoint {
    // Do handling for entry of text field where entry does not match
    // any contacts in the user's contact list.
    
    // The only cases we need to handle are: Phone Number and Email
    NSString * numOnly = [[txtEmailAddress.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSRange numOnly2 = [[[txtEmailAddress.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-() "]] componentsJoinedByString:@""] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]  options:NSCaseInsensitiveSearch];
    if([txtEmailAddress.text length] < 1)
        return 0;
    if ( [txtEmailAddress.text isEqualToString:numOnly] || numOnly2.location == NSNotFound ) {
        // Is only Numbers, I think?
        if ( [numOnly characterAtIndex:0] == '1' || [numOnly characterAtIndex:0] == '0' )
            numOnly = [numOnly substringFromIndex:1]; // Do not include country codes
        if ( [numOnly length] == 10 )
            return 1;
    } else {
        if ( [txtEmailAddress.text rangeOfString:@"@"].location != NSNotFound && [txtEmailAddress.text rangeOfString:@"."].location != NSNotFound ){
            // Contains both @ and a period. Now check if there's atleast:
            // [SOMETHING] before the @
            // [SOMETHING] after the @ before the .
            // [SOMETHING?] after the .
            if ( [txtEmailAddress.text rangeOfString:@"@"].location != 0 
                && [txtEmailAddress.text rangeOfString:@"."].location != ([txtEmailAddress.text rangeOfString:@"@"].location + 1) && [txtEmailAddress.text length] != [txtEmailAddress.text rangeOfString:@"."].location+1 )
                return 2;
        }
    }
    
    return 0;
}


@end
