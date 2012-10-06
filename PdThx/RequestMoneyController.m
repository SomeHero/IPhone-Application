//
//  RequestMoneyController.m
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PdThxAppDelegate.h"
#import "HomeViewController.h"
#import "HomeViewControllerV2.h"

#import "PayStreamViewController.h"
#import "SendMoneyController.h"
#import "RequestMoneyController.h"
#import "DoGoodViewController.h"
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
#import "SelectRecipientViewController.h"

// Custom Keyboard Handling
#import "DAKeyboardControl.h"

#define kOFFSET_FOR_KEYBOARD 100.0
#define tableHeight = 30;

@interface RequestMoneyController ()
- (BOOL)isValidRecipientUri:(NSString *)recipientUriToTest;
- (BOOL)isValidAmount:(NSString *)amountToTest;


@end

@implementation RequestMoneyController
@synthesize dummyCommentPlaceholder;
@synthesize tabBar;

@synthesize recipientUri, attachPictureButton;
@synthesize txtAmount, txtComments, btnSendRequest;
@synthesize viewPanel;
@synthesize recipientImageButton;
@synthesize chooseRecipientButton;
@synthesize contactHead;
@synthesize contactDetail, lm;
@synthesize amount, chooseAmountButton, characterCountLabel;
@synthesize contactButtonBGImage, amountButtonBGImage;


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
    [super dealloc];
    [tabBar release];
    /*  ------------------------------------------------------ */
    /*                View/Services Releases                   */
    /*  ------------------------------------------------------ */
    [viewPanel release];
    [requestMoneyService release];
    [lm release];
    
    /*  ------------------------------------------------------ */
    /*                Image/TextField Releases                 */
    /*  ------------------------------------------------------ */
    [recipient release];
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
    [dummyCommentPlaceholder release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    if ( txtComments.text.length == 0 )
        dummyCommentPlaceholder.placeholder = @"For what? Add a message...";
    else {
        dummyCommentPlaceholder.placeholder = @"";
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    tabBar = [[HBTabBarManager alloc]initWithViewController:self topView:self.view delegate:self selectedIndex:3];
    
    /*                  View Setup              */
    /*  --------------------------------------- */
    mainScrollView.frame = CGRectMake(0, 0, 320, 420);
    [mainScrollView setContentSize:CGSizeMake(320, 420)];
    //[whiteBoxView.layer  setCornerRadius:7.0];
    
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:0.0]; // Old Width 1.0
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
    
    
    self.view.keyboardTriggerOffset = 0.0;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
    }];
}

-(void)changedCommentBox:(NSNotification*)notification
{
    if ( [txtComments.text length] > 0 )
    {
        dummyCommentPlaceholder.placeholder = @"";
    } else {
        dummyCommentPlaceholder.placeholder = @"For what? Add a message...";
    }
    
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
    tabBar = nil;
    [lm stopUpdatingLocation];
    [attachPictureButton release];
    attachPictureButton = nil;
    [characterCountLabel release];
    characterCountLabel = nil;
    [characterCountLabel release];
    characterCountLabel = nil;
    [recipient release];
    recipient = nil;
    [self setDummyCommentPlaceholder:nil];
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
    [newView setTitle: @"Request Money"];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.contactSelectChosenDelegate = self;
}

- (IBAction)pressedAmountButton:(id)sender 
{
    AmountSelectViewController *newView = [[AmountSelectViewController alloc] initWithNibName:@"AmountSelectViewController" bundle:nil];
    [newView setTitle:@"Request Amount"];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.amountChosenDelegate = self;
    
    
}

- (IBAction)pressedAttachPictureButton:(id)sender {
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
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
    
    if ( error ){
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
        // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
        // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
        // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
        
        [appDelegate showSimpleAlertView:false withTitle:@"Attachment Failed" withSubtitle:@"Error saving photo." withDetailedText:@"There was an error saving the photo to your album. Please try again." withButtonText:@"Ok" withDelegate:self];
    } else {
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
        // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
        // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
        // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
        [appDelegate showSimpleAlertView:false withTitle:@"Attachment Added" withSubtitle:@"Photo saved to album." withDetailedText:@"Adding photo to payment request. Please note, this will increase the amount of time it takes to process your request." withButtonText:@"Continue" withDelegate:self];
    }
}

-(void)didSelectButtonWithIndex:(int)index
{
    if ( index == 0 ) {
        // Dismiss, error uploading image alert view clicked.
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
    } else {
        // Successfully saved image, just go back to personalize screen and load the image.
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        // TODO: Add protocol to return the image and attach to transaction
    }
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
        recipient = nil;
        [[self mainScrollView] setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        [self showAlertView:@"Request Sent!" withMessage: message];
        
        
    }
    else {
        [self showAlertView: @"Sorry.  Try Again.!" withMessage:message];
    }
}
-(void) sendMoneyFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Money Failed");
}

-(void) determineRecipientDidComplete: (NSArray*) recipients
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    SelectRecipientViewController* controller= [[SelectRecipientViewController alloc] init];
    [controller setSelectRecipientDelegate:self];
    
    if (recipients == nil)
    {
        controller.noMatchFound = YES;
        controller.recipients = recipient.paypoints;
        controller.headerText = [NSString stringWithFormat:@"%@ hasn't joined PaidThx yet. How would you like to invite them?", recipient.name];
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
        [self presentModalViewController:navBar animated:YES];
    }
    else {
        if ([recipients count] != 1)
        {           
            controller.noMatchFound = NO;
            controller.headerText = @"We found multiple PaidThx members associated with the contact you selected. Please choose your recipient below:";
            controller.recipients = recipients;            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
            [self presentModalViewController: navBar animated:YES];
        }
        else
        {
            NSDictionary* uriInfo = (NSDictionary*) [recipients objectAtIndex:0];
            [self setRecipientUri: [NSString stringWithFormat:@"%@", [uriInfo valueForKey:@"userUri"]]];
            [self startSecurityPin];
        }
        
    }
}

-(void) determineRecipientDidFail: (NSString*) message withErrorCode:(int)errorCode
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Finding matching recipient uris failed. Please pick one." withDetailedStatus:message];
}

-(void) selectRecipient:(NSString *)uri;
{
    [self setRecipientUri:uri];
    
    [self dismissModalViewControllerAnimated:NO];
    
    [self startSecurityPin];
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
    
    [txtComments resignFirstResponder];
    
    if([txtAmount.text length] > 0) {
        amount = [[txtAmount.text stringByReplacingOccurrencesOfString:@"$" withString:@""] copy];
    }
    
    if([txtComments.text length] > 0)
        comments = [txtComments.text copy];
    
    BOOL isValid = YES;
    
    if(isValid && [recipient.paypoints count] == 0)
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
            if ([recipient.paypoints count] == 1)
            {
                
                [self startSecurityPin];
            }
            else {
                
                PdThxAppDelegate *appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate showWithStatus:@"Please wait" withDetailedStatus:@"Finding Recipient"];
                [requestMoneyService setDetermineRecipientCompleteDelegate:self];
                [requestMoneyService determineRecipient:recipient.paypoints];
            }
        } else {
            AddACHOptionsViewController* controller= [[AddACHOptionsViewController alloc] init];
            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
            
            [controller setAchSetupComplete:self];
            
            [self presentModalViewController: navBar animated:YES];
        }
    }
    
}

-(void) startSecurityPin
{
    /*
     Custom Security Pin Swipe Controller Example
     -==============================================-
     
     recipientName = @"Ryan Ricigliano";
     deliveryCharge = 0.0;
     amount = 14.59;
     deliveryType = @"Express";
     lblHeader.text = @"SWIPE YOUR SECURITY PIN TO CONFIRM";
     */
    
    CustomSecurityPinSwipeController *controller=[[[CustomSecurityPinSwipeController alloc] init] autorelease];
    [controller setSecurityPinSwipeDelegate: self];
    [controller setNavigationTitle: @"Confirm"];
    [controller setHeaderText:@"SWIPE YOUR PIN TO SEND REQUEST"];
    
    [controller setDeliveryType:@"Standard"];
    [controller setDeliveryCharge:0.0];
    
    [controller setAmount:[amount doubleValue]];
    
    [controller setRecipientName:[recipient getSenderName]];
    
    [self presentModalViewController:controller animated:YES];   
}

-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{

    NSString* recipientImageUri = @"";
    NSString* recipientFirstName = @"";
    NSString* recipientLastName = @"";
    
    if([[recipientUri substringToIndex:3] isEqualToString:@"fb_"]) {
        recipientImageUri = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", recipient.facebookID];
        recipientFirstName = [NSString stringWithFormat: @"%@", recipient.firstName];
        recipientLastName = [NSString stringWithFormat: @"%@", recipient.lastName];
    }
    
    
    [requestMoneyService requestMoney:amount toRecipient:recipientUri fromSender:user.userUri withComment:comments withSecurityPin:pin fromUserId:user.userId withFromAccount:user.preferredReceiveAccountId withFromLatitude: latitude withFromLongitude: longitude withRecipientFirstName: recipientFirstName withRecipientLastName: recipientLastName withRecipientImageUri: recipientImageUri];
    
}
-(void)swipeDidCancel: (id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)requestMoneyDidComplete {
    recipient = nil;
    
    [self.mainScrollView scrollsToTop];
    
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    TransactionConfirmationViewController*  controller = [[TransactionConfirmationViewController alloc] init];
    
    if ( [[recipientUri substringToIndex:3] isEqualToString:@"fb_"] )
    {
        controller.confirmationText = [NSString stringWithFormat: @"Success! Your request for $%0.2f was sent to %@.", [amount doubleValue], recipient.name];
    }
    else
    {
        if ( [[recipient.paypoints objectAtIndex:0] isEqualToString:recipient.name] )
        {
            controller.confirmationText = [NSString stringWithFormat: @"Success! Your request of $%0.2f was sent to %@.", [amount doubleValue], recipientUri];
        }
        else {
            controller.confirmationText = [NSString stringWithFormat: @"Success! Your request of $%0.2f was sent to %@.", [amount doubleValue], recipient.name];
        }
    }
    
    
    [controller setContinueButtonText:@"Send Another Request"];
    [controller setTransactionConfirmationDelegate: self];
    [controller setTitle:@"Request Sent"];
    
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:controller animated:YES];
    recipientUri = @"";
}

-(void)requestMoneyDidFail:(NSString*) message withErrorCode:(int)errorCode {
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate handleError:message withErrorCode:errorCode withDefaultTitle: @"Unable Sending Request"];
}
-(void)onHomeClicked {
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    txtAmount.text = @"0.00";
    
    [recipientImageButton setBackgroundImage: NULL forState:UIControlStateNormal];
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    txtComments.text = @"";
    
    [self tabBarClicked:1];
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
    } else if ( [contact.paypoints count] == 1 ){
        contactDetail.text = [contact.paypoints objectAtIndex:0];
    } else if ([contact.paypoints count]) {
        contactDetail.text = [NSString stringWithFormat:@"%d paypoints", [contact.paypoints count]];
    } else {
        contactDetail.text = @"No Info to Display";
    }
    
    if ([contact.paypoints count] == 1)
    {
        recipientUri = [contact.paypoints objectAtIndex:0];
    }
    
}

-(void)didSelectAmount:(double)amountSent withDeliveryOption:(bool)isExpressed
{
    amountButtonBGImage.highlighted = YES;
    txtAmount.text = [NSString stringWithFormat: @"%.2lf", amountSent];
}




- (void)tabBarClicked:(NSUInteger)buttonIndex
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //NSLog(@"Switching to tab index:%d",buttonIndex);
    UIViewController* newView = [appDelegate switchMainAreaToTabIndex:buttonIndex fromViewController:self];
    
    //NSLog(@"NewView: %@",newView);
    if ( newView != nil  && ! [self isEqual:newView])
    {
        //NSLog(@"Switching views, validated that %@ =/= %@",[self class],[newView class]);
        
        [[self navigationController] pushViewController:newView animated:NO];
        
        // Get the list of view controllers
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
}


-(void)achSetupDidComplete {
    [self.navigationController dismissModalViewControllerAnimated:NO];
    
    [self startSecurityPin];
}
-(void)userACHSetupDidFail:(NSString*) message withErrorCode:(int)errorCode {
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Sending Money"];
}

@end
