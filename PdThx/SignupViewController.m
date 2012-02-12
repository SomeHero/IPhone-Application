//
//  SignupViewController.m
//  Signup
//
//  Created by Parveen Kaler on 10-07-24.
//  Copyright 2010 Smartful Studios Inc. All rights reserved.
//

#import "SignupViewController.h"
#import "PdThxAppDelegate.h"
#import "TextEditCell.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "ProfileController.h"

@implementation SignupViewController
@synthesize tableView, loadCell, scrollView;


//size of tab bar
int tabBarSize = 40;

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
    

    if (!CGRectContainsPoint(aRect, CGPointMake(tableView.frame.origin.x, tableView.frame.origin.y + tableView.frame.size.height))) {
        CGPoint scrollPoint = CGPointMake(0.0, (tableView.frame.origin.y+ tableView.frame.size.height)-kbSize.height);
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
    if (textField.tag == 1)
    {
        _password = textField.text;
        [self validateUserSignIn: _userName password: _password];
    }
    
    currTextField = nil;
}
-(void)viewDidLoad
{
    self.title = @"PaiddThx";
    tableView.backgroundColor = [UIColor clearColor];
    
    scrollViewOriginalSize = scrollView.contentSize;
    applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _userName = [prefs objectForKey:@"mobileNumber"];
    
    UIApplication *app = [UIApplication sharedApplication];
    if(!app.statusBarHidden) {
        [self.view setFrame:CGRectMake(0.0,20, 320,460)];
    }
    
    [self registerForKeyboardNotifications];
    
    [super viewDidLoad];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [tableView reloadData];
}

- (void)viewDidUnload 
{
  [super viewDidUnload];

  self.tableView = nil;
}

- (void)dealloc 
{
    [tableView release];
    [loadCell release];
    [scrollView release];
    
    [super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
  for (int i = 0; i < 2; ++i) 
  {
    TextEditCell* cell = (TextEditCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i 
                                                                                                 inSection:0]];
    if ([cell.textField isFirstResponder]) 
    {
      [cell.textField resignFirstResponder];
      break;
    }
  }
}


#pragma mark TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  static NSString *CellIdentifier = @"TextEditCell";
  TextEditCell *cell = (TextEditCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
  {
    [[NSBundle mainBundle] loadNibNamed:@"TextEditCell" owner:self options:nil];
    cell = loadCell;
    self.loadCell = nil;
  }
  
  // TODO: Refactor this initialization code into the TextEditCell class
  if (indexPath.row == 0)
  {
    cell.fieldLabel.text = @"User Name";
    cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    cell.textField.returnKeyType = UIReturnKeyNext;
    cell.textField.text = [prefs objectForKey:@"mobileNumber"];
      cell.textField.enabled = false;
  }
  else if (indexPath.row == 1)
  {
    cell.fieldLabel.text = @"Password";
    cell.textField.returnKeyType = UIReturnKeyGo;
    cell.textField.secureTextEntry = YES;
    cell.textField.placeholder = @"Required";
  }
  
  cell.textField.tag = indexPath.row;
  cell.textField.delegate = self;
  cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  cell.textField.enablesReturnKeyAutomatically = YES;
  
  return cell;
}
-(BOOL)validateUserSignIn: (NSString*) userName password: (NSString*) password {
    NSLog(@"Validating User SignIn");
    
    [self signInUser:userName withPassword:password];
}
-(void) actionButtonClicked:(id)sender{
    NSLog(@"Action Button Clicked");
    
    ProfileController* viewController = [[ProfileController alloc] initWithNibName:@"ProfileController" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
}
-(IBAction) btnForgotPasswordClicked:(id) sender 
{
    NSLog(@"Forgot Password Clicked");
    
    //ForgotPasswordController* viewController = [[ForgotPasswordController alloc] initWithNibName:@"ForgotPasswordController" bundle:nil];
    
    //[self.navigationController pushViewController:viewController animated:YES];
    
    //[viewController release];
                                                
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  
  if (textField.tag == 1)
  {
    NSLog(@"Password: %@", textField.text);
  }
  
  return NO;
}
-(IBAction) bgTouched:(id)sender;
{
    [tableView resignFirstResponder];
}
-(void) signInUser:(NSString*) myUserName withPassword:(NSString *) myPassword {
    
    NSString *rootUrl = [NSString stringWithString: @"www.pdthx.me"];
    NSString *apiKey = [NSString stringWithString: @"bda11d91-7ade-4da1-855d-24adfe39d174"];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"http://%@/Services/UserService/SignIn?apiKey=%@", rootUrl, apiKey]] autorelease];  
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
        
        PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
             
        [appDelegate switchToMainController];
        
        
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
- (void) showAlertView:(NSString *)title withMessage: (NSString *) message  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
                                                        message: message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}


@end
