//
//  TransactionConfirmationViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TransactionConfirmationViewController.h"


@implementation TransactionConfirmationViewController

@synthesize confirmationText;
@synthesize transactionConfirmationDelegate;

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
    
    [lblConfirmationHeader dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"TransactionConfirmationViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}
-(void)viewDidAppear:(BOOL)animated {
    lblConfirmationHeader.text = confirmationText;
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

-(IBAction) btnHomeClicked:(id) sender {
    
    [self dismissModalViewControllerAnimated:YES];
    
    [transactionConfirmationDelegate onHomeClicked];
       
}
-(IBAction) btnContinueClicked: (id) sender {
    [self dismissModalViewControllerAnimated: YES];
    
    [transactionConfirmationDelegate onContinueClicked];
}
-(IBAction) btnFacebookShare:(id) sender {

}
-(IBAction) btnTwitterShare:(id) sender {
    
}


@end
