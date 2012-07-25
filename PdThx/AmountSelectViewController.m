//
//  AmountSelectViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AmountSelectViewController.h"

#define GO_DISABLED_TXTCOLOR_RED 142
#define GO_DISABLED_TXTCOLOR_GREEN 144
#define GO_DISABLED_TXTCOLOR_BLUE 151

#define GO_INACTIVE_TXTCOLOR [UIColor whiteColor]


@interface AmountSelectViewController ()

@end

@implementation AmountSelectViewController

@synthesize amountChosenDelegate;
@synthesize lblGo;

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
    // Do any additional setup after loading the view from its nib.
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"AmountSelectViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}
-(void)viewDidAppear:(BOOL)animated {
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    lblLimit.text = [NSString stringWithFormat: @"$%0.2f", [user.limit doubleValue]];
    
    [amountDisplayLabel becomeFirstResponder];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *tempAmount = [NSMutableString stringWithString:@""];
    [tempAmount appendString: @""];
    
    if([string isEqualToString:@""]) {
        for (int i = 0; i< [textField.text length] - 1; i++) {
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
        [tempAmount insertString: @"." atIndex: [tempAmount length] -2];
        if([tempAmount length] < 4)
            [tempAmount insertString:@"0" atIndex:0];
            
        if([tempAmount isEqualToString: @"0.00"])
        {
            [goButton setBackgroundImage: [UIImage imageNamed: @"btn-go-disabled-50x48.png"] forState:UIControlStateNormal];
            lblGo.textColor = [UIColor colorWithRed:142 green:144 blue:151 alpha:1.0];
            
            [goButton setEnabled:NO];
        }
        [textField setText:tempAmount];
        
    }
    else if([string stringByTrimmingCharactersInSet:
             [[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length > 0){
        
        BOOL firstDigit = YES;
        for (int i = 0; i< [textField.text length]; i++) {
            
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
            [tempAmount appendString: [NSString stringWithFormat:@"%c", digit]];
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

- (void)dealloc {
    
    [super dealloc];
    
    [amountDisplayLabel release];
    [goButton release];
    [quickAmount0 release];
    [quickAmount1 release];
    [quickAmount2 release];
    [quickAmount3 release];

}

- (IBAction)amountChanged:(id)sender 
{
    
}


- (IBAction)pressedGoButton:(id)sender
{
    [amountDisplayLabel resignFirstResponder];
    
    double upperLimit = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).getUpperLimit;
    
    double amount = [amountDisplayLabel.text doubleValue];
    
    if(amount > upperLimit) {
        [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) showAlertWithResult:false withTitle:@"Amount Exceeds the Upper Limit" withSubtitle: @"" withDetailText: [NSString stringWithFormat: @"The amount you entered exceeds the upper limit of $%0.2f.  Please reduce the amount to continue.", upperLimit]  withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Not shown" withRightButtonTitleColor:[UIColor clearColor] withDelegate:self];

    }
    else {
    
        [amountChosenDelegate didSelectAmount: amount];
    
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
    [amountChosenDelegate didSelectAmount:1.0];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pressedQuickAmount1:(id)sender {
    [amountChosenDelegate didSelectAmount:5.0];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pressedQuickAmount2:(id)sender {
    [amountChosenDelegate didSelectAmount:10.0];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pressedQuickAmount3:(id)sender {
    [amountChosenDelegate didSelectAmount:20.0];
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
