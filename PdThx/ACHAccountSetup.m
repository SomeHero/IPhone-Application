//
//  ACHAccountSetup.m
//  PdThx
//
//  Created by James Rhodes on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ACHAccountSetup.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "PdThxAppDelegate.h"

@implementation ACHAccountSetup
@synthesize scrollView, recipientMobileNumber, amount, comment,txtNameOnAccount,txtRoutingNumber,txtAccountNumber, txtAccountNumberConfirm;

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

    aRect.size.height -= (kbSize.height);
    if (!CGRectContainsPoint(aRect, currTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (currTextField.frame.origin.y + currTextField.frame.size.height) - (aRect.size.height));
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
    [recipientMobileNumber release];
    [amount release];
    [comment release];
    [txtNameOnAccount release];
    [txtRoutingNumber release];
    [txtAccountNumber release];
    [txtAccountNumberConfirm release];

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
-(IBAction) btnContinueClicked:(id) sender {
    NSLog(@"Adding ACH Account");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userId"];
    
    NSString* accountNumber = txtAccountNumber.text;
    NSString* nameOnAccount = txtNameOnAccount.text;
    NSString* routingNumber = txtRoutingNumber.text;
    NSString* accountType = @"Checking";
    
    [self setupACHAccount:accountNumber forUser:userId withNameOnAccount:nameOnAccount withRoutingNumber:routingNumber ofAccountType:accountType];
}
-(void) setupACHAccount:(NSString *) accountNumber forUser:(NSString *) userId withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType
{
    
    NSString *rootUrl = [NSString stringWithString: @"pdthx.me"];
    NSString *apiKey = [NSString stringWithString: @"bda11d91-7ade-4da1-855d-24adfe39d174"];
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"http://%@/Services/PaymentAccountService/PaymentAccounts?apiKey=%@", rootUrl, apiKey]] autorelease];  
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userId, @"userId",
                                 //deviceId, @"deviceId",
                                 nameOnAccount, @"nameOnAccount",
                                 routingNumber, @"routingNumber",
                                 accountNumber, @"accountNumber",
                                 accountType, @"accountType",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(setupACHAccountComplete:)];
    [request setDidFailSelector:@selector(setupACHAccountFailed:)];
    
    [request startAsynchronous];
}
-(void) setupACHAccountComplete: (ASIHTTPRequest *) request {
    
    NSString *theJSON = [request responseString];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    bool success = YES;
    NSString *paymentAccountId = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"paymentAccountId"]];

    if(success) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:paymentAccountId forKey:@"paymentAccountId"];
        [prefs synchronize];
        
        PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate switchToConfirmation];
    }
    else {
        
    }
    
    [paymentAccountId release];
    
}
-(void) setupACHAccountFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Setup ACH Account Failed");
}

-(IBAction) bgTouched:(id) sender {
    [txtNameOnAccount resignFirstResponder];
    [txtRoutingNumber resignFirstResponder];
    [txtAccountNumber resignFirstResponder];
    [txtAccountNumberConfirm resignFirstResponder];
}
@end
