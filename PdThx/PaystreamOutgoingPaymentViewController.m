//
//  PaystreamOutgoingPaymentViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PaystreamOutgoingPaymentViewController.h"


@implementation PaystreamOutgoingPaymentViewController

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
    [paystreamServices cancelPayment: messageDetail.messageId];
}

-(IBAction) btnSenderReminder:(id) sender
{
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [paystreamServices setCancelPaymentProtocol: self];
    
    
    /* ---------------------------------------------------- */
    /*      Custom Settings Button Implementation           */
    /* ---------------------------------------------------- */
    
    UIImage *bgImage = [UIImage imageNamed:@"BTN-Nav-Settings-35x30.png"];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [settingsBtn addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsButtons = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    
    quoteView.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-320x44.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationItem.rightBarButtonItem = settingsButtons;
    [settingsButtons release];
    
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"PaystreamOutgoingPaymentViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}
-(void)viewWillAppear:(BOOL)animated {
    if(!([messageDetail.messageStatus isEqualToString: @"Processing"]))
    {
        //[btnCancel setHidden: YES];
    }
    
    NSLog(@"Message Type: %@", messageDetail.messageType);
    NSLog(@"Message Status: %@", messageDetail.messageStatus);
    NSLog(@"Message Amount: %@", messageDetail.amount);
    NSLog(@"Message Direction: %@", messageDetail.direction);
    
    [self setTitle:[self determinePageTitle]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)cancelPaymentDidComplete {
    //[self.navigationController popToRootViewControllerAnimated: YES];
    [pullableView setOpened:NO animated:YES];
}
-(void)cancelPaymentDidFail {
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened {
    
}
- (void)pullableView:(PullableView *)pView didMoveLocation:(float)relativePosition {
    
}
- (void)pullableView:(PullableView *)pView startedAnimation:(float)animationDuration withDirection:(BOOL)directionBoolean {
    
}

-(NSString*)determinePageTitle
{
    if ( [messageDetail.messageType isEqualToString:@"Payment"] )
    {
        if ( [messageDetail.direction isEqualToString:@"Out"] )
            return @"$ Sent"; // Out
        else
            return @"$ Received"; // In
    }
    else if ( [messageDetail.messageType isEqualToString:@"PaymentRequest"] )
    {
        if ( [messageDetail.direction isEqualToString:@"Out"] )
            return @"$ Requested"; // Out
        else
            return @"$ Request"; // In
    }
    else if ( [messageDetail.messageType isEqualToString:@"Donation"] )
    {
        if ( [messageDetail.direction isEqualToString:@"Out"] )
            return @"$ Donated"; // Out
        else
            return @"Donation"; // In
    }
    else
    {
        return messageDetail.messageType;
    }
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


@end
