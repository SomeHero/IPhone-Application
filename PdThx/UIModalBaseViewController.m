//
//  UIModalBaseViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"

@interface UIModalBaseViewController ()

@end

@implementation UIModalBaseViewController

@synthesize mainScrollView;
@synthesize navigationTitle;
@synthesize headerText;

//size of tab bar

//Fake Update
//--size of application screen---
CGRect applicationFrame;

//--original size of ScrollView---
CGSize scrollViewOriginalSize;

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    /*
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWasShown:)
     name:UIKeyboardDidShowNotification object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(keyboardWillBeHidden:)
     name:UIKeyboardWillHideNotification object:nil];
     */ 
}


/*
- (void) keyboardWillHide:(NSNotification *)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScrollView.contentInset = contentInsets;
    mainScrollView.scrollIndicatorInsets = contentInsets;
} 


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScrollView.contentInset = contentInsets;
    mainScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height +40;
    if ( [currTextField isKindOfClass:[UITextView class]] ){
        if (!CGRectContainsPoint(aRect, ((UITextView*)currTextField).frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, (((UITextView*)currTextField).frame.origin.y + ((UITextView*)currTextField).frame.size.height) - (aRect.size.height + 40));
            [mainScrollView setContentOffset:scrollPoint animated:YES];
        }
    } else {
        if (!CGRectContainsPoint(aRect, ((UITextField*)currTextField).frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, (((UITextField*)currTextField).frame.origin.y + ((UITextField*)currTextField).frame.size.height) - (aRect.size.height + 40));
            [mainScrollView setContentOffset:scrollPoint animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScrollView.contentInset = contentInsets;
    mainScrollView.scrollIndicatorInsets = contentInsets;
}

 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currTextField = textField;
    
    [mainScrollView adjustOffsetToIdealIfNeeded];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currTextField = nil;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [mainScrollView adjustOffsetToIdealIfNeeded];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // this will appear as the title in the navigation bar
    }
    return self;
}

- (void)dealloc
{
    [mainScrollView release];
    [phoneNumberFormatter release];
    [headerText release];
    
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
    
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    phoneNumberFormatter = [[PhoneNumberFormatting alloc] init];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-320x44.png"] forBarMetrics:UIBarMetricsDefault];
    }

    UIImage *bgImage = [UIImage imageNamed:@"BTN-Nav-Cancel-68x30.png"];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [settingsBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];

    self.navigationItem.leftBarButtonItem= cancelButton;
    
    [cancelButton release];
    
    [self setTitle: self.title];
    lblHeader.text = headerText;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    if( self.navigationItem.leftBarButtonItem != nil )
    {
        UIImage *bgImage = [UIImage imageNamed:@"BTN-Nav-Back-61x30.png"];
        UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingsBtn setImage:bgImage forState:UIControlStateNormal];
        settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
        [settingsBtn addTarget:self action:@selector(pressedNavigationBackButton) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *settingsButtons = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
        
        
        self.navigationItem.hidesBackButton = YES;
        
        self.navigationItem.leftBarButtonItem = settingsButtons;
    }*/
}

-(void)pressedNavigationBackButton
{
    [self dismissModalViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    lblHeader.text = headerText;
    
    UIImage *bgImage = [UIImage imageNamed:@"BTN-Nav-Cancel-68x30.png"];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    
    [settingsBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
}


-(void) removeCurrentViewFromNavigation: (UINavigationController*) navController {
    
    NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
    [controllers removeLastObject];
    
    navController.viewControllers = controllers;
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
-(void)cancelClicked {
    [self dismissModalViewControllerAnimated:YES];
}
@end