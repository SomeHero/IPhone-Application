//
//  ProfileController.m
//  Fanatical
//
//  Created by James Rhodes on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"
#import "PdThxAppDelegate.h"
#import "AccountListViewController.h"
#import "MeCodeSetupViewController.h"
#import "ChangePasswordViewController.h"

#define kScreenWidth  320
#define kScreenHeight  400

@implementation ProfileController
@synthesize profileOptions, sections;

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
    [profileOptions release];
    [sections release];
    [oldSecurityPin release];
    [newSecurityPin release];
    
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
    self.title = @"Settings";
    [tableView setRowHeight: 60];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"options" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.profileOptions = dic;
    [dic release];
    
    NSArray *array = [[profileOptions allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.sections = array;
    
    userService = [[UserService alloc] init];
    [userService setUserSecurityPinCompleteDelegate:self];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UIProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
/*
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 NSString *optionSection = [sections objectAtIndex:section];
 return optionSection;
 }*/

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    switch(indexPath.section) {
        case 0:
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    EditProfileViewController *controller = [[EditProfileViewController alloc] init];
                    [controller setTitle: @"Me"];
                    
                    [self.navigationController pushViewController:controller animated:YES];      
                    
                    [controller release];
                    
                    break;
                }
            }
            break;
        }
        case 1:
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    AccountListViewController  *controller = [[AccountListViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES]; 
                    
                    [controller release];
                    
                    break;
                }
            }
            break;
        }
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    EmailAccountListViewController* controller = [[EmailAccountListViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES]; 
                    
                    [controller release];
                    
                    break;
                }
                case 2:
                {
                    PhoneListViewController* controller = [[PhoneListViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES]; 
                    
                    [controller release];
                    
                    break;
                }
                case 3:
                {
                    MeCodeListViewController* controller = [[MeCodeListViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES]; 
                    
                    [controller release];
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 3:
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    NotificationConfigurationViewController* controller = [[NotificationConfigurationViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES]; 
                    
                    [controller release];
                    break;
                }
                case 1:
                {
                    SharingPreferencesViewController* controller =
                    [[SharingPreferencesViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    [controller release];
                    
                    break;
                }
                case 2:
                {
                    SecurityAndPrivacyViewControllerViewController* controller =
                    [[SecurityAndPrivacyViewControllerViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    [controller release];
                    
                    break;
                    
                }
            }
            break;
        }
        case 4:
        {
            switch (indexPath.row) {
                case 0:
                {
                    HelpViewController* controller = [[HelpViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    [controller release];
                    
                    break;
                }
                case 1:
                {
                    if ([MFMailComposeViewController canSendMail])
                    {
                        MFMailComposeViewController *mail = [[[MFMailComposeViewController alloc] init] autorelease];
                        
                        mail.mailComposeDelegate = self;
                        
                        [mail setToRecipients:[NSArray arrayWithObject:@"support@paidthx.com"]];
                        [mail setSubject:@"Hey PaidThx! Here's my feedback"];    
                        
                        [self presentModalViewController:mail animated:YES];
         
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                        message:@"Your device doesn't support the composer sheet"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 5:
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    TOSViewController* controller = [[TOSViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    [controller release];
                    break;
                }
                case 1:
                {
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) signOut];
                    break;
                }
                default:
                    break;
            }
            break;
        }    
        default:
            break;
    }
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

-(void) userSecurityPinDidComplete {
    [spinner stopAnimating];
    
    [self showAlertView: @"Security Pin Change Success!" withMessage: @"Security Pin successfully changed."];
}

-(void) userSecurityPinDidFail: (NSString*) message {
    [spinner stopAnimating];
    
    [self showAlertView: @"Security Pin Change Failed" withMessage: message];
}



@end
