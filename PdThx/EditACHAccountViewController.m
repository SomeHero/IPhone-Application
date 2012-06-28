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
-(void)viewDidAppear:(BOOL)animated {
    txtNickName.text = bankAccount.nickName;
    txtNameOnAccount.text = bankAccount.nameOnAccount;
    txtAccountNumber.text = [NSString stringWithFormat: @"********%@", bankAccount.accountNumber];
    txtRoutingNumber.text = bankAccount.routingNumber;
    
    if([bankAccount.accountType isEqualToString: @"Savings"])
        [ctrlAccountType setSelectedSegmentIndex: 1];
    else {
        [ctrlAccountType setSelectedSegmentIndex: 0];
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
-(IBAction)btnSaveChangesClicked :(id)sender {
    NSString* accountType = @"Checking";
    
    if([ctrlAccountType selectedSegmentIndex] == 1)
        accountType = @"Savings";
    
    [bankAccountService updateBankAccount:bankAccount.bankAccountId forUserId:user.userId withNickname:txtNickName.text withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType: accountType withSecurityPin: @"2578"];
}
-(IBAction)btnDeleteAccountClicked:(id)sender {
    [bankAccountService deleteBankAccount: bankAccount.bankAccountId forUserId:user.userId];
}
-(void)deleteBankAccountDidComplete {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteBankAccountDidFail:(NSString*)errorMessage {
    
}
-(void)updateBankAccountDidComplete {
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
@end
