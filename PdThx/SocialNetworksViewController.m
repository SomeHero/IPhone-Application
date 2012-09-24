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
@synthesize appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
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
    
    if ( indexPath.section == 0 && indexPath.row == 0 ) // Facebook Cell
    {
        if ( [user.socialNetworks objectForKey:@"Facebook"] )
        {
            cell.lblDescription.text = [[profileSection objectAtIndex:[indexPath row]] objectForKey:@"AlreadyLinkedDescription"];
        }
    } else if ( [prefs objectForKey:preferenceKeyToCheck] != NULL && [prefs stringForKey:preferenceKeyToCheck].length > 0 )
    {
        // Default Handling...
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
                    if ( [user.socialNetworks objectForKey:@"Facebook"] || [self userHasValidFacebookId] )
                    {
                        NSLog(@"Facebook already linked, trying to unlink...");
                        
                        // Facebook already linked.
                        
                        [appDelegate showWithStatus:@"Please wait..." withDetailedStatus:@"Unlinking Facebook"];
                        
                        FacebookSignIn* faceBookSignInHelper = [[FacebookSignIn alloc] init];
                        
                        // TODO: Implement "linking" AKA just open web view and get user information
                        [faceBookSignInHelper unlinkFacebookAccount:self];
                    } else {
                        // No facebook linked.
                        
                        [appDelegate showWithStatus:@"Please wait..." withDetailedStatus:@"Connecting with Facebook"];
                        
                        FacebookSignIn* faceBookSignInHelper = [[FacebookSignIn alloc] init];
                        
                        // TODO: Implement "linking" AKA just open web view and get user information
                        [faceBookSignInHelper linkNewFacebookAccount:self];
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

// Facebook (Un)Link Delegate Methods
// These functions were edited to show alert views in the FbSignInHelper for better error handling.
-(void)facebookAccountLinkFailed
{
    //[appDelegate showSimpleAlertView:NO withTitle:@"Error" withSubtitle:@"Facebook Link Failed" withDetailedText:@"We were unable to link your PaidThx account with Facebook. Please check your wireless connection and try again." withButtonText:@"Ok" withDelegate:self];
    [tableView reloadData];
}

-(void)facebookAccountLinkSuccess
{
    //[appDelegate showSimpleAlertView:NO withTitle:@"Success" withSubtitle:@"Facebook Linked" withDetailedText:@"Your PaidThx account is now linked with Facebook. You can now easily send to your facebook friends." withButtonText:@"Ok" withDelegate:self];
    [tableView reloadData];
}

-(void)facebookAccountUnlinkFailed
{
    //[appDelegate showSimpleAlertView:NO withTitle:@"Error" withSubtitle:@"Facebook Unlink Failed" withDetailedText:@"We were unable to unlink your PaidThx account with Facebook. Please check your wireless connection and try again." withButtonText:@"Ok" withDelegate:self];
    [tableView reloadData];
}

-(void)facebookAccountUnlinkSuccess
{
    //[appDelegate showSimpleAlertView:NO withTitle:@"Success" withSubtitle:@"Facebook Unlinked" withDetailedText:@"Your Facebook account has been unlinked from your PaidThx account. Your friends will not be seen in your contact list anymore." withButtonText:@"Ok" withDelegate:self];
    [tableView reloadData];
}

-(void)fbSignInCancelled
{
    numFailedFB++;
    if (numFailedFB == 3) {
        [appDelegate showErrorWithStatus:@"Facebook Error" withDetailedStatus:@"Check Connection"];
        numFailedFB = 0;
    } else {
        [appDelegate showErrorWithStatus:@"Cancelled" withDetailedStatus:@"Facebook Sign In Cancelled"];
    }
}

-(void)fbSignInDidFail:(NSString *) reason {
    
    [self.navigationController dismissModalViewControllerAnimated:NO];
    
    [appDelegate showErrorWithStatus:@"Error!" withDetailedStatus:@"Facebook Login Failed"];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
}

-(bool)userHasValidFacebookId
{
    if ( user.facebookId && user.facebookId.length > 0 )
        return TRUE;
    else
        return FALSE;
}
@end
