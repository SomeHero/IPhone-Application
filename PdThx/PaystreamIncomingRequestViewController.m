//
//  PaystreamIncomingRequestViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PaystreamIncomingRequestViewController.h"


@implementation PaystreamIncomingRequestViewController

@synthesize btnAccept;
@synthesize btnCancel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction) btnAcceptClicked:(id) sender 
{
    [self showModalPanel];
}
-(IBAction) btnRejectClicked:(id) sender
{
    [paystreamServices rejectRequest: messageDetail.messageId];
}
-(void) securityPinComplete:(ConfirmPaymentDialogController *) modalPanel
               selectedCode:(NSString*) code {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* userId = [prefs stringForKey:@"userId"];
    NSString* paymentAccountId = [prefs stringForKey: @"paymentAccountId"];
    
    [paystreamServices acceptRequest:messageDetail.messageId withUserId:userId fromPaymentAccount:paymentAccountId withSecurityPin:code];

}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [paystreamServices setAcceptPaymentRequestProtocol: self];
    [paystreamServices setRejectPaymentRequestProtocol: self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction)showModalPanel {
    
    securityPinModalPanel = [[[ConfirmPaymentDialogController alloc] initWithFrame:self.view.bounds] autorelease];
    
    securityPinModalPanel.dialogTitle.text = @"Confirm Your Payment";
    securityPinModalPanel.dialogHeading.text = [NSString stringWithFormat: @"To confirm your payment of %@ to %@, swipe your pin below.", messageDetail.amount, messageDetail.senderUri];
    [securityPinModalPanel.btnCancelPayment setTitle: @"Cancel Payment" forState: UIControlStateNormal];
    securityPinModalPanel.delegate = self;
    
    ///////////////////////////////////
    // Add the panel to our view
    [self.view addSubview:securityPinModalPanel];
    
    ///////////////////////////////////
    // Show the panel from the center of the button that was pressed
    [securityPinModalPanel show];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)acceptPaymentRequestDidComplete {
    [securityPinModalPanel hide];
    
    [self.navigationController popToRootViewControllerAnimated: YES];
}
-(void)acceptPaymentRequestDidFail {
    //self sho
}
-(void)rejectPaymentRequestDidComplete {
    [self.navigationController popToRootViewControllerAnimated: YES];
}
-(void)rejectPaymentRequestDidFail {
    
}
#pragma mark - UAModalDisplayPanelViewDelegate 

// Optional: This is called before the open animations.
//   Only used if delegate is set.
- (void)willShowModalPanel:(UAModalPanel *)modalPanel {
    UADebugLog(@"willShowModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the open animations.
//   Only used if delegate is set.
- (void)didShowModalPanel:(UAModalPanel *)modalPanel {
    UADebugLog(@"didShowModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called when the close button is pressed
//   You can use it to perform validations
//   Return YES to close the panel, otherwise NO
//   Only used if delegate is set.
- (BOOL)shouldCloseModalPanel:(UAModalPanel *)modalPanel {
    UADebugLog(@"shouldCloseModalPanel called with modalPanel: %@", modalPanel);
    return YES;
}

// Optional: This is called before the close animations.
//   Only used if delegate is set.
- (void)willCloseModalPanel:(UAModalPanel *)modalPanel {
    UADebugLog(@"willCloseModalPanel called with modalPanel: %@", modalPanel);
}

// Optional: This is called after the close animations.
//   Only used if delegate is set.
- (void)didCloseModalPanel:(UAModalPanel *)modalPanel {
    UADebugLog(@"didCloseModalPanel called with modalPanel: %@", modalPanel);
}

@end
