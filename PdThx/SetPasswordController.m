//
//  SetPasswordController.m
//  PdThx
//
//  Created by James Rhodes on 1/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SetPasswordController.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "PdThxAppDelegate.h"

@implementation SetPasswordController
@synthesize txtUserName, txtPassword, txtConfirmPassword, scrollView, button;

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
    
    
    if (!CGRectContainsPoint(aRect, CGPointMake(currTextField.frame.origin.x, currTextField.frame.origin.y + currTextField.frame.size.height))) {
        CGPoint scrollPoint = CGPointMake(0.0, (currTextField.frame.origin.y+ currTextField.frame.size.height)-aRect.size.height);
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
    
    [self registerForKeyboardNotifications];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* mobileNumber = [prefs stringForKey:@"mobileNumber"];
    
    txtUserName.text = mobileNumber;
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
-(IBAction) bgTouched:(id) sender
{
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
}
-(IBAction) btnContinueClicked:(id) sender
{
    
    NSLog(@"Setting Password");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* userId = [prefs stringForKey:@"userId"];
    NSString* mobileNumber = [prefs stringForKey:@"mobileNumber"];
    
    NSString* password = txtPassword.text;

    [self setupPassword:password withUserName:mobileNumber forUser:userId]; 
}
-(void) setupPassword:(NSString*) password withUserName:(NSString *) userName forUser: (NSString *) userId {
    
    NSString *rootUrl = [NSString stringWithString: @"pdthx.me"];
    NSString *apiKey = [NSString stringWithString: @"bda11d91-7ade-4da1-855d-24adfe39d174"];
    
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"http://%@/Services/UserService/SetupPassword?apiKey=%@", rootUrl, apiKey]] autorelease];  
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userId, @"userId",
                                 deviceId, @"deviceId",
                                 userName, @"userName",
                                 password, @"password",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(setupPasswordComplete:)];
    [request setDidFailSelector:@selector(setupPasswordFailed:)];
    
    [request startAsynchronous]; 
}
-(void) setupPasswordComplete:(ASIHTTPRequest *)request
{
    NSString *theJSON = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    bool success = [[jsonDictionary objectForKey:@"success"] boolValue];
    NSString *message = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"message"]];
    
    if(success) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setBool:YES forKey:@"setupPassword"];
        [prefs synchronize];
        
        PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate switchToConfirmation];
        
    }
}
-(void) setupPasswordFailed:(ASIHTTPRequest *)request
{
    // statsCommuniqueDoneProblem ... !
    NSLog(@"Setup Password Failed");
}
- (void) showAlertView:(NSString *)title withMessage: (NSString *) message  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
                                                        message: message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
}
@end
