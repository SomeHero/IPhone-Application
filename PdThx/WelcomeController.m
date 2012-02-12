//
//  WelcomeController.m
//  PdThx
//
//  Created by James Rhodes on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WelcomeController.h"
#import "PdThxAppDelegate.h"
#import "SignupViewController.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "SendMoneyController.h"

@implementation WelcomeController
@synthesize txtMobileNumber, scrollView;

//size of tab bar
int kTabBarSize = 20;
int lastCharCount = 0;

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
   
    aRect.size.height -= kbSize.height +40;
    if (!CGRectContainsPoint(aRect, currTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (currTextField.frame.origin.y + currTextField.frame.size.height) - (aRect.size.height + 40));
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
    
    if(lastCharCount < 12)
        [self showAlertView:@"Invalid Mobile Number!" message: @"Your mobile number must  be 12 digits in length"];
    else 
        [self acknowledgeDevice:txtMobileNumber.text];
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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField  {
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *numSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-"];
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int charCount = [newString length];
    
    if(lastCharCount > charCount)
    {
        if (charCount == 3 || charCount == 7) {
            newString = [newString substringToIndex:charCount - 1];
        }
        
        textField.text = newString;
        lastCharCount = [textField.text length];
        
        return NO;
    }
    
    if ([newString rangeOfCharacterFromSet:[numSet invertedSet]].location != NSNotFound
        || [string rangeOfString:@"-"].location != NSNotFound
        || charCount > 12) {
        return NO;
    }
    
    if (charCount == 3 || charCount == 7) {
        newString = [newString stringByAppendingString:@"-"];
    }
    
    textField.text = newString;
    lastCharCount = [textField.text length];
    
    return NO;
}
#pragma mark - View lifecycle
- (void) viewDidAppear: (BOOL) animated {
    txtMobileNumber.text = @"";
    txtMobileNumber.delegate = self;
    txtMobileNumber.returnKeyType = UIReturnKeyGo;
}
- (void)viewDidLoad
{
    scrollViewOriginalSize = scrollView.contentSize;
    applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
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
-(void) requestFinished: (ASIHTTPRequest *) request {
    
    NSString *theJSON = [request responseString];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    // Actually parsing the JSON
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    bool isMobileNumberRegistered = [[jsonDictionary objectForKey:@"isMobileNumberRegistered"] boolValue];
    bool doesDeviceIdMatch = [[jsonDictionary objectForKey:@"doesDeviceIdMatch"] boolValue];
    NSString* userId = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"userId"]];
    NSString* paymentAccountId = [[NSString alloc] initWithString: [jsonDictionary objectForKey: @"paymentAccountId"]];
    bool setupPassword = [[jsonDictionary objectForKey:@"setupPassword"] boolValue];
    bool setupSecurityPin = [[jsonDictionary objectForKey:@"setupSecurityPin"] boolValue];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject: txtMobileNumber.text forKey:@"mobileNumber"];
    [prefs synchronize];
    
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(!isMobileNumberRegistered)
    {
        [appDelegate switchToMainController];
    }
    else {
        
        [prefs setObject: userId forKey:@"userId"];
        [prefs setObject: paymentAccountId forKey:@"paymentAccountId"];
        [prefs setBool: setupPassword forKey:@"setupPassword"];
        [prefs setBool: setupSecurityPin forKey:@"setupSecurityPin"];

        if(setupPassword) {
            [appDelegate switchToSignInController];
        }
        else {
            [appDelegate switchToMainController];
        }

    }
    
    [userId release];
    [paymentAccountId release];

}
-(IBAction) btnBackgroundClicked:(id) sender
{
    NSLog(@"Background Clicked");

    [txtMobileNumber resignFirstResponder];
}
- (void) acknowledgeDevice:(NSString*) mobileNumber
{
    NSLog(@"Continue Clicked");
    
    NSLog(@"Acknowlodging Device");
    
    NSString *rootUrl = [NSString stringWithString: @"www.pdthx.me"];
    NSString *apiKey = [NSString stringWithString: @"bda11d91-7ade-4da1-855d-24adfe39d174"];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"http://%@/Services/UserService/UserAcknowledgement?apiKey=%@", rootUrl, apiKey]] autorelease];  
    NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                              [[UIDevice currentDevice] uniqueIdentifier], @"deviceId",
                              mobileNumber, @"mobileNumber",
                              nil];
    
    //NSDictionary *finalData = [NSDictionary dictionaryWithObject:contactData forKey:@"user"];
    NSString *newJSON = [userData JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    [request setDelegate:self];
    [request startAsynchronous];  
    
    
    //NSString* userId = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"userId"]];
    //NSString* mobileNumber = [[NSString alloc] initWithString:[jsonDictionary objectForKey: @"mobileNumber"]];
    //NSString* paymentAccountId = [jsonDictionary objectForKey: @"paymentAccountId"];
    
    // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //[prefs setObject: userId forKey:@"UserId"];
    //[prefs setObject: txtMobileNumber.text forKey:@"MobileNumber"];
    //[prefs setObject: paymentAccountId forKey:@"PaymentAccountId"];
}
- (void) showAlertView:(NSString *)title message: (NSString *) message  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
                                                      message: message
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [alertView show];
}
@end
