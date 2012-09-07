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
#import "NewACHAccountViewController.h"
#import "ChooseAddACHMethodViewController.h"

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
    
    if(newAccountAdded) {
        // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
        // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
        // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
        // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
        [appDelegate showAlertWithResult:true withTitle:@"New ACH Account Linked!" withSubtitle:@"You can now receive money with PaidThx" withDetailText:@"To begin sending money from this account, you will need to complete verification.  We've sent you an email with steps to complete verification." withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Ok" withRightButtonTitleColor:[UIColor darkGrayColor]  withTextFieldPlaceholderText: @"" withDelegate:self];
        
        newAccountAdded = false;
    }
}
-(void)didSelectButtonWithIndex:(int)index
{
    if ( index == 0 ) {
        // Dismiss, error uploading image alert view clicked.
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
    } else {
        // Successfully saved image, just go back to personalize screen and load the image.
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        
        // TODO: There needs to be a protocol here to load the image as being on top.
    }
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
    static NSString *CustomTableViewCellIdentifier = @"CustomTableViewCell";
    static NSString *CellIdentifier = @"CellIdentifier";

    
    if(indexPath.section == 2) {
        bool found = false;
        
        for(int i = 0; i < [user.bankAccounts count]; i++)
        {
            BankAccount* bankAccount = [user.bankAccounts objectAtIndex:i];
            
            if([user.preferredReceiveAccountId isEqualToString:bankAccount.bankAccountId])
            {
                UIProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewCellIdentifier];
                if (cell == nil){
                    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIProfileTableViewCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                
                cell.lblHeading.text = @"";
                cell.lblDescription.text = @"";
                cell.ctrlImage.image = nil;
                
                cell.textLabel.text = bankAccount.nickName;
                
                cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
                
                found = YES;
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                return cell;
            }
        }
        
        if(!found)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.textLabel.text = @"No Preferred Account Setup";
            cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    }
    if(indexPath.section == 1){ 
        bool found = false;
        
        for(int i = 0; i < [user.bankAccounts count]; i++)
        {
            BankAccount* bankAccount = [user.bankAccounts objectAtIndex:i];
            
            if([user.preferredPaymentAccountId isEqualToString:bankAccount.bankAccountId])
            {
                UIProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewCellIdentifier];
                if (cell == nil){
                    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIProfileTableViewCell" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                
                cell.lblHeading.text = @"";
                cell.lblDescription.text = @"";
                cell.ctrlImage.image = nil;
                cell.textLabel.text = bankAccount.nickName;
                cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
                found = YES;
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                return cell;
            }
        }
        if(!found)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.textLabel.text = @"No Preferred Account Setup";
            cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    }
    if(indexPath.section == 0)
    {
        if(indexPath.row >= [user.bankAccounts count])
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.textLabel.text = @"Add Account";
            cell.imageView.image = [UIImage imageNamed: @"img-plus-40x40.png"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
            return cell;
        }
        else {
            BankAccount* bankAccount = [user.bankAccounts objectAtIndex:indexPath.row];
            
            UIProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewCellIdentifier];
            if (cell == nil){
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIProfileTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblHeading.text = bankAccount.nickName;
            cell.lblDescription.text = bankAccount.status;
            cell.ctrlImage.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
            cell.textLabel.text = @"";
            cell.imageView.image = nil;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    }
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
            /*
            NewACHAccountViewController* controller = [[NewACHAccountViewController alloc] init];
            
            [controller setTitle: @"Add Bank Account"];
            [controller setAchSetupDidComplete:self];
            
            
            //[controller setHeaderText: @"To add a mobile # to your PaidThx account, enter your new mobile # below."];

            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
            
            
            //[self.navigationItem setRightBarButtonItem:(UIBarButtonItem *) animated:YES];
            [self.navigationController presentModalViewController:navBar animated:YES];
            [navBar release];
            [controller release];
             */
            ChooseAddACHMethodViewController* chooseMethodVC = [[ChooseAddACHMethodViewController alloc] init];
            [chooseMethodVC setNavigationTitle:@"Add Bank Account"];
            [chooseMethodVC setTitle:@"Add Bank Account"];
            
            NSLog(@"Setting Delegate to: %@", self);
            [chooseMethodVC setAchSetupDidComplete:self];
            
            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:chooseMethodVC];
            
            
            [self.navigationController presentModalViewController:navBar animated:YES];
            
            
            [navBar release];
            [chooseMethodVC release];
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
        selectModal.headerText = @"Select Your Sending Account";
        selectModal.descriptionText = @"All payments you send will be withdrawn from this bank account.";
        
        [self.view addSubview:selectModal];
        [selectModal show];
    } else  if(indexPath.section == 2){
        selectModal = [[[SelectAccountModalViewControllerViewController alloc] initWithFrame:self.view.bounds] autorelease];
        
        [selectModal setOptionSelectDelegate: self];
        selectModal.bankAccounts = user.bankAccounts;
        selectModal.selectedAccount =user.preferredReceiveAccountId;
        selectModal.accountType = @"Receive";
        selectModal.headerText = @"Select Your Receiving Account";
        selectModal.descriptionText = @"All received payments will be deposited into this bank account.";
        
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
-(void)userACHSetupDidComplete:(NSString*) paymentAccountId
{
    [self.navigationController dismissModalViewControllerAnimated: NO];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    newAccountAdded = true;
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Please wait" withDetailedStatus:@"Loading user accounts"];
    [bankAccountService getUserAccounts: user.userId];
    
}
-(void)userACHSetupDidFail:(NSString*) message {PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Error linking account"];
}
@end
