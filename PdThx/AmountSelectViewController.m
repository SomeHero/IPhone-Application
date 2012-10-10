//
//  AmountSelectViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AmountSelectViewController.h"
#import "NSAttributedString+Attributes.h"

#define GO_DISABLED_TXTCOLOR_RED 142
#define GO_DISABLED_TXTCOLOR_GREEN 144
#define GO_DISABLED_TXTCOLOR_BLUE 151

#define GO_INACTIVE_TXTCOLOR [UIColor whiteColor]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AmountSelectViewController ()

@end

@implementation AmountSelectViewController

@synthesize amountChosenDelegate;
@synthesize lblGo;

@synthesize upperLimit;


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
    
    [goButton setEnabled:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
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
    
        
    return NO;
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

- (void)dealloc
{
    [amountDisplayLabel release];
    [goButton release];
    [quickAmount0 release];
    [quickAmount1 release];
    [quickAmount2 release];
    [quickAmount3 release];
    [super dealloc];
}

- (IBAction)amountChanged:(id)sender 
{
    
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
    else
    {
        [amountChosenDelegate didSelectAmount: amount withDeliveryOption:FALSE];
        
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
    
    [self formatGoButton];
}

- (IBAction)pressedQuickAmount2:(id)sender
{
    // $5
    NSString* strippedString = amountDisplayLabel.text;
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"$" withString:@""];
    strippedString = [strippedString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    double floatAmount = [strippedString doubleValue];
    floatAmount += 500;
    
    [amountDisplayLabel setText:[self createAmountStringFromDouble:floatAmount]];
    
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
