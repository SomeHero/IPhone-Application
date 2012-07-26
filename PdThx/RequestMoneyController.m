//
//  RequestMoneyController.m
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PdThxAppDelegate.h"
#import "HomeViewController.h"
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
    
    if ( txtComments.text.length == 0 )
        dummyCommentPlaceholder.placeholder = @"Enter a comment or message.";
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
    if ( [txtComments.text length] > 0 ) {
        dummyCommentPlaceholder.placeholder = @"";
    } else {
        dummyCommentPlaceholder.placeholder = @"Enter a comment or message.";
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
        [appDelegate showAlertWithResult:false withTitle:@"Image Save Error" withSubtitle:@"Error saving your image to your phone" withDetailText:@"Your phone was unable to save the image you stored. Please make sure you have sufficient available memory to save the photo, and try again." withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Not shown" withRightButtonTitleColor:[UIColor clearColor] withDelegate:self];
    } else {
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
        // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
        // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
        // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
        [appDelegate showAlertWithResult:true withTitle:@"Image Saved!" withSubtitle:@"Your image has been saved" withDetailText:@"Your image was saved, but make sure to save your changes on the next screen!" withLeftButtonOption:0 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:1 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Ok" withRightButtonTitleColor:[UIColor darkGrayColor] withDelegate:self];
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
    // statsCommuniqueDoneProblem ... !
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
        controller.recipientUris = recipient.paypoints;
        controller.recipientUriOutputs = recipient.paypoints;
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
        [self presentModalViewController:navBar animated:YES];
    }
    else {
        if ([recipients count] != 1)
        {
            NSMutableArray* recipientUris = [[NSMutableArray alloc] init];
            NSMutableArray* recipientStrings = [[NSMutableArray alloc] init];
            
            for (NSUInteger i = 0; i < [recipients count]; i++)
            {
                NSDictionary* uriInfo = (NSDictionary*)[recipients objectAtIndex:i];
                [recipientUris addObject: [NSString stringWithFormat:@"%@", [uriInfo objectForKey:@"userUri"]]];
                [recipientStrings addObject: [NSString stringWithFormat:@"%@: %@ %@", [uriInfo objectForKey:@"userUri"], [uriInfo objectForKey:@"firstName"], [uriInfo objectForKey:@"lastName"]]];
            }
            
            controller.recipientUris = recipientUris;
            controller.recipientUriOutputs = recipientStrings;
            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
            [self presentModalViewController: navBar animated:YES];
        }
        else
        {
            NSDictionary* uriInfo = (NSDictionary*) [recipients objectAtIndex:0];
            [self setRecipientUri: [NSString stringWithFormat:@"%@", [uriInfo valueForKey:@"userUri"]]];
            CustomSecurityPinSwipeController *controller=[[[CustomSecurityPinSwipeController alloc] init] autorelease];
            [controller setSecurityPinSwipeDelegate: self];
            [controller setNavigationTitle: @"Confirm"];
            [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your payment of $%0.2f to %@.", [amount doubleValue], recipientUri]];
            
            [self presentModalViewController:controller animated:YES];            
        }
        
    }
}

-(void) determineRecipientDidFail: (NSString*) message
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Finding matching recipient uris failed. Please pick one." withDetailedStatus:message];
}

-(void) selectRecipient:(NSString *)uri;
{
    recipientUri = uri;
    
    [self dismissModalViewControllerAnimated:NO];
    
    CustomSecurityPinSwipeController *controller=[[[CustomSecurityPinSwipeController alloc] init] autorelease];
    [controller setSecurityPinSwipeDelegate: self];
    [controller setNavigationTitle: @"Confirm"];
    
    if ( [[recipientUri substringToIndex:3] isEqualToString:@"fb_"] )
        [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your payment of $%0.2f to %@.", [amount doubleValue], recipient.name]];
    else
        [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your payment of $%0.2f to %@.", [amount doubleValue], recipientUri]];
    
    [self presentModalViewController:controller animated:YES];
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
    
    if(isValid && ([recipient.paypoints count] == 0 && recipient.paypoint == nil))
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
                recipientUri = [recipient.paypoints objectAtIndex:0];
                
                CustomSecurityPinSwipeController *controller=[[[CustomSecurityPinSwipeController alloc] init] autorelease];
                [controller setSecurityPinSwipeDelegate: self];
                [controller setNavigationTitle: @"Confirm"];
                
                if ( [[recipientUri substringToIndex:3] isEqualToString:@"fb_"] )
                    [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your payment of $%0.2f to %@.", [amount doubleValue], recipient.name]];
                else
                    [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your payment of $%0.2f to %@.", [amount doubleValue], recipientUri]];
                
                [self presentModalViewController:controller animated:YES];
            }
            else {
                
                PdThxAppDelegate *appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate showWithStatus:@"Finding recipient" withDetailedStatus:@"Talking with the server to retrive valid recipients.."];
                [requestMoneyService setDetermineRecipientCompleteDelegate:self];
                [requestMoneyService determineRecipient:recipient.paypoints];
            }
            
        } else {
            AddACHAccountViewController* controller= [[AddACHAccountViewController alloc] init];
            controller.newUserFlow = false;
            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
            
            [controller setNavBarTitle: @"Enable Payment"];
            [controller setHeaderText: @"To complete sending money, complete your account by adding a bank account"];
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
    
    if ( [[recipientUri substringToIndex:3] isEqualToString:@"fb_"] )
        controller.confirmationText = [NSString stringWithFormat: @"Success! Your request for $%0.2f was sent to %@.", [amount doubleValue], recipient.name];
    else
        controller.confirmationText = [NSString stringWithFormat: @"Success! Your request for $%0.2f was sent to %@.", [amount doubleValue], recipientUri];
    
    
    [controller setContinueButtonText:@"Send Another Request"];
    [controller setTransactionConfirmationDelegate: self];
    
    [self presentModalViewController:controller animated:YES];
     recipientUri = @"";
}

-(void)requestMoneyDidFail:(NSString*) message isLockedOut :(BOOL)lockedOut withPinCodeFailures : (NSInteger) pinCodeFailures {
    
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
    } else if ( contact.paypoint ){
        contactDetail.text = contact.paypoint;
    } else if ([contact.paypoints count]) {
        contactDetail.text = [NSString stringWithFormat:@"%d paypoints", [contact.paypoints count]];
    } else {
        contactDetail.text = @"No Info to Display";
    }
    
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
        HomeViewController *gvc = [[HomeViewController alloc]init];
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
