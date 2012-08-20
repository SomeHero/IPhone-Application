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
#import "UIProfileTableViewCell.h"

@interface SocialNetworksViewController ()

@end

@implementation SocialNetworksViewController
@synthesize numFailedFB, profileOptions, sections, FacebookResult;

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
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    self.title = @"Settings";
    [tableView setRowHeight: 60];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"opSocialNetworks" ofType:@"plist"];
    
    userService = [[UserService alloc] init];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.profileOptions = dic;
    [dic release];
    
    NSArray *array = [[profileOptions allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.sections = array;
    
    [super viewDidLoad];
    //self.clearsSelectionOnViewWillAppear = NO;
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"ProfileController"
                                        withError:&error]){
        //Handle Error Here
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *optionSection = [sections objectAtIndex:section];
    
    NSArray *profileSection = [profileOptions objectForKey:optionSection];
    
    return [profileSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    UIProfileTableViewCell *cell = [tblView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIProfileTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *optionSection = [sections objectAtIndex:[indexPath section]];
    
    NSArray *profileSection = [profileOptions objectForKey:optionSection];
    
    cell.lblHeading.text = [[profileSection objectAtIndex:[indexPath row]] objectForKey:@"Label"];
    cell.lblDescription.text = [[profileSection objectAtIndex:[indexPath row]] objectForKey:@"Description"];
    cell.ctrlImage.image =  [UIImage  imageNamed:[[profileSection objectAtIndex:[indexPath row]] objectForKey:@"Image"]];
    cell.ctrlImage.highlightedImage = [UIImage  imageNamed:[[profileSection objectAtIndex:[indexPath row]] objectForKey:@"HighlightedImage"]];
    
    NSString*preferenceKeyToCheck = [[profileSection objectAtIndex:[indexPath row]] objectForKey:@"UserPreferencesKey"];
    
    NSLog(@"Preferences value for %@ -> %@", preferenceKeyToCheck, [prefs objectForKey:preferenceKeyToCheck]);
    
    if ( [prefs objectForKey:preferenceKeyToCheck] != NULL && [prefs stringForKey:preferenceKeyToCheck].length > 0 ) // Facebook
    {
        cell.userInteractionEnabled = NO;
        cell.lblDescription.text = [[profileSection objectAtIndex:[indexPath row]] objectForKey:@"AlreadyLinkedDescription"];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    switch(indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*) [UIApplication sharedApplication].delegate;
                    
                    [appDelegate showWithStatus:@"Please wait..." withDetailedStatus:@"Connecting with Facebook"];
                    
                    Facebook* fBook = appDelegate.fBook;
                    FacebookSignIn* faceBookSignInHelper = [[FacebookSignIn alloc] init];
                    
                    if ( ![fBook isSessionValid] )
                    {
                        NSLog(@"Linking facebook, session not valid..");
                        [faceBookSignInHelper setCancelledDelegate:appDelegate];
                        [faceBookSignInHelper signInWithFacebook:self];
                    } else {
                        NSLog(@"Linking facebook, session valid..");
                        
                        [fBook requestWithGraphPath:@"me" andDelegate:self];
                    }
                    
                    break;
                }
                case 1:
                {
                    //Twitter
                    TwitterRushViewController* controller =
                    [[TwitterRushViewController alloc] init];
                    
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    [controller release];
                    break;
                }
            }
            break;
        }
    }
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
    NSLog(@"User info did load from Facebook, linking account...");
    
    
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Linking with Facebook" withDetailedStatus:@"Please wait"];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [userService setLinkFbAccountDelegate:self];
    
    NSLog(@"Calling service...");
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

-(void) linkFbAccountDidSucceed {
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*) [UIApplication sharedApplication].delegate;
    [appDelegate.fBook requestWithGraphPath:@"me/friends" andDelegate:appDelegate];
    
    [appDelegate showSuccessWithStatus:@"Success!" withDetailedStatus:@"Facebook linked!"];
}

-(void) linkFbAccountDidFail:(NSString *)message {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*) [UIApplication sharedApplication].delegate;
    [appDelegate dismissProgressHUD];
    [appDelegate showSimpleAlertView:NO withTitle:@"Failed!" withSubtitle:@"Facebook account linking failed." withDetailedText:[NSString stringWithFormat:@"Unable to link Facebook account: %@", message] withButtonText:@"OK" withDelegate:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}
@end
