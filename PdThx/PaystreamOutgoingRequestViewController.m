//
//  PaystreamOutgoingRequestViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PaystreamOutgoingRequestViewController.h"


@implementation PaystreamOutgoingRequestViewController

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
-(IBAction) btnCancelClicked:(id) sender
{
    [paystreamServices cancelRequest: messageDetail.messageId];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [paystreamServices setCancePaymentRequestProtocol: self];
}

-(void)cancelPaymentRequestDidComplete {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)cancelPaymentRequestDidFail {
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
