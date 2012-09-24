//
//  RequestMoneyController.m
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PdThxAppDelegate.h"
#import "AcceptPledgeViewController.h"
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
#import "HomeViewControllerV2.h"

#define kOFFSET_FOR_KEYBOARD 100.0
#define tableHeight = 30;

@interface AcceptPledgeViewController ()
- (BOOL)isValidRecipientUri:(NSString *)recipientUriToTest;
- (BOOL)isValidAmount:(NSString *)amountToTest;


@end

@implementation AcceptPledgeViewController
@synthesize dummyPlaceholder;

@synthesize recipientUri, attachPictureButton;
@synthesize txtAmount, txtComments, btnSendRequest;
@synthesize viewPanel;
@synthesize recipientImageButton;
@synthesize chooseRecipientButton;
@synthesize contactHead;
@synthesize contactDetail, lm;
@synthesize amount, chooseAmountButton, characterCountLabel;
@synthesize contactButtonBGImage, amountButtonBGImage;
@synthesize chooseCauseButton;
@synthesize causeId;

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
    [dummyPlaceholder release];
    [dummyPlaceholder release];
    [contactImage release];
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
    chooseCauseButton.backgroundColor = [UIColor clearColor];
    chooseCauseButton.backgroundColor = [UIColor clearColor];
    [contactImage.layer setCornerRadius:5.0];
    [contactImage.layer setMasksToBounds:YES];
    [contactImage.layer setBorderWidth:0.2];
    [contactImage.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    chooseRecipientButton.backgroundColor = [UIColor clearColor];
    chooseAmountButton.backgroundColor = [UIColor clearColor];
    [recipientImageButton.layer setCornerRadius:5.0];
    [recipientImageButton.layer setMasksToBounds:YES];
    
    [recipientImageButton.layer setBorderWidth:0.2];
    [recipientImageButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    /*          Services/ViewController Initialization         */
    /*  ------------------------------------------------------ */
    requestMoneyService = [[RequestMoneyService alloc] init];
    [requestMoneyService setRequestMoneyCompleteDelegate: self];
    
    paystreamService = [[PaystreamService alloc] init];
    [paystreamService setSendMoneyCompleteDelegate: self];
    
    /*                TextField Initialization                 */
    /*  ------------------------------------------------------ */
    autoCompleteArray = [[NSMutableArray alloc] init];
    recipientUri = [[NSString alloc] initWithString: @""];
    amount = [[NSString alloc] initWithString: @""];
    
    txtComments.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedCommentBox:) name:@"UITextViewTextDidChangeNotification" object:nil];
    
    
    comments = [[NSString alloc] initWithString: @""];
    
    [self setTitle:@"Accept Pledge"];
    
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
    if ( [txtComments.text length] > 0 ) {
        dummyPlaceholder.placeholder = @"";
    } else {
        dummyPlaceholder.placeholder = @"Add a message...";
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
    [lm stopUpdatingLocation];
    [attachPictureButton release];
    attachPictureButton = nil;
    [characterCountLabel release];
    characterCountLabel = nil;
    [characterCountLabel release];
    characterCountLabel = nil;
    [dummyPlaceholder release];
    dummyPlaceholder = nil;
    [self setDummyPlaceholder:nil];
    [contactImage release];
    contactImage = nil;
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
-(IBAction)pressedChooseCauseButton:(id)sender 
{
    DonationContactSelectViewController *newView = [[DonationContactSelectViewController alloc] initWithNibName:@"DonationContactSelectViewController" bundle:nil];
    [newView setTitle: @"Select Cause"];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.causeSelectDidComplete = self; 
}
- (IBAction)pressedChooseRecipientButton:(id)sender 
{
    ContactSelectViewController *newView = [[ContactSelectViewController alloc] initWithNibName:@"ContactSelectViewController" bundle:nil];
    [newView setTitle: @"Select Donor"];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.contactSelectChosenDelegate = self;
}

- (IBAction)pressedAmountButton:(id)sender 
{
    AmountSelectViewController *newView = [[AmountSelectViewController alloc] initWithNibName:@"AmountSelectViewController" bundle:nil];
    [newView setTitle:@"Pledge Amount"];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.amountChosenDelegate = self;
    
}

- (IBAction)pressedAttachPictureButton:(id)sender {
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [imagePicker setAllowsEditing:NO];
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
        [appDelegate showAlertWithResult:false withTitle:@"Image Save Error" withSubtitle:@"Error saving your image to your phone" withDetailText:@"Your phone was unable to save the image you stored. Please make sure you have sufficient available memory to save the photo, and try again." withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Not shown" withRightButtonTitleColor:[UIColor clearColor] withTextFieldPlaceholderText: @"" withDelegate:self];
    } else {
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
        // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
        // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
        // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
        [appDelegate showAlertWithResult:true withTitle:@"Image Saved!" withSubtitle:@"Your image has been saved" withDetailText:@"Your image was saved, but make sure to save your changes on the next screen!" withLeftButtonOption:0 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:1 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Ok" withRightButtonTitleColor:[UIColor darkGrayColor]   withTextFieldPlaceholderText: @"" withDelegate:self];
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
        
        // TODO: There needs to be a protocol here to load the image as being on top.
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
    [txtComments resignFirstResponder];
    
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
            [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm the pledge of $%0.2f from %@.", [amount doubleValue], recipientUri]];
            
            [self presentModalViewController:controller animated:YES];
        } else {
            AddACHAccountViewController* controller= [[AddACHAccountViewController alloc] init];
            controller.newUserFlow = false;
            
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
    
    [paystreamService acceptPledge:user.userId onBehalfOfId:causeId toRecipientUri:recipientUri withAmount:amount withComments:comments fromLatitude:latitude fromLongitude:longitude withRecipientFirstName: recipientFirstName withRecipientLastName:recipientLastName withRecipientImageUri:recipientImageUri withSecurityPin:pin];
    
}

-(void)swipeDidCancel: (id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)sendMoneyDidComplete {
    
    [self.mainScrollView scrollsToTop];
    
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    TransactionConfirmationViewController*  controller = [[TransactionConfirmationViewController alloc] init];
    controller.confirmationText = [NSString stringWithFormat: @"Success! Your request for $%0.2f was sent to %@.", [amount doubleValue], recipientUri];
    [controller setTransactionConfirmationDelegate: self];
    [controller setContinueButtonText: @"Accept Another Pledge"];
    
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:controller animated:YES];
    
    //[controller release];
}

-(void)sendMoneyDidFail:(NSString*) message isLockedOut :(BOOL)lockedOut withPinCodeFailures : (NSInteger) pinCodeFailures {
    
    if(lockedOut) {
        [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) signOut];
        
        [self showAlertView: @"Invalid Security Pin" withMessage:@"Your security pin was incorrect, login to continue"];
    }
    else {
        [self showAlertView: @"Error Sending Request" withMessage: message];
    }
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
-(void)didChooseCause:(Contact*)contact
{
    causeButtonBGImage.highlighted = YES;
    cause = contact;
    if ( contact.imgData )
        [causeImageButton setBackgroundImage:contact.imgData forState:UIControlStateNormal];
    else if ( contact.facebookID.length > 0 )
        [causeImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", contact.facebookID]]]] forState:UIControlStateNormal];
    else
        [causeImageButton setBackgroundImage: NULL forState:UIControlStateNormal];
    
    
    causeImageButton.imageView.image = nil;
    
    causeHeader.text = contact.name;
    
    if ( contact.facebookID.length > 0 ){
        causeDetail.text = @"Facebook Friend";
    } else if ( [contact.paypoints count] == 1 ){
        causeDetail.text = [contact.paypoints objectAtIndex:0];
    }else {
        causeDetail.text = @"No Info to Display";
    }
    
    self.causeId = contact.recipientId;
    
}
-(void)didChooseContact:(Contact *)contact
{
    contactButtonBGImage.highlighted = YES;
    recipient = contact;
    if ( contact.imgData )
        [contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
    else if ( contact.facebookID.length > 0 )
        [contactImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", contact.facebookID]]]] forState:UIControlStateNormal];
    else
        [recipientImageButton setBackgroundImage: NULL forState:UIControlStateNormal];
    
    
    recipientImageButton.imageView.image = nil;
    
    contactHead.text = contact.name;
    
    if ( contact.facebookID.length > 0 ){
        contactDetail.text = @"Facebook Friend";
    } else if ( [contact.paypoints count] == 1 ){
        contactDetail.text = [contact.paypoints objectAtIndex:0];
    }else {
        contactDetail.text = @"No Info to Display";
    }
    
    self.recipientUri = [contact.paypoints objectAtIndex:0];
    
}

-(void)didSelectAmount:(double)amountSent
{
    amountButtonBGImage.highlighted = YES;
    txtAmount.text = [NSString stringWithFormat: @"%.2lf", amountSent];
}
- (void)tabBarClicked:(NSUInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        //Switch to the groups tab
        HomeViewControllerV2 *gvc = [[HomeViewControllerV2 alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 1 )
    {
        //Switch to the groups tab
        PayStreamViewController *gvc = [[PayStreamViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 2 )
    {
        //Switch to the groups tab
        SendMoneyController *gvc = [[SendMoneyController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 3 )
    {
        // Already the current view controller
        /*
         //Switch to the groups tab
         HomeViewController *gvc = [[HomeViewController alloc]init];
         [[self navigationController] pushViewController:gvc animated:NO];
         [gvc release];
         
         //Remove the view controller this is coming from, from the navigation controller stack
         NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
         [allViewControllers removeObjectIdenticalTo:self];
         [[self navigationController] setViewControllers:allViewControllers animated:NO];
         [allViewControllers release];
         */
    }
    if( buttonIndex == 4 )
    {
        //Switch to the groups tab
        DoGoodViewController *gvc = [[DoGoodViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
}


@end