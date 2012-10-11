//
//  PaystreamDetailBaseViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PaystreamDetailBaseViewController.h"
#import "NSAttributedString+Attributes.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@implementation PaystreamDetailBaseViewController

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@synthesize messageDetail;
@synthesize navBar;
@synthesize txtRecipient, txtSender, txtActionAmount;

@synthesize acceptButton;
@synthesize acceptPayCell;

@synthesize btnRecipient, btnSender;
@synthesize currentStatusButton, deliveryMethodButton;
@synthesize deliverySectionHeader, detailTableView, deliveryStatusCell;

@synthesize expressDeliveryButton, expressDeliveryCell, expressDeliveryChargeLabel, expressDeliveryText;

@synthesize lblSentDate, quoteView;

@synthesize sendReminderCell, remindButton, rejectRequestCell, rejectButton, statusCell;

@synthesize parent, pendingAction, paystreamServices;

@synthesize user;

@synthesize sections;
@synthesize actionTableData;

@synthesize actionButtonsHeader;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sections = [[NSMutableArray alloc] init];
        actionTableData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [detailTableView release];
    [rejectRequestCell release];
    [sendReminderCell release];
    [acceptPayCell release];
    [rejectButton release];
    [remindButton release];
    [acceptButton release];
    [expressDeliveryCell release];
    [currentStatusButton release];
    [statusCell release];
    [actionButtonsHeader release];
    [deliveryStatusCell release];
    [deliveryMethodButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)configureExpressView
{
    // Delivery Method Options
    
    id normalFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    id italicFont = [UIFont fontWithName:@"Helvetica-Oblique" size:14.0];
    
    id grayColor = UIColorFromRGB(0x33363d);
    id blueColor = UIColorFromRGB(0x015b7e);
    
    if ( [messageDetail.deliveryMethod isEqualToString:@"Standard"] )
    {
        NSMutableAttributedString*expressAttribTitle;
        
        if ( messageDetail.isExpressable )
        {
            expressAttribTitle = [[NSMutableAttributedString alloc] initWithString:@"Add Express Delivery"];
            
            // Font
            [expressAttribTitle setFont:normalFont];
            [expressAttribTitle setFont:italicFont range:[expressAttribTitle rangeOfString:@"Express Delivery"]];
            
            // Color
            [expressAttribTitle setTextColor:grayColor];
            [expressAttribTitle setTextColor:blueColor range:[expressAttribTitle rangeOfString:@"Express Delivery"]];
            
            if ( [self isReceivingMoney] )
            {
                //[expressSubtext setText:@"Get it faster!"];
            } else {
                //[expressSubtext setText:@"Send it expressed!"];
            }
            
            //[expressDeliveryButton setEnabled:YES];
        }
        else
        {
            expressAttribTitle = [[NSMutableAttributedString alloc] initWithString:@"Add Express Delivery"];
            
            // Font
            [expressAttribTitle setFont:normalFont];
            [expressAttribTitle setFont:italicFont range:[expressAttribTitle rangeOfString:@"Express Delivery"]];
            
            // Color
            [expressAttribTitle setTextColor:grayColor];
            [expressAttribTitle setTextColor:blueColor range:[expressAttribTitle rangeOfString:@"Express Delivery"]];
            
            //[expressSubtext setText:@"Not available"];
            
            //[expressDeliveryButton setEnabled:NO];
        }
    }
}

-(bool)isReceivingMoney
{
    if ( [messageDetail.direction isEqualToString:@"In"] )
    {
        if ( [messageDetail.messageType isEqualToString:@"Payment"] || [messageDetail.messageType isEqualToString:@"Donation"] )
        {
            return true;
        } else {
            return false;
        }
    } else if ( [messageDetail.direction isEqualToString:@"Out"] )
    {
        if ( [messageDetail.messageType isEqualToString:@"Request"] && [messageDetail.messageType isEqualToString:@"AcceptPledge"])
        {
            return true;
        } else {
            return false;
        }
    }
    
    return false;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    // Initialize Express Labels
    //[expressDeliveryChargeLabel setCenterVertically:YES];
    [self configureExpressView];
    
    // Disable non-clickable items.
    [btnSender setUserInteractionEnabled:NO];
    [btnRecipient setUserInteractionEnabled:NO];
    [txtActionAmount setUserInteractionEnabled:NO];
    
    [btnSender.layer setCornerRadius:11.0];
    [btnSender.layer setMasksToBounds:YES];
    [btnSender.layer setBorderWidth:0.2];
    [btnSender.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [btnRecipient.layer setCornerRadius:11.0];
    [btnRecipient.layer setMasksToBounds:YES];
    [btnRecipient.layer setBorderWidth:0.2];
    [btnRecipient.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    txtActionAmount.text = @"Action\n$AMT to";
    
    if ([self.navBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]) {
        [self.navBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-320x44.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [detailTableView setBounces:NO];
    [detailTableView setAlwaysBounceVertical:NO];
    
    [btnRecipient setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
    
    [btnRecipient.layer setCornerRadius:12.0];
    btnRecipient.clipsToBounds = YES;
    
    [btnSender setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
    
    [btnSender.layer setCornerRadius:12.0];
    btnSender.clipsToBounds = YES;
    
    // COLOR REFERENCES:
    // Amount Color: 0x3e8fa7
    // Recipient/Sender Color: 0x8d8d8d
    // Amount/Action Gray Color: 0x34363d  (also color of status text below in button)
    // Status Label Background Color: 0x6D6E71
    // Light gray line between buttons and status: 0xc1c1c1
    
    [txtRecipient setTextColor: UIColorFromRGB(0x8d8d8d)];
    [txtSender setTextColor: UIColorFromRGB(0x8d8d8d)];

    [lblSentDate setTextColor: UIColorFromRGB(0xb2b7ba)];
    
    paystreamServices = [[PaystreamService alloc] init];
    
    [paystreamServices setCancelPaymentProtocol: self];
    [paystreamServices setCancePaymentRequestProtocol: self];
    [paystreamServices setAcceptPaymentRequestProtocol: self];
    [paystreamServices setRejectPaymentRequestProtocol: self];

    txtSender.text = @"You";
    
    
    // Settings
	NSString*	s;
	NSString*	art		= @"bg-message-stretch.png";
	CGSize		caps		= CGSizeMake(25, 24);
    UIFont*		font;
    if ( messageDetail.comments.length > 100 )
        font = [UIFont fontWithName:@"Helvetica-Oblique"  size: 8];
    else
        font = [UIFont fontWithName:@"Helvetica-Oblique"  size: 12];
    
	CGFloat		padTRBL[4]	= {15, 8, 8, 8};
	UIView*		bubble;
    
	// Create bubble
	s = [NSString stringWithFormat: @"\"%@\"", messageDetail.comments];
    
    bubble =[self makeBubbleWithWidth:220 font:font text:s background:art caps:caps padding:padTRBL];
	bubble.frame = CGRectMake(0, 0, bubble.frame.size.width, bubble.frame.size.height);
	[self.quoteView addSubview:bubble];
    
    NSString* actionString = @"Action";
    NSString* amountString = [NSString stringWithFormat:@"$%0.2f",[messageDetail.amount doubleValue]];
    NSString* toFromString = @"";
    
    actionString = [self determineActionString];
    toFromString = [self determineToFromString];
    
    NSString *nonAttribString = [NSString stringWithFormat:@"%@\n%@ %@",actionString, amountString, toFromString];
    
    NSMutableAttributedString*attribString = [[NSMutableAttributedString alloc] initWithString:nonAttribString];
    
    NSRange attribRange = [nonAttribString rangeOfString:amountString];
    
    [attribString setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
    
    [attribString setTextColor:UIColorFromRGB(0x3E8FA7) range:attribRange];
    
    [attribString setTextAlignment:CTTextAlignmentFromUITextAlignment(UITextAlignmentCenter) lineBreakMode:kCTLineBreakByWordWrapping];
    
    [txtActionAmount setCenterVertically:YES];
    
    [txtActionAmount setAttributedText:attribString];
    
    
    [self customizeContactInformation];
    
    [self buildActionTableView];
    
    
    
    // on Wed, March 23, 2012 at 2:35pm
    //  on [0] at [1]
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *localTimezone = [NSTimeZone defaultTimeZone];
    [dateFormatter setTimeZone:localTimezone];
    
    // dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    
    dateFormatter.dateFormat = @"EEE, MMMM dd, yyyy";
    NSString*arg0 = [dateFormatter stringFromDate:messageDetail.createDate];
    
    dateFormatter.dateFormat = @"HH:mm a";
    
    NSString*arg1 = [dateFormatter stringFromDate:messageDetail.createDate];
    
    [dateFormatter release];
    
    [lblSentDate setText:[NSString stringWithFormat:@"on %@ at %@", arg0, arg1]];
    
    UILabel *titleView = (UILabel *)navBar.topItem.titleView;
    
    if ( !titleView ){
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:100.0 alpha:0.5];
        titleView.shadowOffset = CGSizeMake(0.0,1.5);
        
        //52.0 54.0 61.0 is the grey he wanted
        titleView.textColor = [UIColor colorWithRed:52.0/255.0 green:54.0/255.0 blue:61.0/255.0 alpha:1.0];
        
        navBar.topItem.titleView = titleView;
        titleView.text = @"";
    }
    
    
    
    UIImage *bgImage = [UIImage imageNamed:@"BTN-Nav-Back-61x30.png"];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [settingsBtn addTarget:self action:@selector(popViewControllerWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsButtons = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = settingsButtons;
    

    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"PayStreamDetailBaseViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}


-(void)customizeContactInformation
{
    
    if ( [messageDetail.direction isEqualToString:@"Out"] )
    {
        // Outgoing payment or donation
        // Left side should be [self] aka Sender
        txtSender.text = @"You";
        txtRecipient.text = messageDetail.recipientName;
        
        [btnSender  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:messageDetail.senderImageUri]]] forState:UIControlStateNormal];

        [btnRecipient  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:messageDetail.recipientImageUri]]] forState:UIControlStateNormal];

    }
    else
    {
        // Incoming event
        // The left side should display "You" or current user.
        txtRecipient.text = @"You";
        txtSender.text = messageDetail.senderName;
        
        [btnSender  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:messageDetail.senderImageUri]]] forState:UIControlStateNormal];
        
        [btnRecipient  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:messageDetail.recipientImageUri]]] forState:UIControlStateNormal];

    }
}

-(NSString*)determineActionString
{
    if ( [messageDetail.messageType isEqualToString:@"Payment"] )
    {
        return @"Sent";
    } else if ( [messageDetail.messageType isEqualToString:@"PaymentRequest"] )
    {
        return @"Requested";
    } else if ( [messageDetail.messageType isEqualToString:@"Donation"] )
    {
        return @"Donated";
    } else {
        return messageDetail.messageType;
    }
}

-(NSString*)determineToFromString
{
    if ( [messageDetail.messageType isEqualToString:@"Payment"] )
    {
        return @"to";
    } else if ( [messageDetail.messageType isEqualToString:@"PaymentRequest"] )
    {
        return @"from";
    } else if ( [messageDetail.messageType isEqualToString:@"Donation"] )
    {
        return @"to";
    } else {
        return messageDetail.messageType;
    }
}

-(void)popViewControllerWithAnimation {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelPaymentDidComplete {
    [self dismissModalViewControllerAnimated: YES];
    
    [self.navigationController popToRootViewControllerAnimated: YES];
}

-(void)cancelPaymentDidFail: (NSString*) message withErrorCode:(int)errorCode
{
    if(errorCode == 1001)
        [self dismissModalViewControllerAnimated: YES];
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Accepting Request"];
}
-(void)cancelPaymentRequestDidComplete
{
    [self dismissModalViewControllerAnimated: YES];
    
    [self.navigationController popToRootViewControllerAnimated: YES];
}

-(void)cancelPaymentRequestDidFail: (NSString*) message withErrorCode:(int)errorCode {
    if(errorCode == 1001)
        [self dismissModalViewControllerAnimated: YES];
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Accepting Request"];
}

-(void)acceptPaymentRequestDidComplete
{
    [self dismissModalViewControllerAnimated: YES];
    
    [self.navigationController popToRootViewControllerAnimated: YES];
}
-(void)acceptPaymentRequestDidFail: (NSString*) message withErrorCode:(int)errorCode {
    if(errorCode == 1001)
        [self dismissModalViewControllerAnimated: YES];
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Accepting Request"];
}
-(void)rejectPaymentRequestDidComplete
{    
    [self dismissModalViewControllerAnimated: YES];
    
    [self.navigationController popToRootViewControllerAnimated: YES];
}
-(void)rejectPaymentRequestDidFail: (NSString*) message withErrorCode:(int)errorCode {
    if(errorCode == 1001)
        [self dismissModalViewControllerAnimated: YES];
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Reject Request"];
}

- (void)viewDidUnload
{
    [detailTableView release];
    detailTableView = nil;
    
    [deliverySectionHeader release];
    deliverySectionHeader = nil;
    [rejectRequestCell release];
    rejectRequestCell = nil;
    [sendReminderCell release];
    sendReminderCell = nil;
    [acceptPayCell release];
    acceptPayCell = nil;
    [rejectButton release];
    rejectButton = nil;
    [remindButton release];
    remindButton = nil;
    [acceptButton release];
    acceptButton = nil;
    [expressDeliveryCell release];
    expressDeliveryCell = nil;
    [currentStatusButton release];
    currentStatusButton = nil;
    [statusCell release];
    statusCell = nil;
    [actionButtonsHeader release];
    actionButtonsHeader = nil;
    [deliveryStatusCell release];
    deliveryStatusCell = nil;
    [deliveryMethodButton release];
    deliveryMethodButton = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)btnCancelPaymentClicked
{
    pendingAction = @"CancelPayment";
    
    [self startSecurityPin];
}

-(void)btnAcceptRequestClicked {

    pendingAction = @"AcceptRequest";
    
    if([user.bankAccounts count] > 0)
    {
 
    // TODO: Change this to generic.
    CustomSecurityPinSwipeController* controller=[[CustomSecurityPinSwipeController alloc] init];
    [controller setSecurityPinSwipeDelegate: self];
    [controller setNavigationTitle: @"Confirm your Pin"];
    [controller setHeaderText:@"SWIPE YOUR PIN TO PAY REQUEST"];
    
    [[controller contactImageButton] setBackgroundImage:[self.btnSender backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    
    /*
     Custom Security Pin Swipe Controller Example
     -==============================================-
     
     recipientName = @"Ryan Ricigliano";
     deliveryCharge = 0.0;
     amount = 14.59;
     deliveryType = @"Express";
     headerText = @"SWIPE YOUR PIN TO CONFIRM PAYMENT";
     */
    
    [controller setDeliveryType:@"Standard"];
    [controller setDeliveryCharge:0.0];
    [controller setAmount:[messageDetail.amount doubleValue]];
    [controller setRecipientName:txtSender.text];
    
    [controller setTag:2];
    [self presentModalViewController:controller animated:YES];
    
    ///////////////////////////////////
    // Add the panel to our view
    //[self.view addSubview:securityPinModalPanel];
    //[parent.navigationController pushViewController: securityPinModalPanel animated:YES];
    }
    else {
        AddACHOptionsViewController* controller= [[AddACHOptionsViewController alloc] init];
        
        UINavigationController *navigationBar=[[UINavigationController alloc]initWithRootViewController:controller];
        
        [controller setAchSetupComplete:self];
        [self presentModalViewController: navigationBar animated:YES];
    }
}
-(void) btnSendReminderPaymentClicked:(id)sender {
    if([messageDetail.recipientUriType isEqualToString: @"MobileNumber"])
        [self openSMSComposer];
    else if([messageDetail.recipientUriType isEqualToString: @"EmailAddress"])
        [self openMailComposer];
}
-(void) openSMSComposer {
	MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
	
    if([MFMessageComposeViewController canSendText])
	{
        controller.title = @"Send Reminder";
		controller.body = @"You owe me money";
		controller.recipients = [NSArray arrayWithObjects:@"8043879693", nil];
		controller.messageComposeDelegate = self;
        
		[self presentModalViewController:controller animated:YES];
	}
}
- (IBAction)openMailComposer
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"A Message from PaidThx"];
        NSArray *toRecipients = [NSArray arrayWithObjects: messageDetail.recipientUri, nil];
        [mailer setToRecipients:toRecipients];
        //UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
        //NSData *imageData = UIImagePNGRepresentation(myImage);
        //[mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        NSString *emailBody = @"I sent you some money using PaidThx";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
        [mailer release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}
-(void) startSecurityPin
{
    GenericSecurityPinSwipeController *controller=[[[GenericSecurityPinSwipeController alloc] init] autorelease];
    [controller setSecurityPinSwipeDelegate: self];
    
    /*
     Custom Security Pin Swipe Controller Example
     -==============================================-
     
     recipientName = @"Ryan Ricigliano";
     deliveryCharge = 0.0;
     amount = 14.59;
     deliveryType = @"Express";
     lblHeader.text = @"SWIPE YOUR SECURITY PIN TO CONFIRM";
     */

    [controller setNavigationTitle: @"Confirm"];
    
    if(pendingAction == @"AcceptRequest") {
        [controller setHeaderText:@"SWIPE YOUR SECURITY PIN TO CONFIRM THAT YOU ACCEPT THE PAYMENT REQUEST"];
    }
    if(pendingAction == @"RejectRequest") {
        [controller setHeaderText:@"SWIPE YOUR SECURITY PIN TO CONFIRM THAT YOU REJECT THE PAYMENT REQUEST"];
    }
    if(pendingAction == @"CancelPayment") {
        [controller setHeaderText:@"SWIPE YOUR SECURITY PIN TO CONFIRM THAT YOU INTEND TO CANCEL THE PAYMENT"];
    }
    if(pendingAction == @"CancelRequest") {
        [controller setHeaderText:@"SWIPE YOUR SECURITY PIN TO CONFIRM THAT YOU INTEND TO CANCEL THE PAYMENT REQUEST"];
    }
    
    [self.navigationController presentModalViewController:controller animated:YES];
    
}

-(void)btnRejectRequestClicked
{
    pendingAction = @"RejectRequest";
    
    [self startSecurityPin];
}

-(void)btnCancelRequestClicked
{
    pendingAction = @"CancelRequest";
    
    [self startSecurityPin];
}

-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{
    if(pendingAction == @"AcceptRequest") {
        [paystreamServices acceptRequest:messageDetail.messageId withUserId:user.userId fromPaymentAccount:user.preferredReceiveAccountId withSecurityPin:pin];
    }
    if(pendingAction == @"RejectRequest") {
        [paystreamServices rejectRequest:messageDetail.messageId withUserId:user.userId withSecurityPin:pin];
    }
    if(pendingAction == @"CancelPayment") {
        [paystreamServices cancelPayment:messageDetail.messageId withUserId:user.userId withSecurityPin:pin];
    }
    if(pendingAction == @"CancelRequest") {
        [paystreamServices cancelRequest:messageDetail.messageId withUserId:user.userId withSecurityPin:pin];
    }
}

-(void)swipeDidCancel: (id)sender
{
    [self dismissModalViewControllerAnimated: YES];
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

-(void)achSetupDidComplete
{
    [self.navigationController dismissModalViewControllerAnimated:NO];

    user = [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) user];
    
    [self startSecurityPin];
}

-(void)achSetupDidFail:(NSString*) message withErrorCode:(int)errorCode
{
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Accepting Request"];
}

-(void) buildActionTableView
{
    // Reset Arrays
    [sections release];
    [actionTableData release];
    
    sections = [[NSMutableArray alloc] init];
    actionTableData = [[NSMutableDictionary alloc] init];
    
    
    // Initialize Status Section (Always Exists)
    [sections addObject:@"Status"];
    [actionTableData setValue:[[NSMutableArray alloc] initWithObjects:statusCell, nil] forKey:@"Status"];
    
    [currentStatusButton setTitle:messageDetail.messageStatus forState:UIControlStateNormal];
    
    
    // Delivery Section
    [sections addObject:@"DeliveryMethod"];
    [actionTableData setValue:[[NSMutableArray alloc] initWithObjects:deliveryStatusCell, nil] forKey:@"DeliveryMethod"];
    if ( messageDetail.deliveryMethod !=(id)[NSNull null] && messageDetail.deliveryMethod != NULL )
        [deliveryMethodButton setTitle:[NSString stringWithFormat:@"%@ Delivery",messageDetail.deliveryMethod] forState:UIControlStateNormal];
    else
        [deliveryMethodButton setTitle:@"Standard Delivery" forState:UIControlStateNormal];
    
    if ( messageDetail.isExpressable )
    {
        [self configureExpressView];
        
        // Display Cell (Add to list)
        [[actionTableData objectForKey:@"DeliveryMethod"] addObject:expressDeliveryCell];
        [deliveryMethodButton setUserInteractionEnabled:NO];
    }
    
    // Button actions
    // Create ActionButton Empty Array
    [sections addObject:@"ActionButtons"];
    [actionTableData setValue:[[NSMutableArray alloc] init] forKey:@"ActionButtons"];
    
    if([messageDetail.messageType isEqualToString: @"Payment"])
    {
        if([messageDetail.direction isEqualToString: @"Out"])
        {
            txtSender.text = @"You";
            txtRecipient.text = messageDetail.recipientName;
            
            if(messageDetail.isCancellable)
            {
                [[actionTableData objectForKey:@"ActionButtons"] addObject:rejectRequestCell];
                
                [rejectButton addTarget:self action:@selector(btnCancelPaymentClicked) forControlEvents:UIControlEventTouchUpInside];
                
                [rejectButton setTitle: @"Cancel Payment" forState:UIControlStateNormal];
            }
            if(messageDetail.isRemindable)
            {
                [[actionTableData objectForKey:@"ActionButtons"] addObject:sendReminderCell];
                
                [remindButton addTarget:self action:@selector(btnSendReminderPaymentClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else {
            txtSender.text = messageDetail.senderName;
            txtRecipient.text = @"You";
            
            // TODO: Fix Action/Amt Statement
        }
    }
    
    if([messageDetail.messageType isEqualToString: @"PaymentRequest"])
    {
        if([messageDetail.direction isEqualToString: @"In"])
        {
            txtSender.text = messageDetail.senderName;
            txtRecipient.text = @"You";
            
            // TODO: Fix Action/Amt Statement
            
            if(messageDetail.isAcceptable)
            {
                [[actionTableData objectForKey:@"ActionButtons"] addObject:acceptPayCell];
                
                [acceptButton addTarget:self action:@selector(btnAcceptRequestClicked) forControlEvents:UIControlEventTouchUpInside];
            }
            if(messageDetail.isRejectable)
            {
                [[actionTableData objectForKey:@"ActionButtons"] addObject:rejectRequestCell];
                
                [rejectButton addTarget:self action:@selector(btnRejectRequestClicked) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else if([messageDetail.direction isEqualToString: @"Out"]) {
            
            txtSender.text = @"You";
            txtRecipient.text = messageDetail.recipientName;
            
            // TODO: Fix Action/Amt Statement
            
            if(messageDetail.isCancellable)
            {
                [[actionTableData objectForKey:@"ActionButtons"] addObject:rejectRequestCell];
                
                [rejectButton addTarget:self action:@selector(btnCancelRequestClicked) forControlEvents:UIControlEventTouchUpInside];
                
                [rejectButton setTitle: @"Cancel Request" forState:UIControlStateNormal];
            }
            if(messageDetail.isRemindable)
            {
                [[actionTableData objectForKey:@"ActionButtons"] addObject:sendReminderCell];
                
                [remindButton addTarget:self action:@selector(btnSendReminderPaymentClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [remindButton setTitle:@"Send Reminder" forState:UIControlStateNormal];
            }
        }
    }
}


/*      Action Table View Functions         */
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section
{
    if ( [[sections objectAtIndex:section] isEqualToString:@"DeliveryMethod"] )
    {
        return 17.0;
    }
    else if ( [[sections objectAtIndex:section] isEqualToString:@"ActionButtons"] )
    {
        if ( [[actionTableData objectForKey:@"ActionButtons"] count] > 0 )
        {
            return 17.0;
        }
        else
        {
            return 0.0;
        }
    }
    
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((UITableViewCell*)[[actionTableData objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row]).frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( [[sections objectAtIndex:section] isEqualToString:@"DeliveryMethod"] )
    {
        return deliverySectionHeader;
    }
    else if ( [[sections objectAtIndex:section] isEqualToString:@"ActionButtons"] )
    {
        return actionButtonsHeader;
    }
    
    return [[[UIView alloc] init] autorelease];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[actionTableData objectForKey:[sections objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[actionTableData objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    if (cell == nil)
    {
        NSLog(@"Error loading cell for sec[%d] row[%d]",indexPath.section,indexPath.row);
    }
    
    return cell;
}
#pragma mark MessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
            [self dismissModalViewControllerAnimated:YES];
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow:self];
			break;
		case MessageComposeResultFailed:
            [self dismissModalViewControllerAnimated:YES];
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow:self];
			break;
		case MessageComposeResultSent:
            NSLog(@"Text Message Sent!");
            [self dismissModalViewControllerAnimated:YES];
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow:self];
			break;
		default:
			break;
	}
}
#pragma mark MailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}
@end
