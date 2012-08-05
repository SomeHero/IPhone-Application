//
//  VerifyACHAccountViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VerifyACHAccountViewController.h"

@interface VerifyACHAccountViewController ()

@end

@implementation VerifyACHAccountViewController

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
    
    bankAccountService = [[BankAccountService alloc] init];
    
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
-(IBAction) btnVerifyAmountsClicked:(id)sender {
    
    [bankAccountService verifyBankAccount:bankAccount.bankAccountId forUserId:user.userId withFirstAmount:[txtAmount1.text doubleValue] withSecondAmount:[txtAmount2.text doubleValue]];
}
@end
