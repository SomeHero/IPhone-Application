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
#import "RequestMoneyService.h"
#import "ContactSelectViewController.h"
#import "AmountSelectViewController.h"
#import "CustomSecurityPinSwipeController.h"

#define kOFFSET_FOR_KEYBOARD 100.0

@interface RequestMoneyController ()
- (BOOL)isValidRecipientUri:(NSString *)recipientUriToTest;
- (BOOL)isValidAmount:(NSString *)amountToTest;


@end

@implementation RequestMoneyController

@synthesize recipientUri, attachPictureButton;
@synthesize txtAmount, txtComments, btnSendRequest;
@synthesize viewPanel;
@synthesize recipientImageButton;
@synthesize chooseRecipientButton;
@synthesize contactHead;
@synthesize contactDetail, lm;
@synthesize amount, chooseAmountButton, characterCountLabel;
@synthesize contactButtonBGImage, amountButtonBGImage;

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
    [user release];
    [amount release];
    [comments release];
    [recipientImageButton release];
    [chooseRecipientButton release];
    [contactHead release];
    [contactDetail release];
    [chooseAmountButton release];
    
    [btnSendRequest release];

    [attachPictureButton release];
    [characterCountLabel release];
    [characterCountLabel release];
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

    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;

}
- (void)viewDidLoad
{

    [super viewDidLoad];
    
    /*                  View Setup              */
    /*  --------------------------------------- */
    mainScrollView.frame = CGRectMake(0, 0, 320, 420);
    [mainScrollView setContentSize:CGSizeMake(320, 420)];
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
    
    txtComments.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedCommentBox:) name:@"UITextViewTextDidChangeNotification" object:nil];
    
    
    comments = [[NSString alloc] initWithString: @""];
    
    [self setTitle:@"Request $"];
    
    [txtAmount setDelegate:self];
    txtAmount.text = @"0.00";
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"RequestMoneyController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    attachPictureButton.hidden = YES;
    /*          Image Attachment Handling           */
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
        attachPictureButton.hidden = NO;
}


-(void)changedCommentBox:(NSNotification*)notification
{
    if ( [txtComments.text length] <= 140 ){
        characterCountLabel.placeholder = [NSString stringWithFormat:@"%d/140",[txtComments.text length]];
    } else {
        txtComments.text = [txtComments.text substringToIndex:140];
        characterCountLabel.placeholder = @"140/140";
    }
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
    [attachPictureButton release];
    attachPictureButton = nil;
    [characterCountLabel release];
    characterCountLabel = nil;
    [characterCountLabel release];
    characterCountLabel = nil;
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

- (IBAction)pressedAttachPictureButton:(id)sender {
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsImageEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [picker release];
}

-(void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    [self dismissModalViewControllerAnimated:YES];
    
    UIAlertView *alert;
    if ( error )
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to use the image taken" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your image was attached to the request." delegate:self cancelButtonTitle:@"YAY!" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
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

        [self.mainScrollView scrollsToTop];

        //[txtRecipientUri setText: @""];
        [txtAmount setText: @"0.00"];
        [txtComments setText: @""];
        
        [[self mainScrollView] setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
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

-(IBAction) btnSendRequestClicked:(id)sender {

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
            
            if([user.preferredPaymentAccountId length] > 0)
            {
                CustomSecurityPinSwipeController *controller=[[[CustomSecurityPinSwipeController alloc] init] autorelease];
                [controller setSecurityPinSwipeDelegate: self];
                [controller setNavigationTitle: @"Confirm"];
                [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your request of $%0.2f from %@.", [amount doubleValue], recipientUri]];
                
                [self presentModalViewController:controller animated:YES];
            } else {
                AddACHAccountViewController* controller= [[AddACHAccountViewController alloc] init];
                UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
                
                [controller setNavBarTitle: @"Enable Payment"];
                [controller setHeaderText: @"To complete requesting money, complete your account by adding a bank account"];
                
                [self presentModalViewController: navBar animated:YES];
            }
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
    
    
    [requestMoneyService requestMoney:amount toRecipient:recipientUri fromSender:user.userUri withComment:comments withSecurityPin:pin fromUserId:user.userId withFromAccount:user.preferredReceiveAccountId withFromLatitude: latitude withFromLongitude: longitude withRecipientFirstName: recipientFirstName withRecipientLastName: recipientLastName withRecipientImageUri: recipientImageUri];

}
-(void)swipeDidCancel: (id)sender
{
    //do nothing
}
-(void)requestMoneyDidComplete {

    [self.mainScrollView scrollsToTop];
    
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    TransactionConfirmationViewController*  controller = [[[TransactionConfirmationViewController alloc] init] retain];
    controller.confirmationText = [NSString stringWithFormat: @"Success! Your request for $%0.2f was sent to %@.", [amount doubleValue], recipientUri];
    [controller setTransactionConfirmationDelegate: self];
    
    [self presentModalViewController:controller animated:YES];
}

-(void)sendMoneyDidFail:(NSString*) message {
    
    [self showAlertView: @"Error Sending Money" withMessage: message];
}
-(void)onHomeClicked {
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    txtAmount.text = @"0.00";
    
    [recipientImageButton setBackgroundImage: NULL forState:UIControlStateNormal];

    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    txtComments.text = @"";
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) switchToPaystreamController];
}
-(void)onContinueClicked {
    
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    txtAmount.text = @"0.00";
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    txtComments.text = @"";
    
    [recipientImageButton setBackgroundImage: NULL forState:UIControlStateNormal];
}
-(void)requestMoneyDidFail: (NSString*) message {
    [self showAlertView: @"Error Requesting Money" withMessage:message];
}

-(void)didChooseContact:(Contact *)contact
{
    contactButtonBGImage.highlighted = YES;
    recipient = contact;
    if ( contact.imgData )
        [recipientImageButton setBackgroundImage:contact.imgData forState:UIControlStateNormal];
    else if ( contact.facebookID.length > 0 )
        [recipientImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", contact.facebookID]]]] forState:UIControlStateNormal];
    else
        [recipientImageButton setBackgroundImage: NULL forState:UIControlStateNormal];
    
    
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

-(void)didSelectAmount:(double)amountSent
{
    amountButtonBGImage.highlighted = YES;
    txtAmount.text = [NSString stringWithFormat: @"%.2lf", amountSent];
}


@end
