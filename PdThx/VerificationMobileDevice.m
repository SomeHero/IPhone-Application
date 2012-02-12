//
//  VerificationMobileDevice.m
//  PdThx
//
//  Created by James Rhodes on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "VerificationMobileDevice.h"
#import "ACHAccountSetup.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "CreateSecurityCode.h"

@implementation VerificationMobileDevice
@synthesize scrollView, txtVerificationCode1, txtVerificationCode2, recipientMobileNumber, amount, comment;

//--size of application screen---
CGRect applicationFrame;

//--original size of ScrollView---
CGSize scrollViewOriginalSize;

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, currTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (currTextField.frame.origin.y + currTextField.frame.size.height) - aRect.size.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currTextField = nil;
}
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
    [scrollView release];
    [txtVerificationCode1 release];
    [txtVerificationCode2 release];
    [recipientMobileNumber release];
    [amount release];
    [comment release];
    
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
    
    [self registerForKeyboardNotifications];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction) btnContinueClicked:(id) sender{
    NSLog(@"Verfying Mobile Device");
    
    CreateSecurityCode* viewController = [[CreateSecurityCode alloc] initWithNibName:@"CreateSecurityCode" bundle:nil];
    viewController.title = @"Select Your Pin";
    
    [self.navigationController pushViewController:viewController animated:YES];
   
}

-(void) requestFinished: (ASIHTTPRequest *) request {
    
    NSString *theJSON = [request responseString];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    bool success = [[jsonDictionary objectForKey:@"success"] boolValue];
    NSString *message = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"message"]];
    
    if(success)
    {
    
        CreateSecurityCode* viewController = [[CreateSecurityCode alloc] initWithNibName:@"CreateSecurityCode" bundle:nil];
        viewController.title = @"Select Your Pin";
    
        [self.navigationController pushViewController:viewController animated:YES];
    
        NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    
        [allControllers removeObjectAtIndex:[allControllers count] - 2];
        [self.navigationController setViewControllers:allControllers animated:NO];
        [allControllers retain];
    
    
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure!"
                                                      message: [NSString stringWithFormat: @"Unable to validate the User Name and Password.  Try again."]
                                                   delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
        [alertView show]; 
        [alertView release];
    }
    
    [message release];
}
-(IBAction) btnReSendCodesClicked:(id) sender {
    
}
-(IBAction) bgTouched:(id) sender {
    [txtVerificationCode1 resignFirstResponder];
    [txtVerificationCode2 resignFirstResponder];
}

@end
