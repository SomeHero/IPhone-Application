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

@interface SetupACHAccountController ()
- (void)createACHAccount;

@end

@implementation SetupACHAccountController

@synthesize txtNameOnAccount;
@synthesize txtConfirmAccountNumber;
@synthesize txtAccountNumber;
@synthesize txtRoutingNumber;
@synthesize achSetupCompleteDelegate;
@synthesize userSetupACHAccountComplete;
@synthesize skipBankAlert;

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
    //[achSetupCompleteDelegate release];

    [skipButton release];
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
    
    // Do any additional setup after loading the view from its nib.
    userSetupACHAccountService = [[UserSetupACHAccount alloc] init];
    [userSetupACHAccountService setUserACHSetupCompleteDelegate: self];
}

- (void)viewDidUnload
{
    [skipButton release];
    skipButton = nil;
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
        // Not found, so remove keyboard and try to create ach account
        [textField resignFirstResponder];

        [self createACHAccount];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)createACHAccount {
    NSString* nameOnAccount = [NSString stringWithString: @""];
    NSString* routingNumber = [NSString stringWithString: @""];
    NSString* accountNumber = [NSString stringWithString: @""];
    NSString* confirmAccountNumber = [NSString stringWithString: @""];
    NSString* accountType = [NSString stringWithString: @"Checking"];
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

    if(isValid && ![self isValidNameOnAccount:nameOnAccount])
    {
        [self showAlertView:@"Invalid Name on Account!" withMessage: @"You did not enter the name on account.  Please try again."];

        isValid = NO;
    }
    if(isValid && ![self isValidRoutingNumber:routingNumber])
    {
        [self showAlertView:@"Invalid Routing Number!" withMessage:@"The routing number you entered is invalid. Please try again."];

        isValid = NO;
    }
    if(isValid && ![self isValidAccountNumber:accountNumber])
    {
        [self showAlertView:@"Invalid Account Number!" withMessage:@"The account number you entered is invalid. Please try again."];

        isValid = NO;
    }
    if(isValid && ![self doesAccountNumberMatch: accountNumber doesMatch: confirmAccountNumber])
    {
        [self showAlertView:@"Account Number Mismatch!" withMessage:@"The account numbers do not match. Please try again."];

        isValid = NO;
    }

    if(isValid) {
        [userSetupACHAccountService setupACHAccount:accountNumber forUser:userId withNameOnAccount:nameOnAccount withRoutingNumber:routingNumber ofAccountType:accountType];
    }
}

-(void)userACHSetupDidComplete:(NSString*) paymentAccountId {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:paymentAccountId forKey:@"paymentAccountId"];
    [prefs synchronize];
    
    [achSetupCompleteDelegate achSetupDidComplete];
    
    // Move to Home View Controller inside NavigationController again
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)userACHSetupDidFail:(NSString*) message {
    [self showAlertView: @"Unable to Setup Account" withMessage:message];
}
-(IBAction) btnSetupACHAccountClicked:(id) sender {
    [self createACHAccount];
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
    
    skipBankAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Without adding a bank account, you will not be able to send or receive money using PaidThx. Press \"Go Back\" to add a bank account now. Press \"Skip\" to skip adding a bank account. You are able to add a bank account later under the \"Settings\" tab" delegate:self cancelButtonTitle:@"Skip" otherButtonTitles:@"Go Back", nil];
    
    [skipBankAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( alertView == skipBankAlert ){
        if (buttonIndex == 0) {
            NSLog(@"User skipped adding bank account");
            
            [userSetupACHAccountComplete achAccountSetupDidSkip];
            // TODO: Load Tabbed View Controller with Home View
        }
        else if ( buttonIndex == 1 ){
            NSLog(@"User chose to add bank account.");
            // Simply dismisses the alert view and allows the person to retry entering bank information
        }
        else {
            // You should never get here.
            NSLog(@"Error occurred, no valid button.");
        }
    }
}
-(void) setupACHAccount:(NSString *) accountNumber forUser:(NSString *) userId withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType
{
    
    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];

    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Services/PaymentAccountService/PaymentAccounts?apiKey=%@", rootUrl, apiKey]] autorelease];
    
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
        
        [achSetupCompleteDelegate achSetupDidComplete];
    }
    else {
        [self showAlertView:@"Unable to setup ACH Acccount!" withMessage:@"Exception setting up your bank account information"];
    }
    
    [paymentAccountId release];
    
}

-(void) setupACHAccountFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Setup ACH Account Failed");
}

-(BOOL)isValidNameOnAccount:(NSString *) nameToTest {
    if([nameToTest length] == 0)
        return false;
    
    return true;
}

-(BOOL)isValidRoutingNumber:(NSString *) routingNumberToTest {
    if([routingNumberToTest length] == 0)
        return false;
    
    return true;
}

-(BOOL)isValidAccountNumber:(NSString *) accountNumberToTest {
    if([accountNumberToTest length] == 0)
        return false;
    
    return true;
}


-(BOOL)doesAccountNumberMatch:(NSString *) accountNumberToTest doesMatch:(NSString *) confirmationNumber {
    if(![accountNumberToTest isEqualToString:confirmationNumber])
        return false;
    
    return true;
}

-(IBAction) bgTouched:(id) sender {
    [txtNameOnAccount resignFirstResponder];
    [txtRoutingNumber resignFirstResponder];
    [txtAccountNumber resignFirstResponder];
    [txtConfirmAccountNumber resignFirstResponder];
}
@end
