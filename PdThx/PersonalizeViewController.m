//
//  PersonalizeViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonalizeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PdThxAppDelegate.h"
#import "User.h"

@interface PersonalizeViewController ()

@end

@implementation PersonalizeViewController

@synthesize firstNameField, lastNameField, userImageButton, saveContinueButton;

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
    
    User* user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    firstNameField.text = user.firstName;
    lastNameField.text = user.lastName;
    
    if([user.imageUrl length] > 0)
    {
        [userImageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: user.imageUrl]]] forState:UIControlStateNormal];
    }
    else {
        [userImageButton setBackgroundImage:[UIImage imageNamed: @"avatar_unknown.jpg"] forState:UIControlStateNormal];
    }
    
    [userImageButton.layer setCornerRadius:6.0];
    [userImageButton.layer setMasksToBounds:YES];
}   

- (void)viewDidUnload
{
    [userImageButton release];
    userImageButton = nil;
    [firstNameField release];
    firstNameField = nil;
    [lastNameField release];
    lastNameField = nil;
    [saveContinueButton release];
    saveContinueButton = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [userImageButton release];
    [firstNameField release];
    [lastNameField release];
    [saveContinueButton release];
    [super dealloc];
}
- (IBAction)pressedSaveContinue:(id)sender 
{
    [self.tabBarController setSelectedIndex:3];
}
@end
