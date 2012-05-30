//
//  UIBaseViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIBaseViewController.h"
#import "Contact.h"
#import <AddressBook/AddressBook.h>
#import "ProfileController.h"

@implementation UIBaseViewController

@synthesize scrollView;

//size of tab bar
int kTabBarSize = 20;
int lastCharCount = 0;

//Fake Update
//--size of application screen---
CGRect applicationFrame;

//--original size of ScrollView---
CGSize scrollViewOriginalSize;

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;

    aRect.size.height -= kbSize.height +40;
    if (!CGRectContainsPoint(aRect, currTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (currTextField.frame.origin.y + currTextField.frame.size.height) - (aRect.size.height + 40));
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currTextField = nil;
}
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
    [scrollView release];
    [autoCompleteArray release];
    [allResults release];
    [phoneNumberFormatter release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self registerForKeyboardNotifications];
    phoneNumberFormatter = [[PhoneNumberFormatting alloc] init];
    
    [super viewDidLoad];
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    bool setupPassword = [prefs boolForKey:@"setupPassword"];
    NSString* userId = [prefs stringForKey: @"userId"];
    
    if([userId length] > 0) {
        UIBarButtonItem *signOutButton =  [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonSystemItemAction target:self action:@selector(signOutClicked)];
        
        self.navigationItem.leftBarButtonItem= signOutButton;
        [signOutButton release];
        
        UIBarButtonItem *settingsButtons  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-settings3.png"] style: UIBarButtonItemStylePlain target: self action:@selector(actionButtonClicked:)];

        self.navigationItem.rightBarButtonItem = settingsButtons;
        [settingsButtons release];
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}


-(void) removeCurrentViewFromNavigation: (UINavigationController*) navController {

    NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
    [controllers removeLastObject];
    
    navController.viewControllers = controllers;
}
-(void) signOutClicked {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"userId"];
    [prefs removeObjectForKey:@"paymentAccountId"];
    
    [prefs synchronize];
    

}
-(void) actionButtonClicked:(id)sender{
    NSLog(@"Action Button Clicked");
    
    ProfileController* viewController = [[ProfileController alloc] initWithNibName:@"ProfileController" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
    
}
- (void) showAlertView:(NSString *)title withMessage: (NSString *) message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
                                                        message: message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];

    [alertView release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
