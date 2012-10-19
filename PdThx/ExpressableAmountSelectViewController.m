//
//  AmountSelectViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExpressableAmountSelectViewController.h"
#import "NSAttributedString+Attributes.h"

#define GO_DISABLED_TXTCOLOR_RED 142
#define GO_DISABLED_TXTCOLOR_GREEN 144
#define GO_DISABLED_TXTCOLOR_BLUE 151

#define GO_INACTIVE_TXTCOLOR [UIColor whiteColor]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ExpressableAmountSelectViewController ()

@end

@implementation ExpressableAmountSelectViewController

@synthesize amountChosenDelegate;
@synthesize lblGo;

@synthesize upperLimit;

// Express Stuff
@synthesize canExpress, expressChargeLabel, expressDeliveryRate, addExpressDeliveryButton, expressDeliveryFreeThreshold, isExpressed, amountExpressChargeLabel;

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
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    ApplicationConfiguration*appConfig = [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).myApplication.applicationSettings objectForKey:@"UpperLimit"];
    
    
    if ( [appConfig.ConfigurationValue doubleValue] <= 0.0 )
        upperLimit = [appConfig.ConfigurationValue doubleValue];
    else
        upperLimit = 1000.0;
    
    
    // Do any additional setup after loading the view from its nib.
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"AmountSelectViewController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    NSLog(@"Setting canExpress to %@", user.canExpress ? @"YES" : @"NO" );
    
    canExpress = user.canExpress;
    expressDeliveryRate = user.expressDeliveryFeePercentage;
    expressDeliveryFreeThreshold = user.expressDeliveryThreshold;
    
    [goButton setEnabled:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ( canExpress )
    {
        [self enableExpressedDelivery];
    } else {
        [amountExpressChargeLabel setText:@"N/A"];
    }
    
    [amountExpressChargeLabel setText:@""];
    
    [amountDisplayLabel becomeFirstResponder];
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [amountDisplayLabel release];
    amountDisplayLabel = nil;
    [goButton release];
    goButton = nil;
    [quickAmount0 release];
    quickAmount0 = nil;
    [quickAmount0 release];
    quickAmount1 = nil;
    [quickAmount1 release];
    quickAmount2 = nil;
    [quickAmount3 release];
    quickAmount3 = nil;
    
    [addExpressDeliveryButton release];
    addExpressDeliveryButton = nil;
    
    [expressChargeLabel release];
    expressChargeLabel = nil;
    
    [amountExpressChargeLabel release];
    amountExpressChargeLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self pressedGoButton:self];
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* oldString = textField.text;
    
    NSMutableString *tempAmount = [NSMutableString stringWithString:@""];
    [tempAmount appendString: @""];
    
    
    if([string isEqualToString:@""])
    {
        for (int i = 0; i< [textField.text length] - 1; i++)
        {
            if([string length] == 0 && i == [textField.text length] - 1)
                continue;
            
            char digit = (char) [textField.text characterAtIndex: (NSUInteger)i];
            
            if(digit == '$')
                continue;
            if(digit == '.')
                continue;
            
            [tempAmount appendString: [NSString stringWithFormat:@"%c", digit]];
        }
        
        [tempAmount appendString: string];
        [tempAmount insertString: @"." atIndex: [tempAmount length]-2];
        
        if([tempAmount length] < 4)
            [tempAmount insertString:@"0" atIndex:0];
        
        [goButton setEnabled:YES];
        if([tempAmount isEqualToString: @"0.00"])
        {
            [goButton setBackgroundImage: [UIImage imageNamed: @"btn-go-disabled-50x48.png"] forState:UIControlStateNormal];
            lblGo.textColor = [UIColor colorWithRed:142 green:144 blue:151 alpha:1.0];
            
            [goButton setEnabled:NO];
        }
        
        [textField setText:tempAmount];
        
    }
    else if([string stringByTrimmingCharactersInSet:
             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length > 0)
    {
        BOOL firstDigit = YES;
        
        for (int i = 0; i< [textField.text length]; i++)
        {
            char digit = (char) [textField.text characterAtIndex: (NSUInteger)i];
            
            if(digit == '$')
                continue;
            if(digit == '.')
                continue;
            if(digit == '0' && firstDigit) {
                firstDigit = NO;
                continue;
            }
            
            firstDigit = NO;
            [tempAmount appendString:[NSString stringWithFormat:@"%c", digit]];
        }
        
        [tempAmount appendString: string];
        [tempAmount insertString: @"." atIndex: [tempAmount length] -2];
        
        if([tempAmount length] < 4)
            [tempAmount insertString:@"0" atIndex:0];
        
        [textField setText:tempAmount];
        
        [goButton setBackgroundImage: [UIImage imageNamed: @"btn-go-active-50x48.png"] forState:UIControlStateNormal];
        lblGo.textColor = [UIColor whiteColor];
        lblGo.alpha = 1.0;
        
        [goButton setEnabled:YES];
        if([textField.text isEqualToString:@"0.00"])
        {
            [goButton setBackgroundImage: [UIImage imageNamed: @"btn-go-inactive-50x48.png"] forState:UIControlStateNormal];
            lblGo.textColor = [UIColor colorWithRed:142 green:144 blue:151 alpha:1.0];
            
            [goButton setEnabled:NO];
        }
    }
    
    [self adjustExpressDeliveryCharge:textField];
    
    if ( [textField.text doubleValue] > expressDeliveryFreeThreshold && [oldString doubleValue] <= expressDeliveryFreeThreshold )
    {
        // The amount to send increased to be OVER
        // The free threshold. Reset the button.
        NSLog(@"Removing expressed delivery because going over the free threshold");
        [self removeExpressedDelivery];
    }
    
    return NO;
}

-(void)removeExpressedDelivery
{
    UIImage*standardDeliveryImage = [UIImage imageNamed:@"btn-express-43x40.png"];
    
    [addExpressDeliveryButton setBackgroundImage:standardDeliveryImage forState:UIControlStateNormal];
    [addExpressDeliveryButton setBackgroundImage:standardDeliveryImage forState:UIControlStateSelected];
    
    [amountExpressChargeLabel setHidden:YES];
    
    isExpressed = NO;
}

-(void)adjustExpressDeliveryCharge:(UITextField*)txtField
{
    id blueColor = UIColorFromRGB(0x015b7e);
    id greenColor = UIColorFromRGB(0x00a652);
    id grayColor = UIColorFromRGB(0x33363d);
    
    double transactionAmount = [txtField.text doubleValue];
    
    // What are the cases this is called?
    // Can Express?
    // isExpressed?
    // isFree?
    
    if ( canExpress )
    {
        if ( transactionAmount <= expressDeliveryFreeThreshold )
        {
            // Free Express Delivery
            if ( ! isExpressed ) {
                [self enableExpressedDelivery];
            } else {
                // Is already expressed, but not free.
                // Set to FREE express, because
                // its now lower than the threshold.
                NSMutableAttributedString*freeAttrib = [[NSMutableAttributedString alloc] initWithString:@"(FREE)"];
                [freeAttrib setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
                
                [freeAttrib setTextColor:grayColor];
                [freeAttrib setTextColor:greenColor range:[freeAttrib rangeOfString:@"FREE"]];
                [expressChargeLabel setAttributedText:freeAttrib];
                [amountExpressChargeLabel setText:@""];
                [freeAttrib release];
            }
        }
        else
        {
            // Paid Express Delivery
            // Update Labels...
            
            NSString* deliveryChargeString = [NSString stringWithFormat:@"+ $%0.2f",transactionAmount*expressDeliveryRate];
            
            NSMutableAttributedString*chargeAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)",deliveryChargeString]];
            
            [chargeAttrib setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
            [chargeAttrib setTextColor:grayColor];
            [chargeAttrib setTextColor:blueColor range:[chargeAttrib rangeOfString:deliveryChargeString]];
            
            [expressChargeLabel setAttributedText:chargeAttrib];
            
            [amountExpressChargeLabel setAttributedText:[chargeAttrib attributedSubstringFromRange:[chargeAttrib rangeOfString:deliveryChargeString]]];
            
            [chargeAttrib release];
        }
    }
    else
    {
        NSLog(@"Not allowed to express.");
        
        [addExpressDeliveryButton setEnabled:NO];
        
        [expressChargeLabel setText:@"N/A"];
        [expressChargeLabel setEnabled:NO];
    }
}

-(void)enableExpressedDelivery
{
    NSLog(@"Enabling express delivery.");
    
    id blueColor = UIColorFromRGB(0x015b7e);
    id greenColor = UIColorFromRGB(0x00a652);
    id grayColor = UIColorFromRGB(0x33363d);
    
    UIImage* enabledImage = [UIImage imageNamed:@"btn-express-43x40-active.png"];
    
    double transactionAmount = [amountDisplayLabel.text doubleValue];
    
    isExpressed = YES;
    [addExpressDeliveryButton setEnabled:YES];
    [amountExpressChargeLabel setHidden:NO];
    
    [addExpressDeliveryButton setBackgroundImage:enabledImage forState:UIControlStateNormal];
    [addExpressDeliveryButton setBackgroundImage:enabledImage forState:UIControlStateSelected];
    
    if ( transactionAmount < expressDeliveryFreeThreshold )
    {
        // Set green color FREE
        NSMutableAttributedString*freeAttrib = [[NSMutableAttributedString alloc] initWithString:@"(FREE)"];
        [freeAttrib setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
        
        [freeAttrib setTextColor:grayColor];
        [freeAttrib setTextColor:greenColor range:[freeAttrib rangeOfString:@"FREE"]];
        [expressChargeLabel setAttributedText:freeAttrib];
        
        [amountExpressChargeLabel setText:@""];
        [freeAttrib release];
    }
    else
    {
        // Set green color FREE
        NSString* deliveryChargeString = [NSString stringWithFormat:@"+ $%0.2f",transactionAmount*expressDeliveryRate];
        
        NSMutableAttributedString*chargeAttrib = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%@)",deliveryChargeString]];
        
        [chargeAttrib setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
        [chargeAttrib setTextColor:grayColor];
        [chargeAttrib setTextColor:blueColor range:[chargeAttrib rangeOfString:deliveryChargeString]];
        
        [expressChargeLabel setAttributedText:chargeAttrib];
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
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        //52.0 54.0 61.0 is the grey he wanted
        titleView.textColor = [UIColor colorWithRed:52.0/255.0 green:54.0/255.0 blue:61.0/255.0 alpha:1.0];
        
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    
    titleView.text = title;
    [titleView sizeToFit];
}

- (void)dealloc {
    
    [addExpressDeliveryButton release];
    [expressChargeLabel release];
    [amountExpressChargeLabel release];
    [super dealloc];
    
    [amountDisplayLabel release];
    [goButton release];
    [quickAmount0 release];
    [quickAmount1 release];
    [quickAmount2 release];
    [quickAmount3 release];
    
}


- (IBAction)pressedGoButton:(id)sender
{
    [amountDisplayLabel resignFirstResponder];
    
    upperLimit = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).getUpperLimit;
    
    double amount = [amountDisplayLabel.text doubleValue];
    
    if(amount > upperLimit)
    {
        [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) showAlertWithResult:false withTitle:@"Amount Exceeds the Upper Limit" withSubtitle: @"" withDetailText: [NSString stringWithFormat: @"The amount you entered exceeds the upper limit of $%0.2f.  Please reduce the amount to continue.", upperLimit]  withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Not shown" withRightButtonTitleColor:[UIColor clearColor]  withTextFieldPlaceholderText: @"" withDelegate:self];
        
    }
    else {
        
        [amountChosenDelegate didSelectAmount: amount withDeliveryOption:isExpressed];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)didSelectButtonWithIndex:(int)index
{
    // Dismiss, error uploading image alert view clicked.
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate dismissAlertView];
    [amountDisplayLabel becomeFirstResponder];
    
}
- (IBAction)pressedQuickAmount0:(id)sender {
    // $20
    
    NSString* strippedString = amountDisplayLabel.text;
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    double floatAmount = [strippedString doubleValue];
    floatAmount += 2000;
    
    [amountDisplayLabel setText:[self createAmountStringFromDouble:floatAmount]];
    
    [self adjustExpressDeliveryCharge:amountDisplayLabel];
    [self formatGoButton];
}

- (IBAction)pressedQuickAmount1:(id)sender
{
    // $10
    NSString* strippedString = amountDisplayLabel.text;
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    double floatAmount = [strippedString doubleValue];
    floatAmount += 1000;
    
    [amountDisplayLabel setText:[self createAmountStringFromDouble:floatAmount]];
    
    [self adjustExpressDeliveryCharge:amountDisplayLabel];
    [self formatGoButton];
}

- (IBAction)pressedQuickAmount2:(id)sender {
    // $5
    NSString* strippedString = amountDisplayLabel.text;
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    double floatAmount = [strippedString doubleValue];
    floatAmount += 500;
    
    [amountDisplayLabel setText:[self createAmountStringFromDouble:floatAmount]];
    
    [self adjustExpressDeliveryCharge:amountDisplayLabel];
    [self formatGoButton];
}
- (IBAction)pressedQuickAmount3:(id)sender {
    // $1
    NSString* strippedString = amountDisplayLabel.text;
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    double floatAmount = [strippedString doubleValue];
    floatAmount += 100;
    
    [amountDisplayLabel setText:[self createAmountStringFromDouble:floatAmount]];
    
    [self adjustExpressDeliveryCharge:amountDisplayLabel];
    [self formatGoButton];
}

- (IBAction)pressedAddExpressDelivery:(id)sender
{
    if ( isExpressed )
    {
        [self removeExpressedDelivery];
    } else {
        if ( canExpress )
            [self enableExpressedDelivery];
    }
    
    [self formatGoButton];
}

-(void)formatGoButton
{
    if([amountDisplayLabel.text isEqualToString:@"0.00"])
    {
        [goButton setBackgroundImage: [UIImage imageNamed: @"btn-go-inactive-50x48.png"] forState:UIControlStateNormal];
        lblGo.textColor = [UIColor colorWithRed:142 green:144 blue:151 alpha:1.0];
        [goButton setEnabled:NO];
    }
    else
    {
        [goButton setEnabled:YES];
        [goButton setBackgroundImage: [UIImage imageNamed: @"btn-go-active-50x48.png"] forState:UIControlStateNormal];
        lblGo.textColor = [UIColor whiteColor];
        lblGo.alpha = 1.0;
    }
}

-(NSString*)createAmountStringFromDouble:(double)floatAmt
{
    return [NSString stringWithFormat:@"%0.2f",floatAmt/100];
}

@end
