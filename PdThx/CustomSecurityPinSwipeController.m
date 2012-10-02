//
//  CustomSecurityPinSwipeController.m
//  PdThx
//
//  Created by James Rhodes on 6/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomSecurityPinSwipeController.h"
#import "NSAttributedString+Attributes.h"
#import "PdThxAppDelegate.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CustomSecurityPinSwipeController

@synthesize viewPinLock;
@synthesize navigationItem;
@synthesize securityPinSwipeDelegate;
@synthesize lblHeader, headerText;
@synthesize navigationTitle;

// New Customized Title
@synthesize toLabel, amountLabel, deliveryLabel;
@synthesize recipientName, amount, deliveryCharge, deliveryType;
@synthesize  expressIcon;

@synthesize tag;
@synthesize navigationBar;
@synthesize contactImageButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)unlockPatternView:(ALUnlockPatternView *)patternView selectedCode:(NSString *)code{
    securityPin = [NSString stringWithString:[code copy]];
    
    [securityPinSwipeDelegate swipeDidComplete:self withPin:securityPin];

}
- (void)dealloc
{
    [navigationBar release];
    [contactImageButton release];
    [expressIcon release];
    [lblHeader release];
    
    [viewPinLock release];
    [navigationItem release];
    [securityPinSwipeDelegate release];
    
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
    [self setTitle: navigationTitle];
    
    didCancel = false;
    
    ALUnlockPatternView *custom=[[[ALUnlockPatternView alloc] initWithFrame:CGRectMake(0, 0, viewPinLock.frame.size.width, viewPinLock.frame.size.height)] autorelease];
    custom.lineColor= UIColorFromRGB(0x47ba80);
    custom.lineWidth=15;
    custom.repeatSelection=YES;
    custom.radiusPercentage=10;
    custom.delegate=self;
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-70x70.png"] forState:UIControlStateNormal];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-selected-70x70.png"] forState:UIControlStateSelected];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-pressed-70x70.png"] forState:UIControlStateHighlighted];
    for (int i=0;i<[custom.cells count];i++) {
        UIButton* b=(UIButton*)[custom.cells objectAtIndex:i];        
        
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        //[b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        b.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        b.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    }
    
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-320x44.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    [contactImageButton.layer setCornerRadius:11.0];
    [contactImageButton.layer setMasksToBounds:YES];
    [contactImageButton.layer setBorderWidth:0.2];
    [contactImageButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    [self.viewPinLock addSubview:custom];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"CustomSecurityPinSwipeController"
                                        withError:&error]){
        //Handle Error Here
    }

    //[self.view addSubview: header];
    //[self.view addSubview:body];
}

-(void)viewWillAppear:(BOOL)animated
{
    /* 
       Custom Security Pin Swipe Controller Example
     -==============================================-
     
     recipientName = @"Ryan Ricigliano";
     deliveryCharge = 0.0;
     amount = 14.59;
     deliveryType = @"Express";
     lblHeader.text = @"SWIPE YOUR SECURITY PIN TO CONFIRM";
     */
    
    id blueColor = UIColorFromRGB(0x015b7e);
    id grayColor = UIColorFromRGB(0x33363d);
    id greenColor = UIColorFromRGB(0x00a652);
    
    id helvBoldFont = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    
    // Dark Grey Color for "To:/Amount:/Delivery:" => 0x33363d
    NSMutableAttributedString*recipientAttribString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"To: %@",recipientName]];
    
    [recipientAttribString setTextColor:grayColor];
    [recipientAttribString setTextColor:[UIColor blackColor] range:[recipientAttribString rangeOfString:recipientName]];
    [recipientAttribString setFont:helvBoldFont];
    
    // Done with Recipient Label, set it.
    [toLabel setAttributedText:recipientAttribString];
    
    // Amount Label, simple Amount: $x.xx
    NSString*highlightedAmountString = [NSString stringWithFormat:@"$%0.2f",amount];
    
    NSMutableAttributedString*amountAttribString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Amount: %@",highlightedAmountString]];
    [amountAttribString setTextColor:grayColor];
    [amountAttribString setTextColor:blueColor range:[amountAttribString rangeOfString:highlightedAmountString]];
    [amountAttribString setFont:helvBoldFont];
    
    [amountLabel setAttributedText:amountAttribString];
    
    NSMutableAttributedString*deliveryChargeAttribString;
    if ( deliveryCharge == 0.0 )
    {
        // Free Delivery - Standard
        // Colors:
        // FREE in Green 0x00a652
        NSString*highlightedDeliveryChargeString = [NSString stringWithFormat:@"FREE"];
        
        deliveryChargeAttribString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Delivery: %@ (%@)", deliveryType, highlightedDeliveryChargeString]];
        
        [expressIcon setHidden:YES];
        [deliveryChargeAttribString setTextColor:grayColor];
        [deliveryChargeAttribString setTextColor:greenColor range:[deliveryChargeAttribString rangeOfString:highlightedDeliveryChargeString]];
    }
    else
    {
        // Express Delivery, There's a charge.
        // Blue Color: 0x015b7e
        NSString*highlightedDeliveryChargeString = [NSString stringWithFormat:@"$%0.2f",deliveryCharge];
        
        deliveryChargeAttribString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Delivery: %@     (%@)",deliveryType,highlightedDeliveryChargeString]];
        
        [expressIcon setHidden:NO];
        [deliveryChargeAttribString setTextColor:grayColor];
        [deliveryChargeAttribString setTextColor:blueColor range:[deliveryChargeAttribString rangeOfString:highlightedDeliveryChargeString]];
        [deliveryChargeAttribString setTextColor:blueColor range:[deliveryChargeAttribString rangeOfString:deliveryType]];
    }
    
    [deliveryChargeAttribString setFont:helvBoldFont];
    [deliveryLabel setAttributedText:deliveryChargeAttribString];
    
    //NSMutableAttributedString* deliveryString = [NSMutableAttributedString attributedStringWithString:[NSString stringWithFormat:@"Delivery: %@          %@%@%@", deliveryTypeAttrib, openParen,amountAttrib, closeParen]];
    
    UIImage *bgImage = [UIImage imageNamed:@"BTN-Nav-Cancel-68x30.png"];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    
    [settingsBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
}

-(void)cancelClicked
{
    [securityPinSwipeDelegate swipeDidCancel:self];
}

- (void)viewDidUnload
{
    [navigationBar release];
    navigationBar = nil;
    [contactImageButton release];
    contactImageButton = nil;
    [expressIcon release];
    expressIcon = nil;
    [lblHeader release];
    lblHeader = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
