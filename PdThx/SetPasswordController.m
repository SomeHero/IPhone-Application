//
//  SetPasswordController.m
//  PdThx
//
//  Created by James Rhodes on 1/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SetPasswordController.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "PdThxAppDelegate.h"

@implementation SetPasswordController
@synthesize txtUserName, txtPassword, txtConfirmPassword, securityPin,
recipientMobileNumber, amount, comment, button;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* mobileNumber = [prefs stringForKey:@"mobileNumber"];
    
    txtUserName.text = mobileNumber;
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
-(IBAction) bgTouched:(id) sender
{
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
}
-(IBAction) btnContinueClicked:(id) sender
{
    
    NSLog(@"Setting Password");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* userId = [prefs stringForKey:@"userId"];
    NSString* mobileNumber = [prefs stringForKey:@"mobileNumber"];
    
    NSString* password = txtPassword.text;

    [self setupPassword:password withUserName:mobileNumber forUser:userId]; 
}
-(void) setupPassword:(NSString*) password withUserName:(NSString *) userName forUser: (NSString *) userId {
    
    NSString *rootUrl = [NSString stringWithString: @"pdthx.me"];
    NSString *apiKey = [NSString stringWithString: @"bda11d91-7ade-4da1-855d-24adfe39d174"];
    
    NSString *deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSURL *urlToSend = [[[NSURL alloc] initWithString: [NSString stringWithFormat: @"http://%@/Services/UserService/SetupPassword?apiKey=%@", rootUrl, apiKey]] autorelease];  
    NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userId, @"userId",
                                 deviceId, @"deviceId",
                                 userName, @"userName",
                                 password, @"password",
                                 nil];
    
    NSString *newJSON = [paymentData JSONRepresentation]; 
    
    ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:urlToSend] autorelease];  
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"]; 
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[newJSON dataUsingEncoding:NSUTF8StringEncoding]];  
    [request setRequestMethod: @"POST"];	
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(setupPasswordComplete:)];
    [request setDidFailSelector:@selector(setupPasswordFailed:)];
    
    [request startAsynchronous]; 
}
-(void) setupPasswordComplete:(ASIHTTPRequest *)request
{
    NSString *theJSON = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSON error:nil];
    
    bool success = [[jsonDictionary objectForKey:@"success"] boolValue];
    NSString *message = [[NSString alloc] initWithString:[jsonDictionary objectForKey:@"message"]];
    
    if(success) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setBool:YES forKey:@"setupPassword"];
        [prefs synchronize];
        
        PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate switchToConfirmation];
        
    }
}
-(void) setupPasswordFailed:(ASIHTTPRequest *)request
{
    // statsCommuniqueDoneProblem ... !
    NSLog(@"Setup Password Failed");
}
- (void) showAlertView:(NSString *)title withMessage: (NSString *) message  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: title
                                                        message: message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
}
@end
