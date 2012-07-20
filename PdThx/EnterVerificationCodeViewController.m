//
//  EnterVerificationCodeViewController.m
//  PdThx
//
//  Created by Justin Cheng on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnterVerificationCodeViewController.h"
#import "PdThxAppDelegate.h"
#import "PayPoint.h"

@interface EnterVerificationCodeViewController ()

@end

@implementation EnterVerificationCodeViewController
@synthesize phoneNumber;

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
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"payPointType == 'Phone'"];
    phones = [[user.payPoints filteredArrayUsingPredicate:  predicate] copy];  
    txtPhoneNumber.text = phoneNumber;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [txtPhoneNumber release];
    txtPhoneNumber = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)btnSubmit
{
    [verificatoinCode resignFirstResponder];
    //some service call
    //if()//successfully verified
     //   {
            PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate showAlertWithResult:true withTitle:@"Success" withSubtitle:@"" withDetailText:@"Your number was successfully verified!" withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Not shown" withRightButtonTitleColor:[UIColor clearColor] withDelegate:self];        //}

}
-(void)didSelectButtonWithIndex:(int)index
{
    if ( index == 0 ) {
        // Dismiss, error Phone Number validated
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
    } else {
        // Successful error Phone Number
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        
        // TODO: There needs to be a protocol here to load the image as being on top.
    }
}

- (void)dealloc {
    [txtPhoneNumber release];
    [super dealloc];
}
@end
