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
    UIBarButtonItem *cancelButton =  [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemAction target:self action:@selector(cancelClicked)];
    
    self.navigationItem.leftBarButtonItem= cancelButton;
    [cancelButton release];
    
    [self setTitle: @"Add Account"];
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    accountService = [[UserSetupACHAccount alloc] init];
    [accountService setUserACHSetupCompleteDelegate: self];
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
    CustomSecurityPinSwipeController* controller = [[CustomSecurityPinSwipeController alloc] init];
    [controller setSecurityPinSwipeDelegate: self];

    [self.parentViewController presentModalViewController:controller animated:YES];
    [controller release];
}
-(void)cancelClicked {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{
    [accountService setupACHAccount:txtAccountNumber.text forUser:user.userId withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType: @"Checking" withSecurityPin:pin];
}
-(void)userACHSetupDidComplete:(NSString*) paymentAccountId {
    
    txtAccountNumber.text = @"";
    txtConfirmAccountNumber.text = @"";
    txtRoutingNumber.text = @"";
    txtNameOnAccount.text = @"";
    
    [self dismissModalViewControllerAnimated:YES];

}
-(void)userACHSetupDidFail:(NSString*) message {
    [self showAlertView: @"Unable to Setup Account" withMessage:message];
}
-(void)swipeDidCancel: (id)sender
{
    //do nothing
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
@end
