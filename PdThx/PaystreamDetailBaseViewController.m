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
@synthesize lblCurrentStatusHeader, lblWhatsNextStatusHeader;
@synthesize btnSender, btnRecipient, btnCurrentStatus;
@synthesize lblSentDate;
@synthesize quoteView;
@synthesize actionView;
@synthesize actionViewDivider;
@synthesize pullableView;
@synthesize parent;

@synthesize expressDeliveryButton, expressDeliveryCharge, expressDeliveryChargeLabel, expressDeliveryText, expressSubtext, isExpressed;

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
    [actionViewDivider release];
    [expressSubtext release];
    [expressDeliveryChargeLabel release];
    [expressDeliveryButton release];
    [expressDeliveryText release];
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
                [expressSubtext setText:@"Get it faster!"];
            } else {
                [expressSubtext setText:@"Send it expressed!"];
            }
            
            [expressDeliveryButton setEnabled:YES];
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
            
            [expressSubtext setText:@"Not available"];
            
            [expressDeliveryButton setEnabled:NO];
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
    [expressDeliveryChargeLabel setCenterVertically:YES];
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
    
    [lblCurrentStatusHeader setBackgroundColor: UIColorFromRGB(0x6D6E71)];
    [lblCurrentStatusHeader setTextColor: UIColorFromRGB(0xFFFFFF)];
    
    [btnCurrentStatus setTitleColor:UIColorFromRGB(0xc56d0c) forState: UIControlStateNormal];
    
    [lblWhatsNextStatusHeader setBackgroundColor: UIColorFromRGB(0x6D6E71)];
    [lblWhatsNextStatusHeader setTextColor: UIColorFromRGB(0xE8E8E8)];
    
    actionView.backgroundColor = [UIColor whiteColor];
    actionViewDivider.backgroundColor = UIColorFromRGB(0xc1c1c1);
    
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

    UIImage* redBackgroundNormal = [UIImage imageNamed: @"btn-psdetail-red-267x40.png"];
    UIImage* redBackgroundActive = [UIImage imageNamed: @"btn-psdetail-red-267x40-active.png"];
    UIImage* greenBackgroundNormal = [UIImage imageNamed: @"btn-psdetail-green-267x40.png"];
    UIImage* greenBackgroundActive = [UIImage imageNamed: @"btn-psdetail-green-267x40-active.png"];
    
    paystreamServices = [[PaystreamService alloc] init];
    
    [paystreamServices setCancelPaymentProtocol: self];
    [paystreamServices setCancePaymentRequestProtocol: self];
    [paystreamServices setAcceptPaymentRequestProtocol: self];
    [paystreamServices setRejectPaymentRequestProtocol: self];

    txtSender.text = @"You"; // Constant Sender (You) on left side.
    
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
    
    // Pushing the buttons down 10px
    yPos += 5;
    if([messageDetail.messageType isEqualToString: @"Payment"]) {
        if([messageDetail.direction isEqualToString: @"Out"]) { 
            txtSender.text = @"You";
            txtRecipient.text = messageDetail.recipientName;
            
            // TODO: Fix Action/Amt Statement
            
            if(messageDetail.isCancellable)
            {
                UIButton* btnCancelPayment = [[UIButton alloc] initWithFrame:CGRectMake(15/2, yPos, (actionView.frame.size.width - 15), 40)];
                
                [btnCancelPayment setBackgroundImage: redBackgroundNormal forState:UIControlStateNormal];
                [btnCancelPayment setBackgroundImage: redBackgroundActive forState:UIControlStateSelected];
                [btnCancelPayment setTitle: @"Cancel Payment" forState:UIControlStateNormal];
                [btnCancelPayment setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                [btnCancelPayment addTarget:self action:@selector(btnCancelPaymentClicked) forControlEvents:UIControlEventTouchUpInside];
                [actionView addSubview:btnCancelPayment];
                
                [btnCancelPayment release];
                
                yPos = yPos + btnCancelPayment.frame.size.height + 5;
            }
            if(messageDetail.isRemindable) {
                UIButton* btnSendReminder = [[UIButton alloc] initWithFrame:CGRectMake(15/2, yPos, (actionView.frame.size.width - 15), 40)];
                
                [btnSendReminder setBackgroundImage: greenBackgroundNormal forState:UIControlStateNormal];
                [btnSendReminder setBackgroundImage: greenBackgroundActive forState:UIControlStateSelected];
                [btnSendReminder setTitle: @"Send a Reminder" forState:UIControlStateNormal];
                [btnSendReminder setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                [btnSendReminder addTarget:self action:@selector(btnSendReminderPaymentClicked) forControlEvents:UIControlEventTouchUpInside];
                
                [actionView addSubview:btnSendReminder];
                
                [btnSendReminder release];
                
                yPos = yPos + btnSendReminder.frame.size.height + 5;
            }
        }
        else {
            txtSender.text = messageDetail.senderName;
            txtRecipient.text = @"You";
            
            // TODO: Fix Action/Amt Statement
        }
    }
    if([messageDetail.messageType isEqualToString: @"PaymentRequest"]) {
        
        if([messageDetail.direction isEqualToString: @"In"])
        {
            txtSender.text = messageDetail.senderName;
            txtRecipient.text = @"You";
            
            // TODO: Fix Action/Amt Statement
            
            if(messageDetail.isAcceptable) {
                UIButton* btnAcceptRequest = [[UIButton alloc] initWithFrame:CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40)];
                
                [btnAcceptRequest setBackgroundImage: greenBackgroundNormal forState:UIControlStateNormal];
                [btnAcceptRequest setBackgroundImage: greenBackgroundActive forState:UIControlStateSelected];
                [btnAcceptRequest setTitle: @"Accept & Pay" forState:UIControlStateNormal];
                [btnAcceptRequest setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                [btnAcceptRequest addTarget:self action:@selector(btnAcceptRequestClicked) forControlEvents:UIControlEventTouchUpInside];
                
                [actionView addSubview:btnAcceptRequest];
                
                [btnAcceptRequest release];
                
                yPos = yPos + btnAcceptRequest.frame.size.height + 5;
            }
            if(messageDetail.isRejectable) {
                UIButton* btnRejectRequest = [[UIButton alloc] initWithFrame:CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40)];
                
                [btnRejectRequest setBackgroundImage: redBackgroundNormal forState:UIControlStateNormal];
                [btnRejectRequest setBackgroundImage: redBackgroundActive forState:UIControlStateSelected];
                [btnRejectRequest setTitle: @"Reject Request" forState:UIControlStateNormal];
                [btnRejectRequest setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                [btnRejectRequest addTarget:self action:@selector(btnRejectRequestClicked) forControlEvents:UIControlEventTouchUpInside];
                [actionView addSubview:btnRejectRequest];
                
                [btnRejectRequest release];
                
                yPos = yPos + btnRejectRequest.frame.size.height + 5;
            }
        }
        else if([messageDetail.direction isEqualToString: @"Out"]) {

            txtSender.text = @"You";
            txtRecipient.text = messageDetail.recipientName;
            
            // TODO: Fix Action/Amt Statement
            
            if(messageDetail.isCancellable) {
               
                UIButton* btnCancelRequest = [[UIButton alloc] initWithFrame:CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40)];
            
                [btnCancelRequest setBackgroundImage: redBackgroundNormal forState:UIControlStateNormal];
                [btnCancelRequest setBackgroundImage: redBackgroundActive forState:UIControlStateSelected];
                [btnCancelRequest setTitle: @"Cancel Request" forState:UIControlStateNormal];
                [btnCancelRequest setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                [btnCancelRequest addTarget:self action:@selector(btnCancelRequestClicked) forControlEvents:UIControlEventTouchUpInside];
                
                [actionView addSubview:btnCancelRequest];
                
                [btnCancelRequest release];
                
                yPos = yPos + btnCancelRequest.frame.size.height + 5;
            }
            if(messageDetail.isRemindable) {
                UIButton* btnSendReminder = [[UIButton alloc] initWithFrame:CGRectMake(5, yPos, (actionView.frame.size.width - 15), 40)];
                
                [btnSendReminder setBackgroundImage: greenBackgroundNormal forState:UIControlStateNormal];
                [btnSendReminder setBackgroundImage: greenBackgroundActive forState:UIControlStateSelected];
                [btnSendReminder setTitle: @"Send a Reminder" forState:UIControlStateNormal];
                [btnSendReminder setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                [btnSendReminder addTarget:self action:@selector(btnSendReminderPaymentClicked) forControlEvents:UIControlEventTouchUpInside];
                
                
                [actionView addSubview:btnSendReminder];
                
                [btnSendReminder release];
                
                yPos = yPos + btnSendReminder.frame.size.height + 5;
            }
        }
    }
    
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
    
    /* ---------------------------------------------------- */
    /*      Custom Settings Button Implementation           */
    /* ---------------------------------------------------- 
    
     This section was commented out when we moved away from the pullable detail view.
     
    UIImage *bgImage = [UIImage imageNamed:@"BTN-Nav-X-35x30.png"];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, 35, 30);
    [settingsBtn addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsButtons = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    
    navBar.topItem.leftBarButtonItem = settingsButtons;
    [settingsButtons release];
     */
    
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
        
        if ( user.imageUrl != (id)[NSNull null] && user.imageUrl.length > 0 )
        {
            [btnSender setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.imageUrl]]] forState:UIControlStateNormal];
        } else {
            [btnSender setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
        }
        
        if ( messageDetail.imgData != (id)[NSNull null] )
        {
            [btnRecipient setBackgroundImage:messageDetail.imgData forState:UIControlStateNormal];
        } else {
            [btnRecipient setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        // Incoming event
        // The left side should display "You" or current user.
        txtRecipient.text = @"You";
        txtSender.text = messageDetail.senderName;
        
        if ( user.imageUrl != (id)[NSNull null] && user.imageUrl.length > 0 )
        {
            [btnRecipient setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.imageUrl]]] forState:UIControlStateNormal];
        } else {
            [btnRecipient setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
        }
        
        if ( messageDetail.imgData != nil && messageDetail.imgData != NULL )
        {
            [btnSender setBackgroundImage:messageDetail.imgData forState:UIControlStateNormal];
        } else {
            [btnSender setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
        }
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
    [self setActionViewDivider:nil];
    [expressSubtext release];
    expressSubtext = nil;
    [expressDeliveryChargeLabel release];
    expressDeliveryChargeLabel = nil;
    [expressDeliveryButton release];
    expressDeliveryButton = nil;
    [expressDeliveryText release];
    expressDeliveryText = nil;
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
    [controller setHeaderText:@"SWIPE YOUR SECURITY PIN TO CONFIRM CHANGES YOUR INTENT TO DELETE THIS PAYMENT ACCOUNT"];
    
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


-(void)achSetupDidComplete {
    [self.navigationController dismissModalViewControllerAnimated:NO];

    user = [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) user];
    
    [self startSecurityPin];
}

-(void)userACHSetupDidFail:(NSString*) message withErrorCode:(int)errorCode
{
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Accepting Request"];
}

@end
