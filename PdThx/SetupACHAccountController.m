 //
//  SetupACHAccountController.m
//  PdThx
//
//  Created by James Rhodes on 4/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SetupACHAccountController.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "Environment.h"
#import "SetupACHAccountController.h"
#import "HomeViewController.h"
#import "PdThxAppDelegate.h"
#import "CustomSecurityPinSwipeController.h"
#import "AddSecurityQuestionViewController.h"

@implementation SetupACHAccountController

@synthesize txtNameOnAccount;
@synthesize txtConfirmAccountNumber;
@synthesize txtAccountNumber;
@synthesize txtRoutingNumber;
@synthesize userSetupACHAccountComplete;
@synthesize securityPin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"HI_RYAN"];
    }
    return self;
}

- (void)dealloc
{
    [txtNameOnAccount release];
    [txtRoutingNumber release];
    [txtAccountNumber release];
    [txtConfirmAccountNumber release];
    [btnSetupACHAccount release];
    [userSetupACHAccountService release];
    [controller release];
    [securityQuestionController release];
    [validationHelper release];

    [skipButton release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem =nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarController.tabBar setUserInteractionEnabled:NO];

    validationHelper = [[ValidationHelper alloc] init];
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:0.0]; // Old Width 1.0
    [[viewPanel layer] setCornerRadius: 8.0];
    
    
    // Do any additional setup after loading the view from its nib.
    [self setTitle: @"Enable Payments"];
    
    userSetupACHAccountService = [[UserSetupACHAccount alloc] init];
    [userSetupACHAccountService setUserACHSetupCompleteDelegate: self];

    
    
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"SetUpACHAccountController"
                                        withError:&error]){
        //Handle Error Here
    }
}
-(void)viewDidAppear:(BOOL)animated {
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
}
- (void)viewDidUnload
{
    [skipButton release];
    skipButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(BOOL)	textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [textField resignFirstResponder];
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard and try to create ach account
        [textField resignFirstResponder];

        controller = [[[GenericSecurityPinSwipeController alloc] init] autorelease];
        
        [controller setSecurityPinSwipeDelegate: self];
        [controller setNavigationTitle: @"Setup your Pin"];
        [controller setHeaderText:@"Hello"];
        
        
        
        [controller setTag:1];
        
        [self presentModalViewController:controller animated:YES];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)createACHAccount:(NSString*)pin withSecurityQuestionId:(int)questionId withSecurityQuestionAnswer:(NSString*)questionAnswer
{
    NSString* nameOnAccount = @"";
    NSString* routingNumber =  @"";
    NSString* accountNumber = @"";
    NSString* confirmAccountNumber = @"";
    NSString* accountType = @"Checking";
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString* userId = [prefs stringForKey:@"userId"];

    if([txtNameOnAccount.text length] > 0)
        nameOnAccount = [NSString stringWithString: txtNameOnAccount.text];

    if([txtRoutingNumber.text length] > 0)
        routingNumber = [NSString stringWithString: txtRoutingNumber.text];

    if([txtAccountNumber.text length] > 0)
        accountNumber = [NSString stringWithString: txtAccountNumber.text];

    if([txtConfirmAccountNumber.text length] > 0)
        confirmAccountNumber = [NSString stringWithString: txtConfirmAccountNumber.text];

    BOOL isValid = YES;

    if(isValid && ![validationHelper isValidNameOnAccount:nameOnAccount])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid account name"];
        
        isValid = NO;
    }
    if(isValid && ![validationHelper isValidRoutingNumber:routingNumber])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid routing number"];

        isValid = NO;
    }
    if(isValid && ![validationHelper isValidAccountNumber:accountNumber])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid account number"];

        isValid = NO;
    }
    if(isValid && ![validationHelper doesAccountNumberMatch: accountNumber doesMatch: confirmAccountNumber])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Account number mismatch"];

        isValid = NO;
    }

    if(isValid) {
        NSLog(@"Registering with SecurityQuestionId and Answer: %d -- %@", questionId, questionAnswer);

        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Linking Account" withDetailedStatus:@"Securing information"];
        
        [userSetupACHAccountService setupACHAccount:accountNumber forUser:userId withNickname:@"" withNameOnAccount:nameOnAccount withRoutingNumber:routingNumber ofAccountType:accountType withSecurityPin:securityPin withSecurityQuestionID:questionId withSecurityQuestionAnswer:questionAnswer];
    }
}

-(void)userACHSetupDidComplete:(NSString*) paymentAccountId {

    txtAccountNumber.text = @"";
    txtConfirmAccountNumber.text = @"";
    txtRoutingNumber.text = @"";
    txtNameOnAccount.text = @"";
    
    user.preferredPaymentAccountId = paymentAccountId;
    user.preferredReceiveAccountId = paymentAccountId;
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow:self];
    // Move to Home View Controller inside NavigationController again
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)userACHSetupDidFail:(NSString*) message {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Unable to link account"];
    NSLog(@"Error linking bank account: %@", message);
}

-(IBAction) btnSetupACHAccountClicked:(id) sender {
    
    [txtAccountNumber resignFirstResponder];
    [txtConfirmAccountNumber resignFirstResponder];
    [txtNameOnAccount resignFirstResponder];
    [txtRoutingNumber resignFirstResponder];
    
    controller = [[[GenericSecurityPinSwipeController alloc] init] autorelease];
    [controller setSecurityPinSwipeDelegate: self];
    
    [controller setNavigationTitle: @"Setup your Pin"];
    //[controller setHeaderText: [NSString stringWithFormat:@"To complete setting up your account, create a pin by connecting 4 buttons below."]];
    [controller setTag:1];
    
    [self presentModalViewController:controller animated:YES];
}
-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin;
{
    if([sender tag] == 1)
    {
        controller = [[[GenericSecurityPinSwipeController alloc] init] autorelease];
        
        [controller setSecurityPinSwipeDelegate: self];
        [controller setNavigationTitle: @"Confirm your Pin"];
        //[controller setHeaderText: [NSString stringWithFormat:@"To complete setting up your account, create a pin by connecting 4 buttons below."]];
        [controller setTag:2];    
        [self presentModalViewController:controller animated:YES];
    }
    else if([sender tag] == 2)
    {
        securityPin = pin;

        securityQuestionController = [[[AddSecurityQuestionViewController alloc] init] autorelease];
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:securityQuestionController];
        
        [securityQuestionController setSecurityQuestionEnteredDelegate:self];
        [securityQuestionController setNavigationTitle: @"Add a Security Question"];

        [self presentModalViewController:navBar animated:YES];
        [navBar release];
    }
}

-(void)choseSecurityQuestion:(int)questionId withAnswer:(NSString *)questionAnswer
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showSuccessWithStatus:@"Question Created" withDetailedStatus:@"Added security question"];
    
    [self createACHAccount:securityPin withSecurityQuestionId:questionId withSecurityQuestionAnswer:questionAnswer];
}

-(void)swipeDidCancel: (id)sender
{
    [self.navigationController dismissModalViewControllerAnimated: YES];
}
-(IBAction) btnRemindMeLaterClicked:(id)sender {
    /*
        User has selected to skip the ACH Bank Account Add Form
            An alert view is shown with the following information:
                "Without adding a bank account, you will not be able to send or receive money using PaidThx. Press "Go Back" to add a bank account now.
                        Press "Ok" to skip adding a bank account. You are able to add a bank account later under the "Settings" tab"
                    Possible UIAlertViewButton Clicks:
                        [Go Back] [Ok]
     */
    
    
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
    // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
    // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
    // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
    
    [appDelegate showTwoButtonAlertView:false withTitle:@"Warning" withSubtitle:@"Don't skip this!" withDetailedText:@"If you skip linking a bank account to PaidThx, you will not be able to send or receive money. For the best experience, click \"Go Back\" and setup your account now. You can also set one up in the \"Settings\" area later." withButton1Text:@"Skip" withButton2Text:@"Go Back" withDelegate:self];
}

-(void)didSelectButtonWithIndex:(int)index
{
    if ( index == 0 ){
        NSLog(@"User skipped adding bank account");
        
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate dismissAlertView];
        
        [appDelegate switchToMainAreaTabbedView];
    } else if ( index == 1 ){
        NSLog(@"User chose to add bank account.");
        
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate dismissAlertView];
        // Simply dismisses the alert view and allows the person to retry entering bank information
    } else {
        NSLog(@"Error, invalid alert view answer chosen.");
    }
}


-(void) setupACHAccount:(NSString *) accountNumber forUser:(NSString *) userId withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType
{
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];

    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Services/PaymentAccountService/PaymentAccounts?apikey=%@", rootUrl, apiKey]] autorelease];
    
    [rootUrl release];
    [apiKey release];
    
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
        
        user.preferredPaymentAccountId = paymentAccountId;
        user.preferredReceiveAccountId = paymentAccountId;
        
    }
    else {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Unable to link account"];
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
    [txtConfirmAccountNumber resignFirstResponder];
}



@end
