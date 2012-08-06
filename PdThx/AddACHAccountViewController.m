//
//  AddACHAccountViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddACHAccountViewController.h"

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
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = nil;
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
-(void)userACHSetupDidFail:(NSString*) message {PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
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
-(IBAction)btnRemindMeLaterClicked:(id)sender;
{
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
    
}
-(void)delete:(id)sender {
        
    [super dealloc];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [navBarTitle release];
    [headerText release];
    [securityPin release];
    [validationHelper release];
}
@end
