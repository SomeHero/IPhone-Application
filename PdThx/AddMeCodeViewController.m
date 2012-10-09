//
//  AddMeCodeViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//#import "PdThxAppDelegate.m"
#import "AddMeCodeViewController.h"

@interface AddMeCodeViewController ()

@end

@implementation AddMeCodeViewController

@synthesize addPayPointComplete;

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
    payPointService = [[PayPointService alloc] init];
    [payPointService setAddPayPointCompleteDelegate:self];
    
    [txtMeCode becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)btnSubmitClicked {
    if([txtMeCode.text length] < 4  || [txtMeCode.text rangeOfString:@"~"].location != NSNotFound || [[txtMeCode.text substringFromIndex:1] rangeOfString:@"$"].location != NSNotFound || [txtMeCode.text rangeOfString:@"`"].location != NSNotFound || [txtMeCode.text rangeOfString:@"!"].location != NSNotFound || [txtMeCode.text rangeOfString:@"@"].location != NSNotFound || [txtMeCode.text rangeOfString:@"#"].location != NSNotFound || [txtMeCode.text rangeOfString:@"%"].location != NSNotFound || [txtMeCode.text rangeOfString:@"^"].location != NSNotFound || [txtMeCode.text rangeOfString:@"&"].location != NSNotFound || [txtMeCode.text rangeOfString:@"*"].location != NSNotFound || [txtMeCode.text rangeOfString:@"("].location != NSNotFound || [txtMeCode.text rangeOfString:@")"].location != NSNotFound || [txtMeCode.text rangeOfString:@"_"].location != NSNotFound || [txtMeCode.text rangeOfString:@"-"].location != NSNotFound || [txtMeCode.text rangeOfString:@"="].location != NSNotFound || [txtMeCode.text rangeOfString:@"+"].location != NSNotFound)
    {
        [txtMeCode resignFirstResponder];
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
        // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
        // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
        // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
        [appDelegate showAlertWithResult:false withTitle:@"Invalid MeCode" withSubtitle:@"Error Creating MeCode" withDetailText:@"MeCode isn't sufficient length or has invalid characters" withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Not shown" withRightButtonTitleColor:[UIColor clearColor] withTextFieldPlaceholderText: @"" withDelegate:self];
    }
    else {
        
        [txtMeCode resignFirstResponder];
        
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus: @"Linking MeCode" withDetailedStatus: @"Adding New PayPoint"];
        
        [payPointService addPayPoint:txtMeCode.text ofType:@"MeCode" forUserId: user.userId];
    }
    
}

-(void)didSelectButtonWithIndex:(int)index
{
    if ( index == 0 ) {
        // Dismiss, error MeCode invalid
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
    } else {
        // Successfully saved image, just go back to personalize screen and load the image.
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        
        // TODO: There needs to be a protocol here to load the image as being on top.
    }
}

-(bool)CharacterAllowedAtIndex:(NSString*)stringChar atIndex:(int)index
{
    if ( [stringChar isEqualToString:@"$"] && index == 0 )
        return true;
    else
    {
        // Check if the character is in an allowed character set.
        if ( [stringChar rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet] options:NSCaseInsensitiveSearch].location == NSNotFound )
            return false;
    }
    
    return true;
}

-(void)addPayPointsDidComplete:(NSString*)payPointId {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [appDelegate dismissProgressHUD];
        
        [addPayPointComplete addPayPointsDidComplete: payPointId];
    });
    
}

-(void)addPayPointsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [appDelegate dismissProgressHUD];
        
        [appDelegate showSimpleAlertView: NO withTitle:@"Failed" withSubtitle: @"Unable to Link Pay Point" withDetailedText: errorMessage  withButtonText: @"Try Again" withDelegate:self];
        
    });
    
}
- (IBAction)meCodeChange:(id) sender {
    
    if ( [txtMeCode.text length] > 0 ){
        if ( ![self CharacterAllowedAtIndex:[NSString stringWithFormat:@"%c",[txtMeCode.text characterAtIndex:txtMeCode.text.length-1]] atIndex:(txtMeCode.text.length-1)] )
            txtMeCode.text = [txtMeCode.text substringToIndex:txtMeCode.text.length-1];
        
        if ( [txtMeCode.text length] > 0 ){
            if ( [txtMeCode.text characterAtIndex:0] != '$' )
                [txtMeCode setText:[NSString stringWithFormat:@"%@%@",@"$",txtMeCode.text]];
        }
    }
}

- (IBAction)validateMeCode:(id)sender {
//    if([txtMeCode.text length] < 4)
//    {
//        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
//        
//        // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
//        // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
//        // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
//        // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
//        [appDelegate showAlertWithResult:false withTitle:@"Invalid MeCode" withSubtitle:@"Error Creating MeCode" withDetailText:@"MeCode isn't sufficient length or has invalid characters" withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Not shown" withRightButtonTitleColor:[UIColor clearColor] withDelegate:self];
//    }
}
@end
