//
//  ChangePasswordViewController.m
//  PdThx
//
//  Created by Edward Mitchell on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChangePasswordViewController.h"

@implementation ChangePasswordViewController
@synthesize txtOldPassword, txtNewPassword, txtConfirmPassword;

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
    [txtOldPassword release];
    txtOldPassword = nil;
    [self setTxtNewPassword:nil];
    [txtConfirmPassword release];
    txtConfirmPassword = nil;
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
        [self changePasswordButtonClicked:self];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)changePasswordButtonClicked:(id)sender {
    if ([txtNewPassword.text isEqualToString:txtConfirmPassword.text]) {
        userService = [[UserService alloc] init];
        [userService setChangePasswordCompleteDelegate:self];
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        NSString* userId = [prefs stringForKey:@"userId"];
        [userService changePasswordFor:userId WithOld:txtOldPassword.text AndNew:txtNewPassword.text];
    }
    else 
    {
        [self showAlertView:@"Unable to change password" withMessage:@"New password and confirm password fields do not match."];
    }
}

- (void)dealloc {
    [txtOldPassword release];
    [txtNewPassword release];
    [txtConfirmPassword release];
    [super dealloc];
}

-(void) changePasswordSuccess
{
    txtOldPassword.text = @"";
    txtNewPassword.text = @"";
    txtConfirmPassword.text = @"";
    NSLog(@"Password successfully changed!!");
}
-(void) changePasswordDidFail:(NSString*) response
{
    NSLog(@"%@", response);
}
@end
