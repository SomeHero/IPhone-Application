//
//  UISendMoneyBaseViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UISendMoneyBaseViewController.h"

@interface UISendMoneyBaseViewController ()

@end

@implementation UISendMoneyBaseViewController

@synthesize amount;
@synthesize recipientUri;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    //e.g. self.myOutlet = nil;

    [lm stopUpdatingLocation];
    [recipientImageButton release];
    recipientImageButton = nil;
    [chooseRecipientButton release];
    chooseRecipientButton = nil;
    [contactHead release];
    contactHead = nil;
    [contactDetail release];
    contactDetail = nil;
    //[whiteBoxView release];
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
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [self.mainScrollView scrollsToTop];
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    TransactionConfirmationViewController*  controller = [[[TransactionConfirmationViewController alloc] init] retain];
    controller.confirmationText = [NSString stringWithFormat: @"Success! Your payment of $%0.2f was sent to %@.", [amount doubleValue], recipientUri];
    [controller setTransactionConfirmationDelegate: self];
    
    [self dismissModalViewControllerAnimated:YES];
    [self presentModalViewController:controller animated:YES];
}

-(void)sendMoneyDidFail:(NSString*) message isLockedOut :(BOOL)lockedOut withPinCodeFailures : (NSInteger) pinCodeFailures {
    
    if(lockedOut) {
        [self dismissModalViewControllerAnimated: YES];
        
        [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) signOut];
        
        [self showAlertView: @"Invalid Security Pin" withMessage:@"Your security pin was incorrect, login to continue"];
    }
    else {
        [self showAlertView: @"Error Sending Money" withMessage: message];
    }
}

@end
