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
    // Do any additional setup after loading the view from its nib.
    

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



- (IBAction)submitForgotPasswordClicked:(id)sender {
    userService = [[UserService alloc] init];
    [userService setForgotPasswordCompleteDelegate:self];
    [txtEmailAddress resignFirstResponder];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Sending email.." withDetailedStatus:@""];
    [userService forgotPasswordFor: txtEmailAddress.text];
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

-(void) didSelectButtonWithIndex:(int)index
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissAlertView];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [btnSubmitForgotPassword release];
    [txtEmailAddress release];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}


@end
