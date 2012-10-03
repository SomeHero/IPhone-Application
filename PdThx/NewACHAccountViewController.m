//
//  NewACHAccountViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewACHAccountViewController.h"
#import "ACHHelpView.h"
#import "AROverlayViewController.h"
#import "NSData+Base64Encoding.h"
#import "UIImage+Scale.h"
#import "BankAccountService.h"
#import "PdThxAppDelegate.h"

@interface NewACHAccountViewController ()

@end

@implementation NewACHAccountViewController

@synthesize achSetupDidComplete;
@synthesize mipControllerInstance;

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
    // Do any additional setup after loading the view from its nib.
    //[txtAccountNickname becomeFirstResponder];
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    accountService = [[UserSetupACHAccount alloc] init];
    [accountService setUserACHSetupCompleteDelegate: self];
    validationHelper = [[ValidationHelper alloc] init];
    
    //UIImage *helpImage = [UIImage imageNamed:@"nav-help-60x30.png"];
    //UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help"
                                                        //           style:UIBarButtonSystemItemDone target:nil action:@selector(needsHelp)];
    //[helpButton setImage:helpImage];
    //self.navigationItem.rightBarButtonItem = helpButton;
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ( appDelegate.user.firstName != (id)[NSNull null] && appDelegate.user.lastName!= (id)[NSNull null] &&
        appDelegate.user.firstName.length > 0 && appDelegate.user.lastName.length > 0 )
    {
        txtNameOnAccount.text = [NSString stringWithFormat:@"%@ %@", appDelegate.user.firstName, appDelegate.user.lastName];
    }
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


-(void)needsHelp
{
    NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"NewAccountHelpViewController" owner:self options:nil];
    
    [self.view addSubview:[nibArray objectAtIndex:0]];
    
}

- (void)viewDidUnload
{
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
    NSString* nameOnAccount = @"";
    NSString* routingNumber = @"";
    NSString* accountNumber = @"";
    NSString* confirmAccountNumber = @"";
    
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
        
        GenericSecurityPinSwipeController* controller = [[[GenericSecurityPinSwipeController alloc] init] retain];
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
-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{
    [sender dismissModalViewControllerAnimated:YES];
    
    if(user.hasSecurityPin)
    {
        securityPin = pin;
        
        NSString* accountType = @"Checking";
        
        if([ctrlAccountType selectedSegmentIndex] == 1)
            accountType = @"Savings";
        
 		PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Adding Account" withDetailedStatus:@"Linking bank account"];
        
        NSString* nickName = @"";
        
        if ( [txtAccountNickname.text isEqualToString:@""] || txtAccountNickname.text.length == 0 )
        {
            nickName = [NSString stringWithFormat:@"%@ %@",accountType,[txtAccountNumber.text substringFromIndex:txtAccountNumber.text.length-4]];
        }
        
        NSLog(@"Submitting with Nickname: %@",nickName);
        
        [accountService addACHAccount:txtAccountNumber.text forUser:user.userId withNickname:nickName withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType: accountType withSecurityPin: securityPin];
    }
    else {
        if([sender tag] == 1)
        {
            [self.navigationController dismissModalViewControllerAnimated:NO];
            
            securityPin = pin;
            
            GenericSecurityPinSwipeController* controller =[[[GenericSecurityPinSwipeController alloc] init] retain];
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
        
        AddSecurityQuestionViewController* addSecurityQuestionController = [[[AddSecurityQuestionViewController alloc] init] retain];
        
        UINavigationController *navigationBar=[[UINavigationController alloc]initWithRootViewController:addSecurityQuestionController];
        
        [addSecurityQuestionController setSecurityQuestionEnteredDelegate:self];
        [addSecurityQuestionController setNavigationTitle: @"Add a Security Question"];
        
        [self.navigationController presentModalViewController:navigationBar animated:YES];
        
        [navigationBar release];
        [addSecurityQuestionController release];
        
    }
}
-(void)choseSecurityQuestion:(int)questionId withAnswer:(NSString *)questionAnswer
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Adding Account" withDetailedStatus:@"Linking bank account"];
    
    NSString* accountType = @"Checking";
    
    if([ctrlAccountType selectedSegmentIndex] == 1)
        accountType = @"Savings";
    
    [accountService setupACHAccount:txtAccountNumber.text forUser:user.userId withNickname:txtAccountNickname.text withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType:accountType withSecurityPin:securityPin withSecurityQuestionID:questionId withSecurityQuestionAnswer: questionAnswer];
    
    //if(!newUserFlow) {
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    // }
    
    
}
-(void)swipeDidCancel: (id)sender
{
    [sender dismissModalViewControllerAnimated: YES];
}
-(IBAction) bgTouched:(id) sender {
    [txtAccountNickname resignFirstResponder];
    [txtAccountNumber resignFirstResponder];
    [txtNameOnAccount resignFirstResponder];
    [txtConfirmAccountNumber resignFirstResponder];
    [txtRoutingNumber resignFirstResponder];
}
-(void)userACHSetupDidComplete:(NSString*) paymentAccountId {
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) showSuccessWithStatus:@"Success!" withDetailedStatus:@"Account Added"];
    
    BankAccountService* bankService = [[BankAccountService alloc] init];
    [bankService setBankAccountRequestDelegate:self];
    [bankService getUserAccounts:user.userId];
    
    NSLog(@"ACH Delegate: %@", achSetupDidComplete);
    [achSetupDidComplete userACHSetupDidComplete:paymentAccountId];
}
-(void)userACHSetupDidFail:(NSString*) message withErrorCode:(int)errorCode {
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) showErrorWithStatus:@"Failed!" withDetailedStatus:@"Account Invalid"];
    [achSetupDidComplete userACHSetupDidFail: message withErrorCode: errorCode];
}

-(void)getUserAccountsDidComplete:(NSMutableArray *)bankAccounts
{
    NSLog(@"User bank accounts refreshed.");
    [user setBankAccounts:bankAccounts];
    
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)getUserAccountsDidFail:(NSString *)errorMessage
{
    NSLog(@"Error Refreshing Bank Account List after Adding a Bank Account");
}

- (void)takePictureOfCheck
{
    // Load Camera with Delegate
    AROverlayViewController*cameraVC = [[AROverlayViewController alloc] init];
    
    [cameraVC setCheckImageReturnDelegate:self];
    
    [self.navigationController presentModalViewController:cameraVC animated:YES];
    [cameraVC release];
}

-(void)cameraReturnedImage:(UIImage *)image
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Please wait" withDetailedStatus:@"Reading Image"];
    
    NSLog(@"Successfully returned image: %@",image);
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    UIImage *newImage = [[[UIImage alloc] initWithData:imageData] scaleToSize:CGSizeMake(1200, 1600)];
    
    newImage = [newImage rotate:UIImageOrientationLeft];
    
    // We don't care to save it anymore. Just send it.
    // UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    [mipControllerInstance sendImage:newImage delegate:self];
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



@end
