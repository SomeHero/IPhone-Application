//
//  SendMoneyController.m
//  PdThx
//
//  Created by James Rhodes on 1/28/12.
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
#import <Foundation/Foundation.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "Contact.h"
#import "SignInViewController.h"
#import "SendMoneyService.h"
#import "ContactSelectViewController.h"
#import "AmountSelectViewController.h"
#import "SelectRecipientViewController.h"

#define tableHeight2 = 30;

@interface SendMoneyController ()
-(void) sendMoney;
@end

@implementation SendMoneyController
@synthesize tabBar;
@synthesize dummyCommentPlaceholder;

@synthesize whiteBoxView, viewPanel, txtAmount, txtComments, amount, lm;
@synthesize chooseRecipientButton, contactHead, contactDetail, recipientImageButton, recipientUri, chooseAmountButton, btnSendMoney;
@synthesize contactButtonBGImage, amountButtonBGImage, characterCountLabel;

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    /*  ------------------------------------------------------ */
    /*                Image/TextField Releases                 */
    /*  ------------------------------------------------------ */
    [recipientUri release];
    [recipient release];
    [tabBar release];
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
    [dummyCommentPlaceholder release];
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
        characterCountLabel.placeholder = @"0/140";
    }
}

#pragma mark - View lifecycle
-(void) viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    if ( txtComments.text.length == 0 )
        dummyCommentPlaceholder.placeholder = @"Enter a comment or message.";
    else {
        dummyCommentPlaceholder.placeholder = @"";
    }
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
    
    
    
    
    
    /*                TextField Initialization                 */
    /*  ------------------------------------------------------ */
    autoCompleteArray = [[NSMutableArray alloc] init];
    recipientUri = [[NSString alloc] initWithString: @""];
    amount = [[NSString alloc] initWithString: @""];
    
    
    comments = [[NSString alloc] initWithString: @""];
    
    [self setTitle:@"Send $"];
    
    [txtAmount setDelegate:self];
    txtAmount.text = @"0.00";
    
    NSLog(@"Inside view did load, resetting recipient object/labels");
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"SendMoneyController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedCommentBox:) name:@"UITextViewTextDidChangeNotification" object:nil];
    
    
    tabBar = [[HBTabBarManager alloc]initWithViewController:self topView:self.view delegate:self selectedIndex:2];
}

- (void)viewDidUnload
{
    tabBar = nil;
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
    [recipient release];
    recipient = nil;
    [recipientUri release];
    recipientUri = nil;
    [self setDummyCommentPlaceholder:nil];
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
    [newView setTitle:@"Send To"];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.contactSelectChosenDelegate = self;
}

- (IBAction)pressedAmountButton:(id)sender 
{
    AmountSelectViewController *newView = [[AmountSelectViewController alloc] initWithNibName:@"AmountSelectViewController" bundle:nil];
    [newView setTitle:@"Send Amount"];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.amountChosenDelegate = self;
}


-(IBAction) btnSendMoneyClicked:(id)sender {
    [self sendMoney];
}
-(void) sendMoney {
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
                
                CustomSecurityPinSwipeController *controller=[[[CustomSecurityPinSwipeController alloc] init] autorelease];
                [controller setSecurityPinSwipeDelegate: self];
                [controller setNavigationTitle: @"Confirm"];
                
                if ( [[recipientUri substringToIndex:3] isEqualToString:@"fb_"] )
                    [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your payment of $%0.2f to %@.", [amount doubleValue], recipient.name]];
                else
                    [controller setHeaderText: [NSString stringWithFormat:@"Please swipe your security pin to confirm your payment of $%0.2f to %@.", [amount doubleValue], recipientUri]];
                
                [self presentModalViewController:controller animated:YES];
            }
            else{
                
                PdThxAppDelegate *appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
                [appDelegate showWithStatus:@"Finding recipient" withDetailedStatus:@"Talking with the server to retrive valid recipients.."];
                [sendMoneyService setDetermineRecipientCompleteDelegate:self];
                [sendMoneyService determineRecipient:recipient.paypoints];
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
    
    
    [sendMoneyService sendMoney:amount toRecipient: @"" withRecipientUri: recipientUri fromSender:user.userUri withComment:comments withSecurityPin:pin fromUserId:user.userId withFromAccount:user.preferredPaymentAccountId withFromLatitude:latitude withFromLongitude: longitude withRecipientFirstName: recipientFirstName withRecipientLastName: recipientLastName withRecipientImageUri: recipientImageUri];
}

-(void)swipeDidCancel: (id)sender
{
    //do nothing
}

-(IBAction) bgTouched:(id) sender {
    [txtAmount resignFirstResponder];
    [txtComments resignFirstResponder];
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
    self.recipientUri = uri;
    
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

-(void)sendMoneyDidComplete 
{
    [self.mainScrollView scrollsToTop];
    contactButtonBGImage.highlighted = NO;
    amountButtonBGImage.highlighted = NO;
    
    TransactionConfirmationViewController*  controller = [[[TransactionConfirmationViewController alloc] init] retain];
    
    if ( [[recipientUri substringToIndex:3] isEqualToString:@"fb_"] )
        controller.confirmationText = [NSString stringWithFormat: @"Success! Your payment of $%0.2f was sent to %@.", [amount doubleValue], recipient.name];
    else
        controller.confirmationText = [NSString stringWithFormat: @"Success! Your payment of $%0.2f was sent to %@.", [amount doubleValue], recipientUri];
    
    
    [controller setContinueButtonText:@"Send Another Payment"];
    
    [controller setTransactionConfirmationDelegate: self];
    
    
    [self dismissModalViewControllerAnimated:YES];
    [self presentModalViewController:controller animated:YES];
    recipientUri = @"";
}

-(void)sendMoneyDidFail:(NSString*) message isLockedOut :(BOOL)lockedOut withPinCodeFailures : (NSInteger) pinCodeFailures {
    
    if(lockedOut) {
        [self dismissModalViewControllerAnimated: YES];
        
        [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) signOut];
        
        [self showAlertView: @"Invalid Security Pin" withMessage:@"Your security pin was incorrect, login to continue"];
    } else {
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
    
    [self tabBarClicked:1]; // Option: REFRESH PAYSTREAM
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
    NSLog(@"Returned with Contact from ContactSelectVC");
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
    } else if ( [contact.paypoints count] == 1 ){
        contactDetail.text = [contact.paypoints objectAtIndex:0];
    } else if ([contact.paypoints count] ) {
        contactDetail.text = [NSString stringWithFormat:@"%d paypoints", [contact.paypoints count]];
    }else {
        contactDetail.text = @"No Info to Display";
    }
    
    if ([contact.paypoints count] == 1)
    {
        recipientUri = [contact.paypoints objectAtIndex:0];
    }
    
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
        // Already the current view controller
        /*
         //Switch to the groups tab
         SendMoneyController *gvc = [[SendMoneyController alloc]init];
         [[self navigationController] pushViewController:gvc animated:NO];
         [gvc release];
         
         //Remove the view controller this is coming from, from the navigation controller stack
         NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
         [allViewControllers removeObjectIdenticalTo:self];
         [[self navigationController] setViewControllers:allViewControllers animated:NO];
         [allViewControllers release];
         */
    }
    if( buttonIndex == 3 )
    {
        //Switch to the groups tab
        RequestMoneyController *gvc = [[RequestMoneyController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
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



