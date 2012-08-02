//
//  SocialNetworksViewController.m
//  PdThx
//
//  Created by Edward Mitchell on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocialNetworksViewController.h"
#import "TwitterRushViewController.h"
#import "FacebookSignIn.h"

@interface SocialNetworksViewController ()

@end

@implementation SocialNetworksViewController
@synthesize numFailedFB;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (IBAction)btnLinkFacebookClicked:(id)sender {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*) [UIApplication sharedApplication].delegate;
    [appDelegate showWithStatus:@"Please wait..." withDetailedStatus:@"Connecting with Facebook"];
    
    Facebook* fBook = appDelegate.fBook;
    FacebookSignIn* faceBookSignInHelper = [[FacebookSignIn alloc] init];
    
    if ( ![fBook isSessionValid] ){
        NSLog(@"Facebook Session is NOT Valid, Signing in...");
        [faceBookSignInHelper setCancelledDelegate:appDelegate];
        [faceBookSignInHelper signInWithFacebook:self];
    } else {
        NSLog(@"Facebook Session is Valid, Getting info...");
        [fBook requestWithGraphPath:@"me" andDelegate:self];
        [fBook requestWithGraphPath:@"me/friends" andDelegate:appDelegate];
    }
    
}
- (IBAction)btnLinkTwitterClicked:(id)sender {
    TwitterRushViewController* controller =
    [[TwitterRushViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
    
}

-(void)fbSignInCancelled
{
    numFailedFB++;
    if (numFailedFB == 3) {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Facebook Error" withDetailedStatus:@"Check Connection"];
        numFailedFB = 0;
    } else {
        PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showErrorWithStatus:@"Cancelled" withDetailedStatus:@"Facebook Sign In Cancelled"];
    }
}

-(void)fbSignInDidFail:(NSString *) reason {
    
    [self.navigationController dismissModalViewControllerAnimated:NO];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Error!" withDetailedStatus:@"Facebook Login Failed"];
    
}

-(void) request:(FBRequest *)request didLoad:(id)result
{
    NSLog(@"User info did load from Facebook, Linking in...");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [userService setLinkFbAccountDelegate:self];
    [userService linkFacebookAccount:[prefs objectForKey:@"userId"] withFacebookId:[result objectForKey:@"id"] withAuthToken:[prefs objectForKey:@"FBAccessTokenKey"]];
}

-(void) request:(FBRequest *)request didFailWithError:(NSError *)error
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog ( @"Error occurred2 -> %@" , [error description] );
    
    Facebook* fBook = appDelegate.fBook;
    FacebookSignIn* faceBookSignInHelper = [[FacebookSignIn alloc] init];
    
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"FBAccessTokenKey"];
    [def removeObjectForKey:@"FBExpirationDateKey"];
    [def synchronize];
    
    if ( ![fBook isSessionValid] ){
        NSLog(@"Facebook Session is NOT Valid, Signing in...");
        [faceBookSignInHelper setCancelledDelegate:self];
        [faceBookSignInHelper signInWithFacebook:self];
    } else {
        NSLog(@"Facebook Session is Valid, Getting info...");
        [fBook requestWithGraphPath:@"me" andDelegate:self];
        [fBook requestWithGraphPath:@"me/friends" andDelegate:appDelegate];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}
@end
