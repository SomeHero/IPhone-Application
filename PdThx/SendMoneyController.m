//
//  SendMoneyController.m
//  PdThx
//
//  Created by James Rhodes on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "PdThxAppDelegate.h"
#import "SendMoneyController.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "Contact.h"
#import "SignInViewController.h"
#import "SetupSecurityPin.h"
#import "SendMoneyService.h"
#import "ContactSelectViewController.h"
#import "KeyboardAccessoryViewController.h"

@interface SendMoneyController ()
- (void)sendMoney;

@end

@implementation SendMoneyController
@synthesize whiteBoxView, viewPanel, txtAmount, txtComments, btnSendMoney, amount, lm;
@synthesize chooseRecipientButton, contactHead, contactDetail, recipientImageButton, recipientUri, chooseAmountButton;

float tableHeight2 = 30;

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
    
    /*                View/Services Releases                   */
    /*  ------------------------------------------------------ */
    [viewPanel release];
    [whiteBoxView release];
    [sendMoneyService release];
    [lm release];
    
    /*                Image/TextField Releases                 */
    /*  ------------------------------------------------------ */
    [txtAmount release];
    [txtComments release];
    [securityPinModalPanel release];
    [amount release];
    [comments release];
    [recipientImageButton release];
    [chooseRecipientButton release];
    [contactHead release];
    [contactDetail release];
    [chooseAmountButton release];
    
    [btnSendMoney release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle
-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*                  View Setup              */
    /*  --------------------------------------- */
    scrollView.frame = CGRectMake(0, 0, 320, 420);
    [scrollView setContentSize:CGSizeMake(320, 420)];
    [whiteBoxView.layer  setCornerRadius:7.0];
    
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    
    /*          Location Services Setup         */
    /*  --------------------------------------- */
    lm = [[CLLocationManager alloc] init];
    if ([lm locationServicesEnabled]) {
        lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyBest;
        lm.distanceFilter = 1000.0f;
        [lm startUpdatingLocation];
    }
    
    
    /*         Button Visiblity Handling        */
    /*  --------------------------------------- */
    chooseRecipientButton.backgroundColor = [UIColor clearColor];
    chooseAmountButton.backgroundColor = [UIColor clearColor];
    [recipientImageButton.layer setCornerRadius:4.0];
    [recipientImageButton.layer setMasksToBounds:YES];
    
    
    
    /*          Services/ViewController Initialization         */
    /*  ------------------------------------------------------ */
    sendMoneyService = [[SendMoneyService alloc] init];
    [sendMoneyService setSendMoneyCompleteDelegate:self];
    
    
    
    
    
    /*                TextField Initialization                 */
    /*  ------------------------------------------------------ */
    autoCompleteArray = [[NSMutableArray alloc] init];
    recipientUri = [[NSString alloc] initWithString: @""];
    amount = [[NSString alloc] initWithString: @""];
    
    
    comments = [[NSString alloc] initWithString: @""];
    
    self.navigationItem.title = @"Send $";
    
    [txtAmount setDelegate:self];
    txtAmount.text = @"$0.00";
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
}

- (void)viewDidUnload
{
    [lm stopUpdatingLocation];
    [recipientImageButton release];
    recipientImageButton = nil;
    [chooseRecipientButton release];
    chooseRecipientButton = nil;
    [contactHead release];
    contactHead = nil;
    [contactDetail release];
    contactDetail = nil;
    [whiteBoxView release];
    [chooseAmountButton release];
    chooseAmountButton = nil;
    // [self setPressedAmountButton:nil];
    [txtComments release];
    txtComments = nil;
    [btnSendMoney release];
    btnSendMoney = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    //e.g. self.myOutlet = nil;
}



/*  ------------------------------------------------------ */
/*                Location Services                        */
/*  ------------------------------------------------------ */

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation != nil) {
        latitude = newLocation.coordinate.latitude;
        longitude = newLocation.coordinate.longitude;
    }
}



/*  ------------------------------------------------------ */
/*                Button Action Handling                   */
/*  ------------------------------------------------------ */


-(void) signOutClicked {
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate signOut];
    
    UINavigationController *navController = self.navigationController;
    
    SendMoneyController *sendMoneyController = [[[SendMoneyController alloc] initWithNibName:@"SendMoneyController" bundle:nil] autorelease];
    
    [self removeCurrentViewFromNavigation:navController];
    [navController pushViewController:sendMoneyController animated: YES];
    
}


- (IBAction)pressedChooseRecipientButton:(id)sender 
{
    ContactSelectViewController *newView = [[ContactSelectViewController alloc] initWithNibName:@"ContactSelectViewController" bundle:nil];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.contactSelectChosenDelegate = self;
}

- (IBAction)pressedAmountButton:(id)sender {
}


-(IBAction) btnSendMoneyClicked:(id)sender {
    [self sendMoney];
}

-(IBAction) bgTouched:(id) sender {
    [txtAmount resignFirstResponder];
    [txtComments resignFirstResponder];
}


- (void)sendMoney {
    
    if([txtAmount.text length] > 0) {
        amount = [[txtAmount.text stringByReplacingOccurrencesOfString:@"$" withString:@""] copy];
    }
    
    if([txtComments.text length] > 0)
        comments = [txtComments.text copy];
    
    BOOL isValid = YES;
    
    if(isValid && ![self isValidRecipientUri:recipientUri])
    {
        [self showAlertView:@"Invalid Recipient!" withMessage: @"You specified an invalid recipient.  Please try again."];
        
        isValid = NO;
    }
    if(isValid && ![self isValidAmount:amount])
    {
        [self showAlertView:@"Invalid Amount" withMessage:@"You specified an invalid amount to send.  Please try again."];
        
        isValid = NO;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    if(isValid) {
        NSString* userId = [prefs stringForKey:@"userId"];
        
        if([userId length] > 0)
            [self showModalPanel];
        else
        {
            SignInViewController *signInViewController = [[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil] autorelease];
            
            [signInViewController setSignInCompleteDelegate:self];
            [signInViewController setAchSetupCompleteDelegate:self];
            
            [self.navigationController pushViewController:signInViewController animated:YES];
        }
    }
}



/*  --------------------------------------------------------- */
/*                Services                                    */
/*  --------------------------------------------------------- */

-(void) sendMoneyService:(NSString *)theAmount toRecipient:(NSString *)theRecipient fromMobileNumber:(NSString *)fromMobileNumber withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount {

    Environment *myEnvironment = [Environment sharedInstance];
    NSString *rootUrl = [[NSString alloc] initWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *apiKey = [[NSString alloc] initWithString: myEnvironment.pdthxAPIKey];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"%@/Services/PaymentService/Payments?apiKey=%@", rootUrl, apiKey]] autorelease];  
    NSDictionary *paymentData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 userId, @"userId",
                                 securityPin, @"securityPin",
                                 fromMobileNumber, @"fromMobileNumber",
                                 theRecipient, @"toMobileNumber",
                                 theAmount, @"amount",
                                 theComments, @"comment",
                                 fromAccount, @"fromAccount",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation];

    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(sendMoneyComplete:)];
    [request setDidFailSelector:@selector(sendMoneyFailed:)];
    
    [request startAsynchronous];

    [paymentData release];
    [apiKey release];
    [rootUrl release];
}



/*  --------------------------------------------------------- */
/*               Local Class Methods                          */
/*  --------------------------------------------------------- */

-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest {
    if([recipientUriToTest length]  == 0)
        return false;
    
    if(isnumber([recipientUriToTest characterAtIndex:0])) {
        NSCharacterSet *numSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-"];
    
    @try {
        if(([[recipientUriToTest stringByTrimmingCharactersInSet:numSet] isEqualToString:@""]) && ([[recipientUriToTest stringByReplacingOccurrencesOfString:@"-" withString:@""] length] == 10))
            return true;
        else
            return false;
    }
    @catch (NSException *exception) {
        return false;
        }   
    } else {
       return true;
    }
}

-(BOOL) isValidAmount:(NSString *) amountToTest {
    amountToTest = [amountToTest stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    @try {
        if([amountToTest floatValue] > 0.00)
            return true;
        else 
            return false;
    }
    @catch(NSException *ex) {
        return false;
    }
}


/*  --------------------------------------------------------- */
/*                Protocol Delegate Methods                   */
/*  --------------------------------------------------------- */


#pragma mark SignCompleteProtocol methods
-(void)signInDidComplete {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self showModalPanel];
}

#pragma mark ACHSetupCompleteProtocol methods
-(void)achSetupDidComplete {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self showModalPanel];
}


-(void) securityPinComplete:(ConfirmPaymentDialogController *) modalPanel
               selectedCode:(NSString*) code {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* userId = [prefs stringForKey:@"userId"];
    NSString* senderUri;
    NSString* username = [prefs stringForKey:@"userName"];
    
    NSString* recipientImageUri = [NSString stringWithString: @""];
    NSString* recipientFirstName = [NSString stringWithString: @""];
    NSString* recipientLastName =[NSString stringWithString: @""];
    
    if ( [[username substringToIndex:3] isEqual:@"fb_"] ) {
        senderUri = username;
    }
    else
        senderUri = [prefs stringForKey:@"mobileNumber"];
    
    if([[recipientUri substringToIndex:3] isEqual:@"fb_"]) {
        recipientImageUri = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", recipient.facebookID];
        recipientFirstName = [NSString stringWithFormat: @"%@", recipient.firstName];
        recipientLastName = [NSString stringWithFormat: @"%@", recipient.lastName];
    }
    
    NSString* fromAccount = [prefs stringForKey:@"paymentAccountId"];
    
    [sendMoneyService sendMoney:amount toRecipient:recipientUri fromSender:senderUri withComment:comments withSecurityPin:code fromUserId:userId withFromAccount:fromAccount withFromLatitude:latitude withFromLongitude: longitude withRecipientFirstName: recipientFirstName withRecipientLastName: recipientLastName withRecipientImageUri: recipientImageUri];
}

-(void)sendMoneyDidComplete {
    [self.scrollView scrollsToTop];
    [securityPinModalPanel hide];
    
    recipientUri = @"";
    [txtAmount setText: @"$0.00"];
    [txtComments setText: @""];
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    [recipientImageButton setBackgroundImage:NULL forState:UIControlStateNormal];
    
    NSString* message = [NSString stringWithString:@"Your money was sent"];
    
    [[self scrollView] setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self showAlertView:@"Money Sent!" withMessage: message];
}

-(void)sendMoneyDidFail:(NSString*) message {
    [self showAlertView: @"Error Sending Money" withMessage: message];
}

-(void)didChooseContact:(Contact *)contact
{
    recipient = contact;
    if ( contact.imgData )
        [recipientImageButton setBackgroundImage:contact.imgData forState:UIControlStateNormal];
    else if ( contact.facebookID.length > 0 )
        [recipientImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", contact.facebookID]]]] forState:UIControlStateNormal];
    else
        [recipientImageButton setBackgroundImage:NULL forState:UIControlStateNormal];
    
    
    recipientImageButton.imageView.image = nil;
    
    contactHead.text = contact.name;
    
    if ( contact.facebookID.length > 0 ){
        contactDetail.text = @"Facebook Friend";
    } else if ( contact.phoneNumber ){
        contactDetail.text = contact.phoneNumber;
    } else if ( contact.emailAddress.length > 0 ){
        contactDetail.text = contact.emailAddress;
    }else {
        contactDetail.text = @"No Info to Display";
    }
    
    self.recipientUri = contact.recipientUri;
    
}


#pragma mark UITextFieldDelegate methods
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        
        [self sendMoney];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}



// String in Search textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == 1) {
        NSMutableString *tempAmount = [NSMutableString stringWithString:@""];
        [tempAmount appendString: @"$"];
        
        if([string isEqualToString:@""]) {
            for (int i = 0; i< [textField.text length] - 1; i++) {
                if([string length] == 0 && i == [textField.text length] - 1)
                    continue;
                
                char digit;
                digit = (char) [textField.text characterAtIndex:(NSUInteger) i];
                
                if(digit == '$')
                    continue;
                if(digit == '.')
                    continue;
                
                [tempAmount appendString: [NSString stringWithFormat:@"%c", digit]];
            }
            [tempAmount appendString: string];
            [tempAmount insertString: @"." atIndex: [tempAmount length] -2];
            if([tempAmount length] < 5)
                [tempAmount insertString:@"0" atIndex:1];
            [textField setText:tempAmount];
        }
        else if([string stringByTrimmingCharactersInSet:
                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length > 0){
            
            BOOL firstDigit = YES;
            for (int i = 0; i< [textField.text length]; i++) {
                
                char digit = (char) [textField.text characterAtIndex:(NSUInteger) i];
                
                if(digit == '$')
                    continue;
                if(digit == '.')
                    continue;
                if(digit == '0' && firstDigit) {
                    firstDigit = NO;
                    continue;
                    
                }
                firstDigit = NO;
                [tempAmount appendString: [NSString stringWithFormat:@"%c", digit]];
            }
            [tempAmount appendString: string];
            [tempAmount insertString: @"." atIndex: [tempAmount length] -2];
            if([tempAmount length] < 5)
                [tempAmount insertString:@"0" atIndex:1];
            [textField setText:tempAmount];
            
        }
        
        return NO;
    }
    return YES;
}


-(void) sendMoneyComplete:(ASIHTTPRequest *)request
{
    NSString *theJSON = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    bool success = [[jsonDictionary objectForKey:@"success"] boolValue];
    NSString *message = [jsonDictionary objectForKey:@"message"];
    
    if(success) {
        
        [self.scrollView scrollsToTop];
        [securityPinModalPanel hide];
        
        recipientUri = @"";
        [txtAmount setText: @"$0.00"];
        [txtComments setText: @""];
        
        [[self scrollView] setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        [self showAlertView:@"Money Sent!" withMessage: message];
        
    }
    else {
        [self showAlertView: @"Sorry. Try Again!" withMessage:message];
    }
    
}

-(void) sendMoneyFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Send Money Failed");
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if(textField.tag == 1)
    {
        [textField setText: @"$0.00"];
        
        return NO;
    } 
    
    return YES;
}

- (IBAction)showModalPanel {
         
    [txtAmount resignFirstResponder];
    [txtComments resignFirstResponder];
    
    securityPinModalPanel = [[[ConfirmPaymentDialogController alloc] initWithFrame:self.view.bounds] autorelease];
    
    securityPinModalPanel.dialogTitle.text = @"Confirm Your Payment";
    securityPinModalPanel.dialogHeading.text = [NSString stringWithFormat: @"To confirm your payment of %@ to %@, swipe your pin below.", [[txtAmount.text copy] autorelease], recipientUri];
    [securityPinModalPanel.btnCancelPayment setTitle: @"Cancel Payment" forState: UIControlStateNormal];
    securityPinModalPanel.delegate = self;
    
    ///////////////////////////////////
    // Add the panel to our view
    [self.view addSubview:securityPinModalPanel];
         
    ///////////////////////////////////
    // Show the panel from the center of the button that was pressed
    [securityPinModalPanel show];
}
     
     
#pragma mark - UAModalDisplayPanelViewDelegate 
     
     // Optional: This is called before the open animations.
     //   Only used if delegate is set.
     - (void)willShowModalPanel:(UAModalPanel *)modalPanel {
         UADebugLog(@"willShowModalPanel called with modalPanel: %@", modalPanel);
     }
     
     // Optional: This is called after the open animations.
     //   Only used if delegate is set.
     - (void)didShowModalPanel:(UAModalPanel *)modalPanel {
         UADebugLog(@"didShowModalPanel called with modalPanel: %@", modalPanel);
     }
     
     // Optional: This is called when the close button is pressed
     //   You can use it to perform validations
     //   Return YES to close the panel, otherwise NO
     //   Only used if delegate is set.
     - (BOOL)shouldCloseModalPanel:(UAModalPanel *)modalPanel {
         UADebugLog(@"shouldCloseModalPanel called with modalPanel: %@", modalPanel);
         return YES;
     }
     
     // Optional: This is called before the close animations.
     //   Only used if delegate is set.
     - (void)willCloseModalPanel:(UAModalPanel *)modalPanel {
         UADebugLog(@"willCloseModalPanel called with modalPanel: %@", modalPanel);
     }
     
     // Optional: This is called after the close animations.
     //   Only used if delegate is set.
     - (void)didCloseModalPanel:(UAModalPanel *)modalPanel {
         UADebugLog(@"didCloseModalPanel called with modalPanel: %@", modalPanel);
     }
    
@end


/*
 #pragma mark UITableViewDelegate methods
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
 
 //Resize auto complete table based on how many elements will be displayed in the table
 if (autoCompleteArray.count >=3) {
 autoCompleteTableView.frame = CGRectMake(txtRecipientUri.frame.origin.x+2, viewPanel.frame.origin.y +  txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, tableHeight2*3);
 return autoCompleteArray.count;
 }
 
 else if (autoCompleteArray.count == 2) {
 autoCompleteTableView.frame = CGRectMake(txtRecipientUri.frame.origin.x+2, viewPanel.frame.origin.y + txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, tableHeight2*2);
 return autoCompleteArray.count;
 }
 else if (autoCompleteArray.count >= 1) {
 autoCompleteTableView.frame = CGRectMake(txtRecipientUri.frame.origin.x+2, viewPanel.frame.origin.y + txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, tableHeight2);
 return autoCompleteArray.count;
 }
 else  {
 autoCompleteTableView.frame = CGRectMake(txtRecipientUri.frame.origin.x+2, viewPanel.frame.origin.y +  txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, 0);
 return autoCompleteArray.count;
 }
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell;
 static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
 cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
 if (cell == nil) {
 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier] autorelease];
 }
 Contact *contact = [autoCompleteArray objectAtIndex:indexPath.row];
 
 cell.textLabel.text = contact.phoneNumber;
 cell.detailTextLabel.text = contact.name;
 cell.isAccessibilityElement = YES;
 
 return cell;
 }
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
 txtRecipientUri.text = [[[NSString alloc] initWithString:[[selectedCell.textLabel.text copy] autorelease]] autorelease];
 
 NSInteger nextTag = txtRecipientUri.tag + 1;
 // Try to find next responder
 UIResponder* nextResponder = [txtRecipientUri.superview viewWithTag:nextTag];
 if (nextResponder) {
 // Found next responder, so set it.
 [nextResponder becomeFirstResponder];
 } else {
 // Not found, so remove keyboard.
 [txtRecipientUri resignFirstResponder];
 
 [self sendMoney];
 }
 
 [self finishedSearching];
 }
 */

