//
//  NewACHAccountViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewACHAccountViewController.h"
#import "ACHHelpView.h"

@interface NewACHAccountViewController ()

@end

@implementation NewACHAccountViewController

@synthesize achSetupDidComplete;

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
    [txtAccountNickname becomeFirstResponder];
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    accountService = [[UserSetupACHAccount alloc] init];
    [accountService setUserACHSetupCompleteDelegate: self];
    validationHelper = [[ValidationHelper alloc] init];
    
    UIImage *helpImage = [UIImage imageNamed:@"nav-help-60x30.png"];
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help"
                                                                   style:UIBarButtonSystemItemDone target:nil action:@selector(needsHelp)];
    [helpButton setImage:helpImage]; 
    self.navigationItem.rightBarButtonItem = helpButton;
    

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
    if(user.hasSecurityPin)
    {
        securityPin = pin;
        
        NSString* accountType = @"Checking";
        
        if([ctrlAccountType selectedSegmentIndex] == 1)
            accountType = @"Savings";
        
 		PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Adding Account" withDetailedStatus:@"Linking bank account"];
        
        
        [accountService addACHAccount:txtAccountNumber.text forUser:user.userId withNickname:txtAccountNickname.text withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType: accountType withSecurityPin: securityPin];
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
    [self.navigationController dismissModalViewControllerAnimated: YES];
}
-(IBAction) bgTouched:(id) sender {
    [txtAccountNickname resignFirstResponder];
    [txtAccountNumber resignFirstResponder];
    [txtNameOnAccount resignFirstResponder];
    [txtConfirmAccountNumber resignFirstResponder];
    [txtRoutingNumber resignFirstResponder];
}
-(void)userACHSetupDidComplete:(NSString*) paymentAccountId {
    [achSetupDidComplete userACHSetupDidComplete:paymentAccountId];
}
-(void)userACHSetupDidFail:(NSString*) message {
    [achSetupDidComplete userACHSetupDidFail: message];
}
@end
