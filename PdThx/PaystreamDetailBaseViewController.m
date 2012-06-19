//
//  PaystreamDetailBaseViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PaystreamDetailBaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SetupSecurityPin.h"

@implementation PaystreamDetailBaseViewController

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@synthesize detailSubview, messageDetail;
@synthesize navBar;
@synthesize txtAction, txtRecipient, txtSender;
@synthesize lblCurrentStatusHeader, lblWhatsNextStatusHeader;
@synthesize btnSender, btnRecipient, btnCurrentStatus;
@synthesize lblSentDate;
@synthesize quoteView;
@synthesize actionView;
@synthesize pullableView;
@synthesize parent;

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
    [detailSubView release];
    [super dealloc];
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
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    [lblCurrentStatusHeader setBackgroundColor: UIColorFromRGB(0xdbefee)];
    [lblCurrentStatusHeader setTextColor: UIColorFromRGB(0x2d7c81)];
    
    [btnCurrentStatus setTitleColor:UIColorFromRGB(0xc56d0c) forState: UIControlStateNormal];
    
    [lblWhatsNextStatusHeader setBackgroundColor: UIColorFromRGB(0xdbefee)];
    [lblWhatsNextStatusHeader setTextColor: UIColorFromRGB(0x2d7c81)];
    
    [btnRecipient setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
    
    [btnRecipient.layer setCornerRadius:12.0];
    btnRecipient.clipsToBounds = YES;
    [txtRecipient setTextColor: UIColorFromRGB(0x2d7c81)];
    
    [btnSender setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
    
    [btnSender.layer setCornerRadius:12.0];
    btnSender.clipsToBounds = YES;

    [lblSentDate setTextColor: UIColorFromRGB(0xb2b7ba)];

    UIImage* redBackgroundNormal = [UIImage imageNamed: @"btn-psdetail-red-267x40.png"];
    UIImage* redBackgroundActive = [UIImage imageNamed: @"btn-psdetail-red-267x40-active.png"];
    UIImage* greenBackgroundNormal = [UIImage imageNamed: @"btn-psdetail-green-267x40.png"];
    UIImage* greenBackgroundActive = [UIImage imageNamed: @"btn-psdetail-green-267x40-active.png"];
    
    btnCancelPayment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancelPayment setBackgroundImage: redBackgroundNormal forState:UIControlStateNormal];
    [btnCancelPayment setBackgroundImage: redBackgroundActive forState:UIControlStateSelected];
    [btnCancelPayment setTitle: @"Cancel Payment" forState:UIControlStateNormal];
  [btnCancelPayment setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancelPayment addTarget:self action:@selector(btnCancelPaymentClicked) forControlEvents:UIControlEventTouchUpInside];

    btnSendReminder = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSendReminder setBackgroundImage: redBackgroundNormal forState:UIControlStateNormal];
    [btnSendReminder setBackgroundImage: redBackgroundActive forState:UIControlStateSelected];
    [btnSendReminder setTitle: @"Send a Reminder" forState:UIControlStateNormal];
    [btnSendReminder setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btnSendReminder addTarget:self action:@selector(btnSendReminderPaymentClicked) forControlEvents:UIControlEventTouchUpInside];
    
    btnAcceptRequest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAcceptRequest setBackgroundImage: redBackgroundNormal forState:UIControlStateNormal];
    [btnAcceptRequest setBackgroundImage: redBackgroundActive forState:UIControlStateSelected];
    [btnAcceptRequest setTitle: @"Accept & Pay" forState:UIControlStateNormal];
    [btnAcceptRequest setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btnAcceptRequest addTarget:self action:@selector(btnAcceptRequestClicked) forControlEvents:UIControlEventTouchUpInside];
    
    btnRejectRequest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnRejectRequest setBackgroundImage: redBackgroundNormal forState:UIControlStateNormal];
    [btnRejectRequest setBackgroundImage: redBackgroundActive forState:UIControlStateSelected];
    [btnRejectRequest setTitle: @"Reject Request" forState:UIControlStateNormal];
    [btnRejectRequest setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btnRejectRequest addTarget:self action:@selector(btnRejectRequestClicked) forControlEvents:UIControlEventTouchUpInside];
    
    btnCancelRequest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancelRequest setBackgroundImage: redBackgroundNormal forState:UIControlStateNormal];
    [btnCancelRequest setBackgroundImage: redBackgroundActive forState:UIControlStateSelected];
    [btnCancelRequest setTitle: @"Cancel Request" forState:UIControlStateNormal];
    [btnCancelRequest setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancelRequest addTarget:self action:@selector(btnCancelRequestClicked) forControlEvents:UIControlEventTouchUpInside];
    
    paystreamServices = [[PaystreamService alloc] init];
    
    [paystreamServices setCancelPaymentProtocol: self];
    [paystreamServices setCancePaymentRequestProtocol: self];
    [paystreamServices setAcceptPaymentRequestProtocol: self];
    [paystreamServices setRejectPaymentRequestProtocol: self];
}
-(void)cancelPaymentDidComplete {
    //[self.navigationController popToRootViewControllerAnimated: YES];
    [pullableView setOpened:NO animated:YES];
}
-(void)cancelPaymentDidFail {
    
}
-(void)cancelPaymentRequestDidComplete {
    [pullableView setOpened:NO animated:YES];
}
-(void)cancelPaymentRequestDidFail {
    
}
-(void)acceptPaymentRequestDidComplete {
    [pullableView setOpened:NO animated:YES];
}
-(void)acceptPaymentRequestDidFail {
    //self sho
}
-(void)rejectPaymentRequestDidComplete {
    [pullableView setOpened:NO animated:YES];
}
-(void)rejectPaymentRequestDidFail {
    
}
- (void)viewDidUnload
{
    [detailSubView release];
    detailSubView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
} 
-(void)viewDidAppear:(BOOL)animated
{
    txtRecipient.text = messageDetail.recipientName;
    txtSender.text = messageDetail.senderName;
    [btnCurrentStatus setTitle: messageDetail.messageStatus forState:UIControlStateNormal];
    
    //btnSender setImage: [UIImage imageWithContentsOfFile: messageDetail.senderUri];
    //btnRecipient setImage: [UIImage imageWithContentsOfFile:<#(NSString *)#> forState:<#(UIControlState)#>
    // Settings
	NSString*	s;
	NSString*	art		= @"bg-message-stretch.png";
	CGSize		caps		= CGSizeMake(25, 24);
	UIFont*		font		= [UIFont fontWithName:@"Helvetica-Oblique"  size: 12];
	CGFloat		padTRBL[4]	= {15, 8, 8, 8};
	UIView*		bubble;
    
	// Create bubble
	s = [NSString stringWithFormat: @"\"%@\"", messageDetail.comments];
    
    bubble =[self makeBubbleWithWidth:220 font:font text:s background:art caps:caps padding:padTRBL];
	bubble.frame = CGRectMake(0, 0, bubble.frame.size.width, bubble.frame.size.height);
	[self.quoteView addSubview:bubble];
    
    NSInteger yPos = 5;
    
    if([messageDetail.messageType isEqualToString: @"Payment"]) {
        if([messageDetail.direction isEqualToString: @"Out"]) { 
            if([messageDetail.messageStatus isEqualToString: @"Processing"]) {
                btnCancelPayment.frame = CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40);
                [actionView addSubview:btnCancelPayment];
                
                yPos = yPos + btnCancelPayment.frame.size.height + 5;
            }
            if([messageDetail.messageStatus isEqualToString: @"Processing"]) {
                btnSendReminder.frame = CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40);
                [actionView addSubview:btnSendReminder];
                
                yPos = yPos + btnSendReminder.frame.size.height + 5;
            }
        }
    }
    if([messageDetail.messageType isEqualToString: @"PaymentRequest"]) {
        if([messageDetail.direction isEqualToString: @"In"]) {
            if([messageDetail.messageStatus isEqualToString: @"Processing"]) {
                btnAcceptRequest.frame = CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40);
                [actionView addSubview:btnAcceptRequest];
                
                yPos = yPos + btnAcceptRequest.frame.size.height + 5;
            }
            if([messageDetail.messageStatus isEqualToString: @"Processing"]) {
                btnRejectRequest.frame = CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40);
                [actionView addSubview:btnRejectRequest];
                
                yPos = yPos + btnSendReminder.frame.size.height + 5;
            }
        }
        else if([messageDetail.direction isEqualToString: @"Out"]) {
            if([messageDetail.messageStatus isEqualToString: @"Processing"]) {
                btnCancelRequest.frame = CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40);
                [actionView addSubview:btnCancelRequest];
                
                yPos = yPos + btnCancelRequest.frame.size.height + 5;
            }
            if([messageDetail.messageStatus isEqualToString: @"Processing"]) {
                btnSendReminder.frame = CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40);
                [actionView addSubview:btnSendReminder];
                
                yPos = yPos + btnSendReminder.frame.size.height + 5;
            }
        }
    }
    if([messageDetail.messageType isEqualToString: @"Payment"]) {
        if([messageDetail.direction isEqualToString: @"Out"]) { 
            navBar.topItem.title = @"$ Send";
        } else {
            navBar.topItem.title = @"$ Received";
        }
    }
    else {
        if([messageDetail.direction isEqualToString: @"Out"]) { 
            navBar.topItem.title = @"Request Sent";
        } else {
            navBar.topItem.title = @"Request Received";
        }
    }

    /* ---------------------------------------------------- */
    /*      Custom Settings Button Implementation           */
    /* ---------------------------------------------------- */
    
    UIImage *bgImage = [UIImage imageNamed:@"BTN-Nav-X-35x30.png"];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, 35, 30);
    [settingsBtn addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsButtons = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    
    navBar.topItem.leftBarButtonItem = settingsButtons;
    [settingsButtons release];
    
}
-(void)btnCancelPaymentClicked {
    [paystreamServices cancelPayment: messageDetail.messageId];
}
-(void)btnAcceptRequestClicked {
    securityPinModalPanel = [[[ConfirmPaymentDialogController alloc] initWithFrame:self.view.bounds] autorelease];
    
    securityPinModalPanel.dialogTitle.text = @"Confirm Your Payment";
    //securityPinModalPanel.dialogHeading.text = [NSString stringWithFormat: @"To confirm your payment of %@ to %@, swipe your pin below.", [[txtAmount.text copy] autorelease], recipientUri];
    [securityPinModalPanel.btnCancelPayment setTitle: @"Cancel Payment" forState: UIControlStateNormal];
    securityPinModalPanel.delegate = self;
    
    controller=[[[CustomSecurityPinSwipeController alloc] init] autorelease];
    [controller setSecurityPinSwipeDelegate: self];
    [controller setNavigationTitle: @"Confirm your Pin"];
    [controller setHeaderText: [NSString stringWithFormat:@"To complete setting up your account, create a pin by connecting 4 buttons below."]];
    [controller setTag:2];    
    [self.parent presentModalViewController:controller animated:YES];
    
    ///////////////////////////////////
    // Add the panel to our view
    //[self.view addSubview:securityPinModalPanel];
    [pullableView setOpened:NO animated:YES];
    //[parent.navigationController pushViewController: securityPinModalPanel animated:YES];
}
-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{
    [paystreamServices acceptRequest:messageDetail.messageId withUserId:user.userId fromPaymentAccount:user.preferredReceiveAccountId withSecurityPin:pin];
}
-(void)swipeDidCancel: (id)sender
{
    //do nothing
}
-(void)btnRejectRequestClicked {
    [paystreamServices rejectRequest: messageDetail.messageId];
}
-(void)btnCancelRequestClicked {
    [paystreamServices cancelRequest: messageDetail.messageId];
}
-(void)closeButtonClicked
{
    [pullableView setOpened:NO animated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (UIView*)makeBubbleWithWidth:(CGFloat)w font:(UIFont*)f text:(NSString*)s background:(NSString*)fn caps:(CGSize)caps padding:(CGFloat*)padTRBL
{
	// Create label
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 1)];
    
	// Configure (for multi-line word-wrapping)
	label.font = f;
	label.numberOfLines = 0;
	label.lineBreakMode = UILineBreakModeWordWrap;
    
	// Set and size
	label.text = s;
	[label sizeToFit];
    
	// Size and create final view
	CGSize finalSize = CGSizeMake(label.frame.size.width+padTRBL[1]+padTRBL[3], label.frame.size.height+padTRBL[0]+padTRBL[2]);
	UIView* finalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, finalSize.width, finalSize.height)];
    
	// Create stretchable BG image
	UIImage* bubble = [[UIImage imageNamed:fn] stretchableImageWithLeftCapWidth:caps.width topCapHeight:caps.height];
	UIImageView* background = [[UIImageView alloc] initWithImage:bubble];
	background.frame = finalView.frame;
    
	// Assemble composite (with padding for label)
	[finalView addSubview:background];
	[finalView addSubview:label];
    label.textColor = UIColorFromRGB(0x676767);
	label.backgroundColor = [UIColor clearColor];
	label.frame = CGRectMake(padTRBL[3], padTRBL[0], label.frame.size.width, label.frame.size.height);
    
	// Clean and return
	[label release];
	[background release];
	return [finalView autorelease];
}
@end
