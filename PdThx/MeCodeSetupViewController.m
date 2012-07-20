//
//  MeCodeSetupViewController.m
//  PdThx
//
//  Created by Justin Cheng on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeCodeSetupViewController.h"
#import "PdThxAppDelegate.h"

@implementation MeCodeSetupViewController
@synthesize MeCodeField;
@synthesize SubmitButton;
@synthesize meCodeService;

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
    meCodeService = [[MeCodeService alloc] init];
    [meCodeService setMeCodeCreateCompleteDelegate:self];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"MeCodeSetupViewController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [textField resignFirstResponder];
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}
- (IBAction)meCodeChange:(id) sender {
    if([MeCodeField.text length] > 0   && [MeCodeField.text characterAtIndex:0] != '$' )
    {
        [MeCodeField setText:[NSString stringWithFormat:@"%@%@",@"$",MeCodeField.text]];
    }
}

- (void)viewDidUnload
{
    [MeCodeField release];
    MeCodeField = nil;
    [SubmitButton release];
    SubmitButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [meCodeService release];
    [MeCodeField release];
    [SubmitButton release];
    [super dealloc];
}
- (IBAction)SubmitButtonAction:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userId"];
    [meCodeService validateMeCode:userId withMeCode:MeCodeField.text];
}
-(void) meCodeCreateSuccess
{
    [self showAlertView:@"MeCode Setup" withMessage:[NSString stringWithFormat:@"MeCode: %@ successfully created!", MeCodeField.text]];
    MeCodeField.text = @"";
    NSLog(@"MeCode Success!!");
}
-(void)meCodeCreateDidFail:(NSString*) response
{
    NSLog(@"%@", response);
}
@end
