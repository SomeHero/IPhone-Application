//
//  VerificationMobileDevice.m
//  PdThx
//
//  Created by James Rhodes on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "VerificationMobileDevice.h"
#import "ACHAccountSetup.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "CreateSecurityCode.h"

@implementation VerificationMobileDevice
@synthesize scrollView, txtVerificationCode1, txtVerificationCode2, recipientMobileNumber, amount, comment;

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
    
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, currTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, (currTextField.frame.origin.y + currTextField.frame.size.height) - aRect.size.height + 50);
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
    
    [self registerForKeyboardNotifications];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
-(IBAction) btnContinueClicked:(id) sender{
    NSLog(@"Verfying Mobile Device");
    
    CreateSecurityCode* viewController = [[CreateSecurityCode alloc] initWithNibName:@"CreateSecurityCode" bundle:nil];
    viewController.title = @"Select Your Pin";
    
    [self.navigationController pushViewController:viewController animated:YES];
   
}

-(void) requestFinished: (ASIHTTPRequest *) request {
    
    // [request responseString]; is how we capture textual output like HTML or JSON
    // [request responseData]; is how we capture binary output like images
    // Then to create an image from the response we might do something like
    // UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
    NSString *theJSON = [request responseString];
    
    // Now we have successfully captured the JSON ouptut of our request
    // Alloc and initialize our JSON parser
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    /* Since I'm parsing JSON from an API, after it's parsed it'll come out in the form
     of an NSMutableDictionary with NSMutableArrays inside it.
     Just a side note...if the resulting JSON looks like this {"one","two","three"}
     then after the JSON has been parsed it will come out as an NSMutableArray.
     If the JSON looks like this [{id:1,two:"three"},{id:2, two:"four"}] the after it has
     been parsed it will be in the form of an NSMutableDictionary
     (just like the JSON most APIs output) */
    
    // Actually parsing the JSON
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    bool success = [[jsonDictionary objectForKey:@"success"] boolValue];
    NSString *message = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"message"]];
    
    /*
     If you want to use this array to persist across methods you might want to
     declare "colorTitles" as an NSMutableArray in the "JSONAppViewController.h"
     file and you might even want to create a property in the .h file
     and synthesize that property in the .m file
     extract other information such as the color's id or the number of views it
     has the same way, it will most likely be an NSMutableArray */
    
    //if(success)
    //{
    //put user id in UserPref
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //[prefs setObject: userId forKey:@"UserId"];
    //[prefs setObject: paymentAccountId forKey:@"PaymentAccountId"];
    
    //[prefs synchronize];
    
    CreateSecurityCode* viewController = [[CreateSecurityCode alloc] initWithNibName:@"CreateSecurityCode" bundle:nil];
    viewController.title = @"Select Your Pin";
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    
    [allControllers removeObjectAtIndex:[allControllers count] - 2];
    [self.navigationController setViewControllers:allControllers animated:NO];
    [allControllers retain];
    
    
    //}
    //else {
    //    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failure!"
    //                                                      message: [NSString stringWithFormat: @"Unable to validate the User Name and Password.  Try again."]
    //                                                    delegate:nil
    //                                            cancelButtonTitle:@"OK"
    //                                            otherButtonTitles:nil];
    
    //[message show]; 
    //}
}
-(IBAction) btnReSendCodesClicked:(id) sender {
    
}
-(IBAction) bgTouched:(id) sender {
    [txtVerificationCode1 resignFirstResponder];
    [txtVerificationCode2 resignFirstResponder];
}

@end
