//
//  AccountListViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SetupACHAccountController.h"

@implementation AccountListViewController


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
    self.title = @"Linked Accounts";
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    bankAccountService = [[BankAccountService alloc] init];
    [bankAccountService setBankAccountRequestDelegate: self];
    [bankAccountService setPreferredAccountDelegate: self];

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
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Please wait" withDetailedStatus:@"Loading user accounts"];
    [bankAccountService getUserAccounts: user.userId];
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
-(void)getUserAccountsDidComplete:(NSMutableArray*)bankAccounts {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    user.bankAccounts = bankAccounts;
    [userAccountsTableView reloadData];
}
-(void)getUserAccountsDidFail:(NSString*)errorMessage {
    NSLog(@"%@", errorMessage);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 2)
        return 1;
    else if(section == 1)
        return 1;
    else {
        return [user.bankAccounts count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UIProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIProfileTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(indexPath.section == 2) {
        bool found = false;
        
        for(int i = 0; i < [user.bankAccounts count]; i++)
        {
            BankAccount* bankAccount = [user.bankAccounts objectAtIndex:i];
            
            if([user.preferredReceiveAccountId isEqualToString:bankAccount.bankAccountId])
            {
                cell.textLabel.text = bankAccount.nickName;
                cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
                
                found = YES;
            }
        }
        
        if(!found)
        {
            cell.textLabel.text = @"No Preferred Account Setup";
            cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
        }
    }
    if(indexPath.section == 1){ 
        bool found = false;
        
        for(int i = 0; i < [user.bankAccounts count]; i++)
        {
            BankAccount* bankAccount = [user.bankAccounts objectAtIndex:i];
            
            if([user.preferredPaymentAccountId isEqualToString:bankAccount.bankAccountId])
            {
                cell.textLabel.text = bankAccount.nickName;
                cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
                found = YES;
            }
        }
        if(!found)
        {
            cell.textLabel.text = @"No Preferred Account Setup";
            cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
        }
    }
    if(indexPath.section == 0)
    {
        if(indexPath.row >= [user.bankAccounts count])
        {
            cell.textLabel.text = @"Add Account";
        }
        else {
            BankAccount* bankAccount = [user.bankAccounts objectAtIndex:indexPath.row];
            
            cell.lblHeading.text = bankAccount.nickName;
            cell.lblDescription.text = bankAccount.status;
            cell.ctrlImage.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
        }
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     if(section == 0)
         return @"Linked Accounts";
     if(section == 1)
         return @"Sending Account";
     if(section == 2)
         return @"Receiving Account";
     
     return @"";
 }
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    label.font = [UIFont boldSystemFontOfSize:12];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}
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
    if(indexPath.section == 0)  {
        if(indexPath.row >= [user.bankAccounts count])
        {
            AddACHAccountViewController* controller = [[AddACHAccountViewController alloc] init];
            
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];   
        } else {
            EditACHAccountViewController* controller = [[EditACHAccountViewController alloc] init];
            controller.bankAccount = [user.bankAccounts objectAtIndex: indexPath.row];
        
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    } else if(indexPath.section == 1){
        selectModal = [[[SelectAccountModalViewControllerViewController alloc] initWithFrame:self.view.bounds] autorelease];
        [selectModal setOptionSelectDelegate: self];
        selectModal.bankAccounts = user.bankAccounts;
        selectModal.selectedAccount =user.preferredPaymentAccountId;
        selectModal.accountType = @"Send";
        
        [self.view addSubview:selectModal];
        [selectModal show];
    } else  if(indexPath.section == 2){
        selectModal = [[[SelectAccountModalViewControllerViewController alloc] initWithFrame:self.view.bounds] autorelease];
        
        [selectModal setOptionSelectDelegate: self];
        selectModal.bankAccounts = user.bankAccounts;
        selectModal.selectedAccount =user.preferredReceiveAccountId;
        selectModal.accountType = @"Receive";
        
        [self.view addSubview:selectModal];
        [selectModal show];
    }
}
-(void) userSecurityPinDidFail: (NSString*) message {
    //[spinner stopAnimating];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid security pin"];
}
-(void) optionDidSelect:(NSString*) optionId {
    
    selectedOption = optionId;
    
    if([selectModal.accountType isEqualToString: @"Send"]) {
        [bankAccountService setPreferredSendAccount:optionId forUserId:user.userId];
    }
    else {
        [bankAccountService setPreferredReceiveAccount:optionId forUserId:user.userId];
    }
}

-(void)setPreferredAccountDidComplete {
    [selectModal hide];
    
    if([selectModal.accountType isEqualToString: @"Send"]) {
        user.preferredPaymentAccountId = selectedOption;
    }
    else {
        user.preferredReceiveAccountId = selectedOption;
    }
    [userAccountsTableView reloadData];
}
-(void)setPreferredAccountDidFail:(NSString*)responseMsg {
    NSLog(@"Failed");
}
@end
