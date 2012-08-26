//
//  SendMoneyController.m
//  PdThx
//
//  Created by James Rhodes on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "PdThxAppDelegate.h"
#import "SendDonationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "Contact.h"
#import "SignInViewController.h"
#import "SendMoneyService.h"
#import "ContactSelectViewController.h"
#import "AmountSelectViewController.h"

#define tableHeight2 = 30;

@interface SendDonationViewController()
-(void) sendMoney;
@end

@implementation SendDonationViewController

@synthesize whiteBoxView, viewPanel, txtAmount, txtComments, amount, lm;
@synthesize chooseRecipientButton, contactHead, contactDetail, recipientImageButton, recipientId, chooseAmountButton, btnSendMoney;
@synthesize contactButtonBGImage, amountButtonBGImage, characterCountLabel;
@synthesize dummyPlaceholder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)changedCommentBox:(NSNotification*)notification
{
    if ( [txtComments.text length] > 0 ) {
        dummyPlaceholder.placeholder = @"";
    } else {
        dummyPlaceholder.placeholder = @"Add a note or dedication...";
    }
    
    if ( [txtComments.text length] <= 140 ){
        characterCountLabel.placeholder = [NSString stringWithFormat:@"%d/140",[txtComments.text length]];
    } else {
        txtComments.text = [txtComments.text substringToIndex:140];
        characterCountLabel.placeholder = @"140/140";
    }
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
    [dummyPlaceholder release];
    [dummyPlaceholder release];
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

-(void)viewDidDisappear:(BOOL)animated
{
    [txtComments resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*                  View Setup              */
    /*  --------------------------------------- */
    mainScrollView.frame = CGRectMake(0, 0, 320, 420);
    [mainScrollView setContentSize:CGSizeMake(320, 420)];
    [whiteBoxView.layer  setCornerRadius:7.0];
    
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:0.0]; // Old Width 1.0
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
    
    paystreamService = [[PaystreamService alloc] init];
    [paystreamService setSendMoneyCompleteDelegate: self];
    
    
    /*                TextField Initialization                 */
    /*  ------------------------------------------------------ */
    autoCompleteArray = [[NSMutableArray alloc] init];
    recipientId = [[NSString alloc] initWithString: @""];
    amount = [[NSString alloc] initWithString: @""];
    
    
    comments = [[NSString alloc] initWithString: @""];
    
    [self setTitle:@"Donate"];
    
    [txtAmount setDelegate:self];
    txtAmount.text = @"0.00";
    
    contactHead.text = @"Select your Cause";
    contactDetail.text = @"Click Here";
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"SendMoneyController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedCommentBox:) name:@"UITextViewTextDidChangeNotification" object:nil];
    
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
    [dummyPlaceholder release];
    dummyPlaceholder = nil;
    [self setDummyPlaceholder:nil];
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
    DonationContactSelectViewController *newView = [[DonationContactSelectViewController alloc] initWithNibName:@"DonationContactSelectViewController" bundle:nil];
    [newView setTitle: @"Donate To"];
    [newView setDidSetContactAndAmount: self];
    [newView setDidSetContact: self];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.causeSelectDidComplete = self;
}

- (IBAction)pressedAmountButton:(id)sender 
{
    AmountSelectViewController *newView = [[AmountSelectViewController alloc] initWithNibName:@"AmountSelectViewController" bundle:nil];
    [newView setTitle: @"Donation Amount"];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.amountChosenDelegate = self;
}


-(IBAction) btnSendMoneyClicked:(id)sender {
    [txtComments resignFirstResponder];
    [self sendMoney];
}
-(void) sendMoney {
    if([txtAmount.text length] > 0) {
        amount = [[txtAmount.text stringByReplacingOccurrencesOfString:@"$" withString:@""] copy];
    }
    
    if([txtComments.text length] > 0)
        comments = [txtComments.text copy];
    
    BOOL isValid = YES;
    
    //if(isValid && ![self isValidRecipientUri:recipientUri])
    //{
      //  [self showAlertView:@"Invalid Recipient!" withMessage: @"You specified an invalid recipient.  Please try again."];
        
       // isValid = NO;
    //}
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
            [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your donation of $%0.2f to %@.", [amount doubleValue], recipient.name]];
            
            [self presentModalViewController:controller animated:YES];
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
    NSString* recipientImageUri = @"";
    NSString* recipientFirstName = @"";
    NSString* recipientLastName = @"";
    
    [paystreamService sendDonation:user.userId toOrganizationId:recipient.recipientId fromSenderAccount:user.preferredPaymentAccountId withAmount:amount withComments:comments fromLatitude:latitude fromLongitude:longitude withRecipientFirstName:recipientFirstName withRecipientLastName:recipientLastName withRecipientImageUri:recipientImageUri withSecurityPin:pin];
}

-(void)swipeDidCancel: (id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

-(IBAction) bgTouched:(id) sender {
    [txtAmount resignFirstResponder];
    [txtComments resignFirstResponder];
}
/*  --------------------------------------------------------- */
/*               Local Class Methods                          */
/*  --------------------------------------------------------- */
-(BOOL)isValidRecipientId:(NSString*) recipientIdToTest {
    if([recipientIdToTest length]  == 0)
        return false; 
    
    return true;
}
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
    
    TransactionConfirmationViewController*  controller = [[TransactionConfirmationViewController alloc] init];
    controller.confirmationText = [NSString stringWithFormat: @"Success! Your payment of $%0.2f was sent to %@.", [amount doubleValue], recipient.name];
    [controller setTransactionConfirmationDelegate: self];
    [controller setContinueButtonText: @"Make Another Donation"];
    
    [self dismissModalViewControllerAnimated:NO];
    [self presentModalViewController:controller animated:YES];
    
    //[controller release];
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
-(void)onHomeClicked {
    txtAmount.text = @"0.00";
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    txtComments.text = @"";
    
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    [recipientImageButton setBackgroundImage:NULL forState:UIControlStateNormal];
    
    [self tabBarClicked:1];
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
-(void)didChooseCause:(Contact*)contact
{
    contactButtonBGImage.highlighted = YES;
    [recipientImageButton.layer setBorderWidth:0.7];
    recipient = contact;
    
    NSLog(@"RecipientID after cause chosen: %@",recipient.recipientId);
    
    if ( contact.imgData )
        [recipientImageButton setBackgroundImage:contact.imgData forState:UIControlStateNormal];
    else if ( contact.facebookID.length > 0 )
        [recipientImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", contact.facebookID]]]] forState:UIControlStateNormal];
    else {
        [recipientImageButton setBackgroundImage:NULL forState:UIControlStateNormal];
        [recipientImageButton.layer setBorderWidth:0.0];
    }
    
    contactHead.text = contact.name;
    
    if ( contact.facebookID.length > 0 ){
        contactDetail.text = @"Facebook Friend";
    } else if ( [contact.paypoints count] == 1 ){
        contactDetail.text = [contact.paypoints objectAtIndex:0];
    }else {
        contactDetail.text = @"No Info to Display";
    }
    
    self.recipientId = contact.recipientId;
    
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
-(void)didSetContactAndAmount: (Contact*)contact amount:(double)amountToSend;
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController dismissModalViewControllerAnimated:YES];

    [self didChooseCause:contact];
    [self didSelectAmount:amountToSend];
}
-(void)didSetContact: (Contact*)contact
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController dismissModalViewControllerAnimated:NO];
    
    [self didChooseCause:contact];
    
    AmountSelectViewController *newView = [[AmountSelectViewController alloc] initWithNibName:@"AmountSelectViewController" bundle:nil];
    [newView setTitle: @"Donation Amount"];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.amountChosenDelegate = self;
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