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
#import "AmountSelectViewController.h"

@interface SendMoneyController ()
- (void)sendMoney;

@end

@implementation SendMoneyController

@synthesize whiteBoxView, viewPanel, txtAmount, txtComments, amount, lm;
@synthesize chooseRecipientButton, contactHead, contactDetail, recipientImageButton, recipientUri, chooseAmountButton, btnSendMoney;

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
    
    /*  ------------------------------------------------------ */
    /*                View/Services Releases                   */
    /*  ------------------------------------------------------ */
    [viewPanel release];
    [whiteBoxView release];
    [sendMoneyService release];
    [lm release];
    
    /*  ------------------------------------------------------ */
    /*                Image/TextField Releases                 */
    /*  ------------------------------------------------------ */
    [txtAmount release];
    [txtComments release];
    [user release];
    [amount release];
    [comments release];
    [recipientImageButton release];
    [chooseRecipientButton release];
    [contactHead release];
    [contactDetail release];
    [chooseAmountButton release];
    
    [btnSendMoney release];
    [contactButtonBGImage release];
    [amountButtonBGImage release];
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
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
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
    
    contactButtonBGImage.highlighted = NO;
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
    [recipientImageButton.layer setCornerRadius:5.0];
    [recipientImageButton.layer setMasksToBounds:YES];
    [recipientImageButton.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [recipientImageButton.layer setBorderWidth:0.7]; // 28 24 20
    
    
    
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
    
    [self setTitle:@"Send $"];
    
    [txtAmount setDelegate:self];
    txtAmount.text = @"0.00";
    
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
    [contactButtonBGImage release];
    contactButtonBGImage = nil;
    [amountButtonBGImage release];
    amountButtonBGImage = nil;
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

- (IBAction)pressedChooseRecipientButton:(id)sender 
{
    ContactSelectViewController *newView = [[ContactSelectViewController alloc] initWithNibName:@"ContactSelectViewController" bundle:nil];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.contactSelectChosenDelegate = self;
}

- (IBAction)pressedAmountButton:(id)sender 
{
    AmountSelectViewController *newView = [[AmountSelectViewController alloc] initWithNibName:@"AmountSelectViewController" bundle:nil];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.amountChosenDelegate = self;
}


-(IBAction) btnSendMoneyClicked:(id)sender {
    
    User* user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
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
    if(isValid) {
        //Check to make sure the user has completed post reg signup process
        //if((user.preferredPaymentAccountId == (id)[NSNull null] || [user.preferredPaymentAccountId length] == 0))
        
        //[((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
        
        CustomSecurityPinSwipeController *controller=[[[CustomSecurityPinSwipeController alloc] init] autorelease];
        [controller setSecurityPinSwipeDelegate: self];
        [controller setNavigationTitle: @"Confirm"];
        [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your payment of $%0.2f to %@.", [amount doubleValue], recipientUri]];
        
        [self presentModalViewController:controller animated:YES];
    }
}

-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{
    NSString* recipientImageUri = [NSString stringWithString: @""];
    NSString* recipientFirstName = [NSString stringWithString: @""];
    NSString* recipientLastName =[NSString stringWithString: @""];
    
    if([[recipientUri substringToIndex:3] isEqual:@"fb_"]) {
        recipientImageUri = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", recipient.facebookID];
        recipientFirstName = [NSString stringWithFormat: @"%@", recipient.firstName];
        recipientLastName = [NSString stringWithFormat: @"%@", recipient.lastName];
    }

    
    [sendMoneyService sendMoney:amount toRecipient:recipientUri fromSender:user.userUri withComment:comments withSecurityPin:pin fromUserId:user.userId withFromAccount:user.preferredPaymentAccountId withFromLatitude:latitude withFromLongitude: longitude withRecipientFirstName: recipientFirstName withRecipientLastName: recipientLastName withRecipientImageUri: recipientImageUri];
}

-(void)swipeDidCancel: (id)sender
{
    //do nothing
}

-(IBAction) bgTouched:(id) sender {
    [txtAmount resignFirstResponder];
    [txtComments resignFirstResponder];
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

-(void)sendMoneyDidComplete {
    [self.scrollView scrollsToTop];
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    TransactionConfirmationViewController*  controller = [[[TransactionConfirmationViewController alloc] init] retain];
    controller.confirmationText = [NSString stringWithFormat: @"Success! Your payment of $%0.2f was sent to %@.", [amount doubleValue], recipientUri];
    [controller setTransactionConfirmationDelegate: self];
    
    [self presentModalViewController:controller animated:YES];
}

-(void)sendMoneyDidFail:(NSString*) message {
    [self showAlertView: @"Error Sending Money" withMessage: message];
}
-(void)onHomeClicked {
    txtAmount.text = @"0.00";
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    txtComments.text = @"";
    
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    [recipientImageButton setBackgroundImage:NULL forState:UIControlStateNormal];
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) switchToPaystreamController];
}
-(void)onContinueClicked {
    txtAmount.text = @"0.00";
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    txtComments.text = @"";
    
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    [recipientImageButton setBackgroundImage:NULL forState:UIControlStateNormal];
    
}
-(void)didChooseContact:(Contact *)contact
{
    contactButtonBGImage.highlighted = YES;
    [recipientImageButton.layer setBorderWidth:0.7];
    recipient = contact;
    if ( contact.imgData )
        [recipientImageButton setBackgroundImage:contact.imgData forState:UIControlStateNormal];
    else if ( contact.facebookID.length > 0 )
        [recipientImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", contact.facebookID]]]] forState:UIControlStateNormal];
    else {
        [recipientImageButton setBackgroundImage:NULL forState:UIControlStateNormal];
        [recipientImageButton.layer setBorderWidth:0.0];
    }
    
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

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if(textField.tag == 1)
    {
        [textField setText: @"$0.00"];
        
        return NO;
    } 
    
    return YES;
} 

-(void)didSelectAmount:(double)amountSent
{
    amountButtonBGImage.highlighted = YES;
    txtAmount.text = [NSString stringWithFormat: @"%.2lf", amountSent];
}
@end



