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
    
    [self setTitle: navBarTitle];
    [ctrlHeaderText setText: headerText];
    
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
    [self.parentViewController presentModalViewController:controller animated:YES];
}
-(void)cancelClicked {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{
    if(user.hasSecurityPin)
    {
        [accountService setupACHAccount:txtAccountNumber.text forUser:user.userId withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType: @"Checking" withSecurityPin:pin];
    }
    else {
        if([sender tag] == 1)
        {
            controller =[[[CustomSecurityPinSwipeController alloc] init] retain];
            [controller setSecurityPinSwipeDelegate: self];
            [controller setNavigationTitle: @"Confirm your Pin"];
            [controller setHeaderText: [NSString stringWithFormat:@"Confirm your pin, by swiping it again below"]];
            [controller setTag:2];    
            [self presentModalViewController:controller animated:YES];
            
            [controller release];
        }
        else if([sender tag] == 2)
            [accountService setupACHAccount:txtAccountNumber.text forUser:user.userId withNameOnAccount:txtNameOnAccount.text withRoutingNumber:txtRoutingNumber.text ofAccountType: @"Checking" withSecurityPin:pin];
        
        
    }
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
-(void)delete:(id)sender {
        
    [super dealloc];
    
    [navBarTitle release];
    [headerText release];}
@end
