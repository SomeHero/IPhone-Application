//
//  EditACHAccountViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditACHAccountViewController.h"

@interface EditACHAccountViewController ()

@end

@implementation EditACHAccountViewController

@synthesize bankAccount;

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
    
    [self setTitle: @"Edit Account"];
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    mainScrollView.contentSize = CGSizeMake(320, 600);
    [self.view addSubview: mainScrollView];
    
    bankAccountService = [[BankAccountService alloc] init];
    [bankAccountService setDeleteBankAccountDelegate: self];
    [bankAccountService setUpdateBankAccountDelegate: self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    txtNickName.text = bankAccount.nickName;
    txtNameOnAccount.text = bankAccount.nameOnAccount;
    txtAccountNumber.text = [NSString stringWithFormat: @"********%@", bankAccount.accountNumber];
    txtRoutingNumber.text = bankAccount.routingNumber;
    
    if([bankAccount.accountType isEqualToString: @"Savings"])
        [ctrlAccountType setSelectedSegmentIndex: 1];
    else {
        [ctrlAccountType setSelectedSegmentIndex: 0];
    }
    
    if([bankAccount.status isEqualToString: @"Pending Activation"])
    {
        [self.view addSubview: ctrlVerifyView];
    }
    else {
        [self.view addSubview: ctrlUpdateView];
    }
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
        
        [self btnSaveChangesClicked:self];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(IBAction)btnSaveChangesClicked :(id)sender {
    NSString* accountType = @"Checking";
    
    if([ctrlAccountType selectedSegmentIndex] == 1)
        accountType = @"Savings";

	PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Please wait" withDetailedStatus:@"Saving changes"];
    
    [bankAccountService updateBankAccount:bankAccount.bankAccountId forUserId:user.userId withNickname:txtNickName.text withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType: accountType withSecurityPin: @"2578"];
}
-(IBAction)btnDeleteAccountClicked:(id)sender {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Deleting Account" withDetailedStatus:@"Unlinking bank account"];
    [bankAccountService deleteBankAccount: bankAccount.bankAccountId forUserId:user.userId];
}
-(void)deleteBankAccountDidComplete {
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteBankAccountDidFail:(NSString*)errorMessage {
    
}
-(void)updateBankAccountDidComplete {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)updateBankAccountDidFail:(NSString*)errorMessage {

}
-(IBAction) bgTouched:(id) sender {
    [txtNickName resignFirstResponder];
    [txtNameOnAccount resignFirstResponder];
    [txtRoutingNumber resignFirstResponder];
    [txtAccountNumber resignFirstResponder];
}
-(IBAction)btnVerifyClicked:(id)sender {
    VerifyACHAccountViewController* controller = [[VerifyACHAccountViewController    alloc] init];
    [controller setBankAccount: bankAccount];
    [controller setVerifyBankAccountDelegate: self];
    [controller setTitle: @"Verify Account"];
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    
    [self.navigationController presentModalViewController:navBar animated:YES];
    
    [navBar release];
    [controller release];
}
-(void)verifyBankAccountsDidComplete {
    NSLog(@"Verify Bank Account Success");
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
     
    [self.navigationController dismissModalViewControllerAnimated:YES];

    // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
    // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
    // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
    // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
    [appDelegate showSuccessWithStatus: @"Account Verified" withDetailedStatus:@"Your account was successfully verified.  You can now begin to use this account to accept funds."];
}
-(void)verifyBankAccountsDidFail:(NSString*)errorMessage {

    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}
@end
