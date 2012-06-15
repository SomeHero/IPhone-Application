//
//  RequestMoneyController.m
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PdThxAppDelegate.h"
#import "RequestMoneyController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "Contact.h"
#import "Environment.h"
#import "SignInViewController.h"
#import "SetupSecurityPin.h"
#import "RequestMoneyService.h"
#import "ContactSelectViewController.h"
#import "AmountSelectViewController.h"

#define kOFFSET_FOR_KEYBOARD 100.0

@interface RequestMoneyController ()
- (BOOL)isValidRecipientUri:(NSString *)recipientUriToTest;
- (BOOL)isValidAmount:(NSString *)amountToTest;

- (void)requestMoney;
- (void)showModalPanel;


@end

@implementation RequestMoneyController

@synthesize recipientUri;
@synthesize txtAmount, txtComments, btnSendRequest;
@synthesize viewPanel;
@synthesize recipientImageButton;
@synthesize chooseRecipientButton;
@synthesize contactHead;
@synthesize contactDetail, lm;
@synthesize amount, chooseAmountButton;


float tableHeight = 30;

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
    [requestMoneyService release];
    [lm release];
    
    /*  ------------------------------------------------------ */
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
    
    [btnSendRequest release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
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
    //[whiteBoxView.layer  setCornerRadius:7.0];
    
    
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
    [recipientImageButton.layer setCornerRadius:5.0];
    [recipientImageButton.layer setMasksToBounds:YES];
    [recipientImageButton.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [recipientImageButton.layer setBorderWidth:0.7]; // 28 24 20
    
    
    
    /*          Services/ViewController Initialization         */
    /*  ------------------------------------------------------ */
    requestMoneyService = [[RequestMoneyService alloc] init];
    [requestMoneyService setRequestMoneyCompleteDelegate: self];
     

    /*                TextField Initialization                 */
    /*  ------------------------------------------------------ */
    autoCompleteArray = [[NSMutableArray alloc] init];
    recipientUri = [[NSString alloc] initWithString: @""];
    amount = [[NSString alloc] initWithString: @""];
    
    
    comments = [[NSString alloc] initWithString: @""];
    
    [self setTitle:@"Request $"];
    
    [txtAmount setDelegate:self];
    txtAmount.text = @"$0.00";
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";

}


- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation != nil) {
        latitude = newLocation.coordinate.latitude;
        longitude = newLocation.coordinate.longitude;
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}


- (void)viewDidUnload
{
    [lm stopUpdatingLocation];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

-(IBAction) bgTouched:(id) sender {
    [txtAmount resignFirstResponder];
    [txtComments resignFirstResponder];
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

        //[txtRecipientUri setText: @""];
        [txtAmount setText: @"$0.00"];
        [txtComments setText: @""];
        
        [[self scrollView] setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        [self showAlertView:@"Request Sent!" withMessage: message];

    }
    else {
        [self showAlertView: @"Sorry.  Try Again.!" withMessage:message];
    }
}
-(void) sendMoneyFailed:(ASIHTTPRequest *)request
{
    // statsCommuniqueDoneProblem ... !
    NSLog(@"Request Money Failed");
}


-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest {
    if([recipientUriToTest length]  == 0)
        return false;
    
    return true;
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

- (void)requestMoney {
     
    amount = [[NSString alloc] initWithString: @""];
    comments = [[NSString alloc] initWithString: @""];

    if([txtAmount.text length] > 0) {
        amount = [[txtAmount.text stringByReplacingOccurrencesOfString:@"$" withString:@""] copy];
    }

    if([txtComments.text length] > 0)
        comments = [txtComments.text copy];

    BOOL isValid = YES;

    if(isValid && ![self isValidRecipientUri: recipientUri])
    {
        [self showAlertView:@"Invalid Recipient!" withMessage: @"You specified an invalid recipient.  Please try again."];

        isValid = NO;
    }
    if(isValid && ![self isValidAmount:amount])
    {
        [self showAlertView:@"Invalid Amount" withMessage:@"You specified an invalid amount to send.  Please try again."];

        isValid = NO;
    }

    if(isValid)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString* userId = [prefs stringForKey:@"userId"];

        if([userId length] > 0)
            [self showModalPanel];
        else
        {
            SignInViewController *signInViewController;
            signInViewController = [[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil] autorelease];
            [signInViewController setSignInCompleteDelegate: self];
            [signInViewController setAchSetupCompleteDelegate:self];

            [self.navigationController pushViewController:signInViewController animated:YES];
        }
    }
}

-(IBAction) btnSendRequestClicked:(id)sender {

    [self requestMoney];

}
- (IBAction)showModalPanel {

    [txtAmount resignFirstResponder];
    [txtComments resignFirstResponder];

	securityPinModalPanel = [[[ConfirmPaymentDialogController alloc] initWithFrame:self.view.bounds] autorelease];

    securityPinModalPanel.dialogTitle.text = @"Swipe Your Pin";
    securityPinModalPanel.dialogHeading.text = [NSString stringWithFormat: @"To send your request for %@ to %@, swipe your security pin below.", txtAmount.text, @"Recipient"];
    [securityPinModalPanel.btnCancelPayment setTitle:@"Cancel Request" forState:UIControlStateNormal];
    securityPinModalPanel.delegate = self;


	///////////////////////////////////
	// Add the panel to our view
	[self.view addSubview:securityPinModalPanel];

	///////////////////////////////////
	// Show the panel from the center of the button that was pressed
	[securityPinModalPanel show];
}
-(void) securityPinComplete:(SetupSecurityPin *) modalPanel
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

    [requestMoneyService requestMoney:amount toRecipient:recipientUri fromSender:senderUri withComment:comments withSecurityPin:code fromUserId:userId withFromAccount:fromAccount  withFromLatitude: latitude withFromLongitude: longitude withRecipientFirstName: recipientFirstName withRecipientLastName: recipientLastName withRecipientImageUri: recipientImageUri];
}
-(void)requestMoneyDidComplete {

    [self.scrollView scrollsToTop];
    [securityPinModalPanel hide];
    
    recipientUri = @"";
    [txtAmount setText: @"$0.00"];
    [txtComments setText: @""];
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    [recipientImageButton setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
    
    NSString* message = [NSString stringWithString:@"Your request was sent"];
    
    [[self scrollView] setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self showAlertView:@"Request Sent!" withMessage: message];
}
-(void)requestMoneyDidFail: (NSString*) message {
    [self showAlertView: @"Error Requesting Money" withMessage:message];
}

-(void)didChooseContact:(Contact *)contact
{
    recipient = contact;
    if ( contact.imgData )
        [recipientImageButton setBackgroundImage:contact.imgData forState:UIControlStateNormal];
    else if ( contact.facebookID.length > 0 )
        [recipientImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", contact.facebookID]]]] forState:UIControlStateNormal];
    else
        [recipientImageButton setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
    
    
    recipientImageButton.imageView.image = nil;
    // Image Formatting
    [recipientImageButton.layer setCornerRadius:12.0];
    [recipientImageButton.layer setMasksToBounds:YES];
    
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


-(void)didSelectAmount:(double)amountSent
{
    txtAmount.text = [[NSString stringWithFormat:@"%f",amountSent] copy];
}


@end
