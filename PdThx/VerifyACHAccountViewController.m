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

@synthesize verifyBankAccountDelegate;
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
    
    bankAccountService = [[BankAccountService alloc] init];
    [bankAccountService setVerifyBankAccountDelegate:self]; 
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *tempAmount = [NSMutableString stringWithString:@""];
    [tempAmount appendString: @""];
    
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
        if([tempAmount length] < 4)
            [tempAmount insertString:@"0" atIndex:0];
        
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
        while (([tempAmount length] < 3)) {
            [tempAmount insertString:@"0" atIndex:0];
        }
        [tempAmount insertString: @"." atIndex: [tempAmount length] -2];
        if([tempAmount length] < 4)
            [tempAmount insertString:@"0" atIndex:0];
        [textField setText:tempAmount];

    }
    
    return NO;
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
    
    [txtAmount1 resignFirstResponder];
    [txtAmount2 resignFirstResponder];
    
    [bankAccountService verifyBankAccount:bankAccount.bankAccountId forUserId:user.userId withFirstAmount:txtAmount1.text withSecondAmount:txtAmount2.text];
}
-(void)verifyBankAccountsDidComplete {
    NSLog(@"Verify Bank Account Success");
    
    bankAccount.status = @"Verified";
    
    [verifyBankAccountDelegate verifyBankAccountsDidComplete];
    
}
-(void)verifyBankAccountsDidFail:(NSString*)errorMessage {
    NSLog(@"Verify Bank Account InValid");
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
    // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
    // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
    // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
    [appDelegate showTwoButtonAlertView:NO withTitle:@"Verification Failed" withSubtitle:@"The deposit amounts you entered were incorrect" withDetailedText:@"The verification amounts that you entered did not match the amounts we deposited into this account.  Please re-check the amounts and try again."withButton1Text:@"Try Again" withButton2Text: @"Cancel" withDelegate: self];
}
-(void) didSelectButtonWithIndex:(int)index
{
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate*) [[UIApplication sharedApplication] delegate];
    
    switch(index)
    {
        case 0:
        {
            [appDelegate dismissAlertView];

            break;
        }
        case 1:
        {
            [appDelegate dismissAlertView];
            
            [self.navigationController dismissModalViewControllerAnimated:YES];
            
            [verifyBankAccountDelegate verifyBankAccountsDidFail: @""];
            
            break;
        }
        default:
        {
            [appDelegate dismissAlertView];
            
            break;
        }
    }
}
@end
    
