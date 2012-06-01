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

#define kOFFSET_FOR_KEYBOARD 80.0

@interface RequestMoneyController ()
- (BOOL)isValidRecipientUri:(NSString *)recipientUriToTest;
- (BOOL)isValidAmount:(NSString *)amountToTest;

- (void)requestMoney;
- (void)signOutClicked;
- (void)showModalPanel;


@end

@implementation RequestMoneyController

@synthesize recipientUri;
@synthesize txtAmount, txtComments, btnSendRequest;
@synthesize viewPanel;
@synthesize recipientImageButton;
@synthesize chooseRecipientButton;
@synthesize contactHead;
@synthesize contactDetail;


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
    [viewPanel release];
    [txtAmount release];
    [txtComments release];
    [btnSendRequest release];
    [securityPinModalPanel release];
    [amount release];
    [comments release];
    [requestMoneyService release];

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

    [recipientImageButton.layer setCornerRadius:12.0];
    [recipientImageButton.layer setMasksToBounds:YES];
    
    requestMoneyService = [[RequestMoneyService alloc] init];
    [requestMoneyService setRequestMoneyCompleteDelegate: self];
    
    autoCompleteArray = [[NSMutableArray alloc] init];

    //---set the viewable frame of the scroll view---
    scrollView.frame = CGRectMake(0, 0, 320, 460);
    //---set the content size of the scroll view---
    [scrollView setContentSize:CGSizeMake(320, 713)];


    //[self loadContacts];

    self.navigationItem.title = @"Request $";

    //setup internal viewpanel
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];

    //Search Bar
	//txtRecipientUri.borderStyle = UITextBorderStyleRoundedRect; // rounded, recessed rectangle
	//txtRecipientUri.autocorrectionType = UITextAutocorrectionTypeNo;
	//txtRecipientUri.textAlignment = UITextAlignmentLeft;
	//txtRecipientUri.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	//txtRecipientUri.returnKeyType = UIReturnKeyDone;
	//txtRecipientUri.font = [UIFont fontWithName:@"Trebuchet MS" size:22];
	//txtRecipientUri.textColor = [UIColor blackColor];
	//[txtRecipientUri setDelegate:self];

	//Autocomplete Table
	//autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(txtRecipientUri.frame.origin.x+2, txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, tableHeight) style:UITableViewStylePlain];
	autoCompleteTableView.delegate = self;
	autoCompleteTableView.dataSource = self;
	autoCompleteTableView.scrollEnabled = YES;
	autoCompleteTableView.hidden = YES;
	autoCompleteTableView.rowHeight = tableHeight;
	[self.scrollView addSubview:autoCompleteTableView];
	[autoCompleteTableView release];

    [txtAmount setDelegate:self];

    txtAmount.text = @"$0.00";

    //setup internal viewpanel
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    contactHead.text = @"Select a Recipient";
    contactDetail.text = @"Click Here";

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction) bgTouched:(id) sender {
    [txtAmount resignFirstResponder];
    [txtComments resignFirstResponder];
}
// Take string from Search Textfield and compare it with autocomplete array
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {

	// Put anything that starts with this substring into the autoCompleteArray
	// The items in this array is what will show up in the table view

	[autoCompleteArray removeAllObjects];

	for(Contact *contact in allResults) {
        NSRange substringRangeLowerCase = [contact.phoneNumber rangeOfString:[substring lowercaseString]];
		NSRange substringRangeUpperCase = [contact.phoneNumber rangeOfString:[substring uppercaseString]];

		if (substringRangeLowerCase.length != 0 || substringRangeUpperCase.length != 0) {
			[autoCompleteArray addObject: contact];
		}
	}
	autoCompleteTableView.hidden = NO;
	[autoCompleteTableView reloadData];
}
- (void) finishedSearching {
	autoCompleteTableView.hidden = YES;
}
#pragma mark UITextFieldDelegate methods
// Close keyboard when Enter or Done is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0)
        [self finishedSearching];

  NSInteger nextTag = textField.tag + 1;
  // Try to find next responder
  UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [textField resignFirstResponder];
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];

        [self requestMoney];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

// String in Search textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == 0) {
        NSString *substring = [NSString stringWithString:textField.text];
        substring = [substring stringByReplacingCharactersInRange:range withString:string];
        [self searchAutocompleteEntriesWithSubstring:substring];

        return YES;
    } else if(textField.tag == 1) {
        NSMutableString *tempAmount = [NSMutableString stringWithString:@""];
        [tempAmount appendString: @"$"];

        if([string isEqualToString:@""]) {
            for (int i = 0; i< [textField.text length] - 1; i++) {
                if([string length] == 0 && i == [textField.text length] - 1)
                    continue;

                char digit = (char) [textField.text characterAtIndex: (NSUInteger)i];

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

                char digit = (char) [textField.text characterAtIndex: (NSUInteger)i];

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

#pragma mark UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {

	
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
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if(textField.tag == 1)
    {
        [textField setText: @"$0.00"];
        
        return NO;
    } 
    
    return YES;
}
-(void) signOutClicked {
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];

    [appDelegate signOut];

    UINavigationController *navController = self.navigationController;

    RequestMoneyController *requestMoneyController = [[[RequestMoneyController alloc] initWithNibName:@"RequestMoneyController" bundle:nil] autorelease];

    //[requestMoneyController setSignInCompleteDelegate: self];
    //[requestMoneyController setAchSetupCompleteDelegate:self];

    [self removeCurrentViewFromNavigation: navController];
    [navController pushViewController:requestMoneyController animated: YES];

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
        comments = txtComments.text;

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
    
    double latitude = 0.0;
    double longitude = 0.0;
    
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
    [self showAlertView:@"Reqjest Sent!" withMessage: message];
}
-(void)requestMoneyDidFail: (NSString*) message {
    [self showAlertView: @"Error Requesting Money" withMessage:message];
}
- (IBAction)pressedChooseRecipientButton:(id)sender 
{
    ContactSelectViewController *newView = [[ContactSelectViewController alloc] initWithNibName:@"ContactSelectViewController" bundle:nil];
    
    [self.navigationController pushViewController:newView animated:YES];
    newView.contactSelectChosenDelegate = self;
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
@end
