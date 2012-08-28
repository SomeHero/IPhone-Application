//
//  AddACHAccountViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddACHAccountViewController.h"
#import "AROverlayViewController.h"
#import "NSData+Base64Encoding.h"
#import "UIImage+Scale.h"

@interface AddACHAccountViewController ()

@end

@implementation AddACHAccountViewController

@synthesize navBarTitle, headerText;
@synthesize newUserFlow;

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
    
    mainScrollView.contentSize = CGSizeMake(320, 640);
    [mainView addSubview:mainScrollView];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs objectForKey:@"firstName"] != nil && [prefs objectForKey:@"lastName"] != nil)
    {
        txtNameOnAccount.text = [NSString stringWithFormat:@"%@ %@", [prefs objectForKey:@"firstName"], [prefs objectForKey:@"lastName"]];
    }
    
    SetupNavigationView *setupNavBar = [[SetupNavigationView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
    [setupNavBar setActiveState:@"Enable" withJoinComplete:YES whereActivateComplete:YES wherePersonalizeComplete:YES whereEnableComplete:NO];
    [navBar addSubview:setupNavBar];
    
    validationHelper = [[ValidationHelper alloc] init];
    
    [self setTitle: @"Enable Payments"];
    [ctrlHeaderText setText: headerText];
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    accountService = [[UserSetupACHAccount alloc] init];
    [accountService setUserACHSetupCompleteDelegate: self];
    
    // login
    mipControllerInstance = [[MIPController alloc] init];
    [mipControllerInstance setJobName:@"ACH"];
    [mipControllerInstance setOrgID:@"PaidThx"];
    [mipControllerInstance setServerURL:@"https://mi1.miteksystems.com/mobileimaging/ImagingPhoneService.asmx"];
    
    // Do the login
    if ( [mipControllerInstance connect:@"paidthxuser2@miteksystems.com" password:@"Pa1dThxx2" delegate:self] )
    {
        NSLog(@"Logging into mitek check processor...");
    } else {
        NSLog(@"ERROR!");
    }
}

- (void)connectSuccess
{
    // Stop listening
    [mipControllerInstance dropDelegate:self];
    
    NSLog(@"Success connecting to mitek systems check processor");
}

- (void)connectFailure
{
    // Stop listening
    [mipControllerInstance dropDelegate:self];
    
    NSLog(@"ERROR connecting to mitek systems check processor");
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = nil;
}
- (void)viewDidUnload
{
    [TakePictureOfCheckButton release];
    TakePictureOfCheckButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) btnCreateAccountClicked:(id)sender
{
    NSString* nameOnAccount = [NSString stringWithString: @""];
    NSString* routingNumber = [NSString stringWithString: @""];
    NSString* accountNumber = [NSString stringWithString: @""];
    NSString* confirmAccountNumber = [NSString stringWithString: @""];

    if([txtNameOnAccount.text length] > 0)
        nameOnAccount = [NSString stringWithString: txtNameOnAccount.text];
    
    if([txtRoutingNumber.text length] > 0)
        routingNumber = [NSString stringWithString: txtRoutingNumber.text];
    
    if([txtAccountNumber.text length] > 0)
        accountNumber = [NSString stringWithString: txtAccountNumber.text];
    
    if([txtConfirmAccountNumber.text length] > 0)
        confirmAccountNumber = [NSString stringWithString: txtConfirmAccountNumber.text];
    
    BOOL isValid = YES;
    
    if(isValid && ![validationHelper isValidNameOnAccount:nameOnAccount])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid Account Name"];
        
        isValid = NO;
    }
    if(isValid && ![validationHelper isValidRoutingNumber:routingNumber])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid Routing Number"];
        
        isValid = NO;
    }
    if(isValid && ![validationHelper isValidAccountNumber:accountNumber])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid Account Number"];
        
        isValid = NO;
    }
    if(isValid && ![validationHelper doesAccountNumberMatch: accountNumber doesMatch: confirmAccountNumber])
    {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Account number mismatch"];
        
        isValid = NO;
    }
    
    if(isValid) {

        controller = [[[CustomSecurityPinSwipeController alloc] init] retain];
        [controller setSecurityPinSwipeDelegate: self];
        
        if(user.hasSecurityPin)
        {
            [controller setHeaderText: @"Swipe your pin to add your new bank account"];
            [controller setNavigationTitle: @"Confirm"];
            [controller setTag: 1];
        }
        else {
            [controller setHeaderText: @"To complete setting up your account, create a security pin by connecting 4 buttons below."];
            
            [controller setNavigationTitle: @"Setup your Pin"];
            [controller setTag: 1];
        }
        [self.navigationController presentModalViewController:controller animated:YES];
    }
}
-(void)cancelClicked {
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
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
        [self btnCreateAccountClicked:self];	
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{
    if(user.hasSecurityPin)
    {
        securityPin = pin;
        
        NSString* accountType = @"Checking";
    
        if([ctrlAccountType selectedSegmentIndex] == 1)
            accountType = @"Savings";
        
 		PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Adding Account" withDetailedStatus:@"Linking bank account"];
        
        
        NSString* nickname = [NSString stringWithFormat: @"%@ %@", accountType, [txtAccountNumber.text substringFromIndex: txtAccountNumber.text.length - 5]];
        
        [accountService addACHAccount:txtAccountNumber.text forUser:user.userId withNickname:nickname withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType: accountType withSecurityPin: securityPin];
    }
    else {
        if([sender tag] == 1)
        {
            [self.navigationController dismissModalViewControllerAnimated:NO];
            
            securityPin = pin;
        
            controller =[[[CustomSecurityPinSwipeController alloc] init] retain];
            [controller setSecurityPinSwipeDelegate: self];
            [controller setNavigationTitle: @"Confirm your Pin"];
            [controller setHeaderText: [NSString stringWithFormat:@"Confirm your pin, by swiping it again below"]];
            
            [controller setTag:2];    
            [self.navigationController presentModalViewController:controller animated:YES];
            
            [controller release];
        }
        else if([sender tag] == 2)
            
            [self.navigationController dismissModalViewControllerAnimated:NO];
        
            securityPin = pin;
        
            addSecurityQuestionController = [[[AddSecurityQuestionViewController alloc] init] retain];
        
            UINavigationController *navigationBar=[[UINavigationController alloc]initWithRootViewController:addSecurityQuestionController];
        
            [addSecurityQuestionController setSecurityQuestionEnteredDelegate:self];
            [addSecurityQuestionController setNavigationTitle: @"Add a Security Question"];
        
            [self.navigationController presentModalViewController:navigationBar animated:YES];
        
            [navigationBar release];
    }
}
-(void)choseSecurityQuestion:(int)questionId withAnswer:(NSString *)questionAnswer
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Adding Account" withDetailedStatus:@"Linking bank account"];
    
    NSString* accountType = @"Checking";
    
    if([ctrlAccountType selectedSegmentIndex] == 1)
        accountType = @"Savings";
    
    NSString* nickname = [NSString stringWithFormat: @"%@ %@", accountType, [txtAccountNumber.text substringFromIndex: txtAccountNumber.text.length - 5]];
    
    [accountService setupACHAccount:txtAccountNumber.text forUser:user.userId withNickname:nickname withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType:accountType withSecurityPin:securityPin withSecurityQuestionID:questionId withSecurityQuestionAnswer: questionAnswer];
    
    //if(!newUserFlow) {
        //[self.navigationController dismissModalViewControllerAnimated:YES];
   // }


}
-(void)userACHSetupDidComplete:(NSString*) paymentAccountId {
    if([user.preferredPaymentAccountId length] == 0)
        user.preferredPaymentAccountId = paymentAccountId;
    if([user.preferredReceiveAccountId length] == 0)
        user.preferredReceiveAccountId = paymentAccountId;
    
    txtAccountNumber.text = @"";
    txtConfirmAccountNumber.text = @"";
    txtRoutingNumber.text = @"";
    txtNameOnAccount.text = @"";
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showSuccessWithStatus:@"Account Added!" withDetailedStatus:@"Linked bank account"];
    
    if(newUserFlow) {
     [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
        
    }
    else {
        [self.navigationController dismissModalViewControllerAnimated: YES];
        [self.navigationController popViewControllerAnimated:YES];
        //[self dismissModalViewControllerAnimated:YES];
    }

}
-(void)userACHSetupDidFail:(NSString*) message {
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Error linking account"];
}
-(void)swipeDidCancel: (id)sender
{
    [self.navigationController dismissModalViewControllerAnimated: YES];
}
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:100.0 alpha:0.5];
        titleView.shadowOffset = CGSizeMake(0.0,1.5);
        
        //52.0 54.0 61.0 is the grey he wanted
        titleView.textColor = [UIColor colorWithRed:52.0/255.0 green:54.0/255.0 blue:61.0/255.0 alpha:1.0];
        
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    
    titleView.text = title;
    [titleView sizeToFit];
}
-(IBAction) bgClicked:(id)sender {
    [txtAccountNumber resignFirstResponder];
    [txtConfirmAccountNumber resignFirstResponder];
    [txtNameOnAccount resignFirstResponder];
    [txtRoutingNumber resignFirstResponder];
}

- (IBAction)takePictureOfCheck:(id)sender {
    // Load Camera with Delegate
    AROverlayViewController*cameraVC = [[AROverlayViewController alloc] init];
    
    [cameraVC setCheckImageReturnDelegate:self];
    
    [self presentModalViewController:cameraVC animated:YES];
}

-(void)cameraReturnedImage:(UIImage *)image
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Please wait" withDetailedStatus:@"Reading Image"];
    
    NSLog(@"Successfully returned image: %@",image);
    [self dismissModalViewControllerAnimated:YES];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    UIImage *newImage = [[[UIImage alloc] initWithData:imageData] scaleToSize:CGSizeMake(1200, 1600)];
    
    newImage = [newImage rotate:UIImageOrientationLeft];
    
    // We don't care to save it anymore. Just send it.
    // UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [mipControllerInstance sendImage:newImage delegate:self];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else {
        // TODO: IMPLEMENT FINISHED SUCCESSFULLY POPOVER
        
        // TODO: CALL IMAGE ADDED DELEGATE
        //[CheckImageReturnDelegate cameraReturnedImage:image];
        NSLog(@"Saved image %@.", image);
    }
}



- (NSString *)determineValue:(NSDictionary *)field money:(BOOL)money {
    
    NSString *value;
    
    // The hell does this class do? It seems there's supposed to be different states of information...
    // Like re-saved after a user edits it. I'm really not sure.
    
    if((value = [field objectForKey:@"ValueBest"]) && [value length] > 0)
        return value;
    else if((value = [field objectForKey:@"ValueUserUpdated"]) && [value length] > 0)
        return value;
    else if((value = [field objectForKey:@"ValuePostProcessed"]) && [value length] > 0)
        return value;
    else if((value = [field objectForKey:@"ValueStandardized"]) && [value length] > 0)
        return value;
    else if((value = [field objectForKey:@"Value"]) && [value length] > 0 && money == NO)
        return value;
    else
        return @"";
}

- (void)loadTheResults:(NSDictionary *)transaction
{
    
    NSMutableDictionary *returnedAccountInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    
    // Convert the extracted fields
    NSDictionary *extractedFields = [transaction objectForKey:@"ExtractedFields"];
    
    for(NSDictionary *eachField in extractedFields)
    {
        NSDictionary *Field = [eachField objectForKey:@"ExtractedField"];
        
        NSString * FieldName = [Field objectForKey:@"Name"];
        
        // Automatic Clearing House ///////////////////////////////////////////////////////////////////
        if([FieldName isEqualToString:@"MICR routing#"])
            [returnedAccountInfo setObject:[self determineValue:Field money:NO] forKey:@"RoutingNumber"];
        
        else if([FieldName isEqualToString:@"MICR account#"])
            [returnedAccountInfo setObject:[self determineValue:Field money:NO] forKey:@"AccountNumber"];
    }
    
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate dismissProgressHUD];
    [appDelegate showSimpleAlertView:TRUE withTitle:@"Success!" withSubtitle:@"Based on your check, we found:" withDetailedText:[NSString stringWithFormat:@"Your Routing Number is #%@, and your Account Number is #%@. Please verify this information matches the information on your check.",[returnedAccountInfo valueForKey:@"RoutingNumber"],[returnedAccountInfo valueForKey:@"AccountNumber"]] withButtonText:@"Ok" withDelegate:self];
    
    txtAccountNumber.text = [returnedAccountInfo valueForKey:@"AccountNumber"];
    txtConfirmAccountNumber.text = txtAccountNumber.text;

    txtRoutingNumber.text = [returnedAccountInfo valueForKey:@"RoutingNumber"];
    
    [returnedAccountInfo removeObjectForKey:@"RoutingNumber"];
    [returnedAccountInfo removeObjectForKey:@"AccountNumber"];
}

-(void)didSelectButtonWithIndex:(int)index
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissAlertView];
}

#pragma mark -
#pragma mark WebService Delegate

- (void)imageFailure:(NSError *)err
{
    // TODO: DISMISS PROGRESS HUD AND SHOW ALERT VIEW LIKE IT DOES BELOW
    
	NSLog(@"Failure signaled - %@", [err description]);
    
    // TODO: FIX TRANSITION
}

- (void) imageSuccess:(NSDictionary *)xmlDict {
	
    // TODO: DISMISS PROGRESS HUD
    
    NSDictionary *transaction = [xmlDict objectForKey:@"Transaction"];
    if(transaction)
    {
        if([[xmlDict objectForKey:@"SecurityResult"] integerValue]) {
            PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [appDelegate dismissProgressHUD];
            [appDelegate showSimpleAlertView:TRUE withTitle:@"Failed" withSubtitle:@"Unable to read your check" withDetailedText:@"The image was too blurry, or one of the corners of the check was cut off. Please try to place the entire check inside the box." withButtonText:@"Ok" withDelegate:self];
        }
        else if(![[transaction objectForKey:@"IQAGood"] boolValue]) {
            
            PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [appDelegate dismissProgressHUD];
            [appDelegate showSimpleAlertView:FALSE withTitle:@"Failed" withSubtitle:@"Unable to read your check" withDetailedText:@"The image was too blurry, or one of the corners of the check was cut off. Please try to place the entire check inside the box." withButtonText:@"Ok" withDelegate:self];
        }
        else
        {
            // TODO: LOAD RESULTS BASICALLY JUST CHANGES THE TEXT FIELDS ON THE ACCOUNT ADD SCREEN
            [self loadTheResults:transaction];
        }
    }
    else {
        NSLog(@"Error connecting to mitek");
    }
}

-(IBAction)btnRemindMeLaterClicked:(id)sender;
{
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
}

-(void)delete:(id)sender
{
    [super dealloc];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [navBarTitle release];
    [headerText release];
    [securityPin release];
    [validationHelper release];
}

- (void)dealloc {
    [TakePictureOfCheckButton release];
    [super dealloc];
}
@end
