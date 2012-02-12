//
//  RequestMoneyController.m
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PdThxAppDelegate.h"
#import "RequestMoneyController.h"
#import "ALUnlockPatternView.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "SetPasswordController.h"
#import "ProfileController.h"
#import "CreateSecurityCode.h"
#import "VerificationMobileDevice.h"
#import "PdThxAppDelegate.h"
#import "SNPopupView.h"
#import "Contact.h"
#import "SendMoneyRequest.h"

@implementation RequestMoneyController

@synthesize scrollView, txtRecipientUri, txtAmount, txtComments;

float tableHeight = 30;

-(BOOL)showConfirmation
{
    return _showConfirmation;
}
-(void) setShowConfirmation:(BOOL)showConfirmationValue
{
    _showConfirmation = showConfirmationValue;
}
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
    [scrollView release];
    [txtRecipientUri release];
    [txtAmount release];
    [txtComments release];
    [autoCompleteArray release];
    [allResults release];
    
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-settings3.png"] style: UIBarButtonItemStylePlain target: self action:@selector(actionButtonClicked:)];
    

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool setupSecurityPin = [prefs boolForKey:@"setupSecurityPin"];
    bool setupPassword = [prefs boolForKey:@"setupPassword"];
    
    if(setupPassword) {
        self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonSystemItemAction target:self action:@selector(signOutClicked)];
    }
    
    //Search Bar
	txtRecipientUri.borderStyle = 3; // rounded, recessed rectangle
	txtRecipientUri.autocorrectionType = UITextAutocorrectionTypeNo;
	txtRecipientUri.textAlignment = UITextAlignmentLeft;
	txtRecipientUri.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	txtRecipientUri.returnKeyType = UIReturnKeyDone;
	txtRecipientUri.font = [UIFont fontWithName:@"Trebuchet MS" size:22];
	txtRecipientUri.textColor = [UIColor blackColor];
	[txtRecipientUri setDelegate:self];
    txtRecipientUri.text= [[SendMoneyRequest sendMoneyRequest] recipientUri];
    
	//Autocomplete Table
	autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(txtRecipientUri.frame.origin.x+2, txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, tableHeight) style:UITableViewStylePlain];
	autoCompleteTableView.delegate = self;
	autoCompleteTableView.dataSource = self;
	autoCompleteTableView.scrollEnabled = YES;
	autoCompleteTableView.hidden = YES; 
	autoCompleteTableView.rowHeight = tableHeight;
	[self.scrollView addSubview:autoCompleteTableView];
	[autoCompleteTableView release];
    
    [txtAmount setDelegate:self];
    if([[[SendMoneyRequest sendMoneyRequest] amount] length] > 0)
        txtAmount.text = [[SendMoneyRequest sendMoneyRequest] amount];
    else
        txtAmount.text = @"$0.00";
    
    txtComments.text = [[SendMoneyRequest sendMoneyRequest] comments];
    
    if(setupSecurityPin) {
        _viewLock=[[[ALUnlockPatternView alloc] initWithFrame:CGRectMake(36, txtComments.frame.origin.y + txtComments.frame.size.height + 16, 200, 200)] autorelease];
        _viewLock.delegate=self;
        _viewLock.lineColor=[UIColor whiteColor];
        _viewLock.lineWidth=12;
        _viewLock.lineColor=[UIColor colorWithRed:0.576 green:0.816 blue:0.133 alpha:1.000];
        [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"nSel.png"] forState:UIControlStateNormal];
        [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"sel.png"] forState:UIControlStateSelected];
        [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"hSel.png"] forState:UIControlStateHighlighted];
        
        CGPoint point = CGPointMake(_viewLock.frame.origin.x + _viewLock.frame.size.width/2, _viewLock.frame.origin.y);
        
        if(_showConfirmation) {
            popup = [[SNPopupView alloc] initWithString:@"Enter Your Security Code"];
            
            [popup presentModalAtPoint:point inView:self.view];
            [popup addTarget:self action:@selector(didTouchPopupView:)];
            [popup release];
            [popup setDelegate:self];
        }
        
        [self.scrollView addSubview:_viewLock];
        [button setHidden:YES];
        
    } else {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self 
                   action:@selector(submitButtonClicked:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Send Money" forState:UIControlStateNormal];
        button.frame = CGRectMake(80.0, txtComments.frame.origin.y + txtComments.frame.size.height + 16, 160.0, 40.0);
        
        [self.scrollView addSubview:button];
        [_viewLock setHidden:YES];
    }
    
    
}
- (void)didTouchPopupView:(SNPopupView*)sender {
	//DNSLogMethod
	//DNSLog(@"%@", sender);
    NSLog(@"Popup View Touched");
}

- (void)didDismissModal:(SNPopupView*)popupview {
	//DNSLogMethod
	//if (popupview == popup) {
	//	popup = nil;
	//}
}
- (void)viewDidLoad
{
    autoCompleteArray = [[NSMutableArray alloc] init];
    
    //---set the viewable frame of the scroll view---
    scrollView.frame = CGRectMake(0, 0, 320, 460);
    //---set the content size of the scroll view---
    [scrollView setContentSize:CGSizeMake(320, 713)];  
    
    
    [self LoadContacts];
    
    [super viewDidLoad];
    
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
-(void)unlockPatternView:(ALUnlockPatternView *)patternView didSelectCellAtIndex:(int)index andpartialCode:
(NSString *)partialCode{
    
    [scrollView setScrollEnabled:NO];
    
    NSString *state=@"";
    for (int i=1; i<=9; i++)
        state=[state stringByAppendingFormat:@"%d",[_viewLock isCellSelected:i]];
    NSLog(@"%@",state);
    //NSLog(@"%d %@",index,partialCode);
    //[_delegate insertedCode:partialCode];
}
-(void)unlockPatternView:(ALUnlockPatternView *)patternView selectedCode:(NSString *)code{
    
    [scrollView setScrollEnabled:YES];
    
    NSLog(@"Your code is %@", code);
    //[_delegate insertedCode:code fromModalViewController:self];
    
    NSString* recipient = txtRecipientUri.text;
    NSString* amount = txtAmount.text;
    NSString* comments = txtComments.text;
    
    BOOL isValid = YES;
    
    if(isValid && ![self isValidRecipientUri: recipient])
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
        [[SendMoneyRequest sendMoneyRequest] setRecipientUri:recipient];
        [[SendMoneyRequest sendMoneyRequest] setAmount:amount];
        [[SendMoneyRequest sendMoneyRequest] setComments:comments];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString* userId = [prefs stringForKey:@"userId"];
        bool setupSecurityPin = [prefs boolForKey: @"setupSecurityPin"];
        bool hasPassword = [prefs boolForKey:@"setupPassword"];
        
        if(!_showConfirmation && !hasPassword)
        {
            
            PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [appDelegate switchToSetPasswordController];
        }
        else 
        {
            NSLog(@"Your user Id is %@", userId);
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            NSString* userId = [prefs stringForKey:@"userId"];
            NSString* mobileNumber = [prefs stringForKey:@"mobileNumber"];
            NSString* fromAccount = [prefs stringForKey:@"paymentAccountId"];
            
            amount = [amount stringByReplacingOccurrencesOfString:@"$" withString:@""];
            
            [self sendMoney:amount toRecipient:recipient
           fromMobileNumber:mobileNumber withComment:comments withSecurityPin:code fromUserId:userId fromAccount:fromAccount];
            
            _showConfirmation = NO;
        }
    }
}
-(void) actionButtonClicked:(id)sender{
    NSLog(@"Action Button Clicked");
    
    ProfileController* viewController = [[ProfileController alloc] initWithNibName:@"ProfileController" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
    
}
-(void) submitButtonClicked:(id)sender{
    [txtRecipientUri resignFirstResponder];
    [txtAmount resignFirstResponder];
    [txtComments resignFirstResponder];
    
    NSString* recipient = txtRecipientUri.text;
    NSString* amount = txtAmount.text;
    NSString* comments = txtComments.text;
    
    [[SendMoneyRequest sendMoneyRequest] setRecipientUri:recipient];
    [[SendMoneyRequest sendMoneyRequest] setAmount:amount];
    [[SendMoneyRequest sendMoneyRequest] setComments:comments];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [self registerUser:[prefs valueForKey:@"mobileNumber"] withMobileNumber:[prefs valueForKey:@"mobileNumber"] withSecurityPin:@""];
    
}
-(IBAction) bgTouched:(id) sender {
    [txtRecipientUri resignFirstResponder];
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
	[txtRecipientUri resignFirstResponder];
	autoCompleteTableView.hidden = YES;
}
#pragma mark UITextFieldDelegate methods
// Close keyboard when Enter or Done is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
	BOOL isDone = YES;
	
	if (isDone) {
		[self finishedSearching];
		return YES;
	} else {
		return NO;
	}	
} 

// String in Search textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == 0) {
        NSString *substring = [NSString stringWithString:textField.text];
        substring = [substring stringByReplacingCharactersInRange:range withString:string];
        [self searchAutocompleteEntriesWithSubstring:substring];
        
        return YES;
    } else if(textField.tag == 1) {
        NSMutableString *tempAmount = [[NSMutableString alloc] initWithString:@""];
        [tempAmount appendString: @"$"];
        
        if([string isEqualToString:@""]) {
            for (int i = 0; i< [textField.text length] - 1; i++) {
                if([string length] == 0 && i == [textField.text length] - 1)
                    continue;
                
                char digit = [textField.text characterAtIndex: i];
                
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
            
            [tempAmount release];
        }
        else if([string stringByTrimmingCharactersInSet:
                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length > 0){
            
            BOOL firstDigit = YES;
            for (int i = 0; i< [textField.text length]; i++) {
                
                char digit = [textField.text characterAtIndex: i];
                
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
            
            [tempAmount release];
        }
        
        return NO;
    }
}

#pragma mark UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    
	//Resize auto complete table based on how many elements will be displayed in the table
	if (autoCompleteArray.count >=3) {
		autoCompleteTableView.frame = CGRectMake(txtRecipientUri.frame.origin.x+2, txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, tableHeight*3);
		return autoCompleteArray.count;
	}
	
	else if (autoCompleteArray.count == 2) {
		autoCompleteTableView.frame = CGRectMake(txtRecipientUri.frame.origin.x+2, txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, tableHeight*2);
		return autoCompleteArray.count;
	}	
	else if (autoCompleteArray.count == 1) {
		autoCompleteTableView.frame = CGRectMake(txtRecipientUri.frame.origin.x+2, txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, tableHeight);
		return autoCompleteArray.count;
	}
    else  {
		autoCompleteTableView.frame = CGRectMake(txtRecipientUri.frame.origin.x+2, txtRecipientUri.frame.origin.y + txtRecipientUri.frame.size.height, txtRecipientUri.frame.size.width - 4, 0);
		return autoCompleteArray.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	txtRecipientUri.text = selectedCell.textLabel.text;
	[self finishedSearching];
}
-(void)LoadContacts {
    allResults = [[NSMutableArray alloc] init];
    
    Contact *contact;
    
    contact = [[Contact alloc] init];
    contact.name = @"James Rhodes";
    contact.phoneNumber = @"804-387-9693";
    
    [allResults addObject:contact];
    [contact release];
    
    contact = [[Contact alloc] init];
    contact.name = @"Rich Rhodes";
    contact.phoneNumber = @"804-316-9693";
    
    [allResults addObject:contact];
    [contact release];
    
    contact = [[Contact alloc] init];
    contact.name = @"DeLacy LeBlanc";
    contact.phoneNumber = @"615-517-8859";
    
    [allResults addObject:contact];
    [contact release];
    
    contact = [[Contact alloc] init];
    contact.name = @"Dad";
    contact.phoneNumber = @"703-474-9405";
    
    [allResults addObject:contact];
    [contact release];
    
    // get the address book
    ABAddressBookRef addressBook = ABAddressBookCreate() ;
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    int index = 0;
    for (int i = 0; i < nPeople; i++) {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        CFStringRef lastName = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        ABMultiValueRef multiPhones = ABRecordCopyValue(ref,kABPersonPhoneProperty);
        NSString *contactFirstLast = [NSString stringWithFormat: @"%@, %@", (NSString *)lastName, (NSString *) firstName];
        
        if([(NSString *)lastName length] == 0)
            contactFirstLast = [NSString stringWithFormat: @"%@", (NSString *) firstName];

        for(CFIndex j=0;j<ABMultiValueGetCount(multiPhones);++j) {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, j);
            NSString *phoneNumber = (NSString *) phoneNumberRef;
            
            contact = [[Contact alloc] init];
            contact.name = contactFirstLast;
            contact.phoneNumber = phoneNumber;
            
            [allResults addObject:contact];    
            [contact release];
            
            index++;
        }
    }
}
-(void) registerUser:(NSString *) userName withMobileNumber:(NSString *) mobileNumber withSecurityPin : (NSString *) securityPin
{
    
    NSString *rootUrl = [NSString stringWithString: @"pdthx.me"];
    NSString *apiKey = [NSString stringWithString: @"bda11d91-7ade-4da1-855d-24adfe39d174"];
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"http://%@/Services/UserService/Register?apiKey=%@", rootUrl, apiKey]] autorelease];  
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 userName, @"userName",
                                 mobileNumber, @"mobileNumber",
                                 deviceId, @"deviceId",
                                 securityPin, @"securityPin",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(registerUserComplete:)];
    [request setDidFailSelector:@selector(registerUserFailed:)];
    
    [request startAsynchronous];
}
-(void) registerUserComplete:(ASIHTTPRequest *)request
{
    NSString *theJSON = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    bool success = [[jsonDictionary objectForKey:@"success"] boolValue];
    NSString *message = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"message"]];
    NSString* userId = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"userId"]];
    
    if(success) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setValue: userId forKey:@"userId"];
        [prefs synchronize];
        
        PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate switchToRegisterController];
        
    }
    else {
        [self showAlertView: @"Sorry.  Try Again.!" withMessage:message];
    }
    
    [message release];
    [userId release];
}
-(void) registerUserFailed:(ASIHTTPRequest *)request
{
    // statsCommuniqueDoneProblem ... !
    NSLog(@"Register User Failed");
}
-(void) sendMoney:(NSString*) amount toRecipient:(NSString *) recipientUri fromMobileNumber:(NSString *) fromMobileNumber withComment:(NSString *) comments withSecurityPin:(NSString *) securityPin
       fromUserId: (NSString *) userId fromAccount:(NSString *) fromAccount {
    
    NSString *rootUrl = [NSString stringWithString: @"pdthx.me"];
    NSString *apiKey = [NSString stringWithString: @"bda11d91-7ade-4da1-855d-24adfe39d174"];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"http://%@/Services/PaymentRequestService/PaymentRequests?apiKey=%@", rootUrl, apiKey]] autorelease];  
    
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 apiKey, @"apiKey",
                                 userId, @"userId",
                                 deviceId, @"deviceId",
                                 recipientUri, @"recipientUri",
                                 amount, @"amount",
                                 comments, @"comments",
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
}
-(void) sendMoneyComplete:(ASIHTTPRequest *)request
{
    NSString *theJSON = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    [parser release];
    
    bool success = [[jsonDictionary objectForKey:@"success"] boolValue];
    NSString *message = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"message"]];
    
    if(success) {
        
        [self.scrollView scrollsToTop];
        
        [txtRecipientUri setText: @""];
        [txtAmount setText: @"$0.00"];
        [txtComments setText: @""];
        
        [[SendMoneyRequest sendMoneyRequest] reset];
        
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
    NSLog(@"Register User Failed");
}
- (void) showAlertView:(NSString *)title withMessage: (NSString *) message  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
                                                        message: message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}
-(void) signOutClicked {
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate signOut];
}
-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest {
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
@end
