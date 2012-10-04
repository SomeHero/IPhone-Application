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
#import "AddACHOptionsViewController.h"
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
    
    userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)getUserAccountsDidComplete:(NSMutableArray*)bankAccounts
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    user.bankAccounts = bankAccounts;
    [userAccountsTableView reloadData];
    
    if(newAccountAdded)
    {
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

-(void)getUserAccountsDidFail:(NSString*)errorMessage withErrorCode:(int)errorCode
{
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
    if(indexPath.section == 1)
    {
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

 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
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
            
            if([user.bankAccounts count] > 0)
            {
            ChooseAddACHMethodViewController* chooseMethodVC = [[[ChooseAddACHMethodViewController alloc] init] autorelease];
            [chooseMethodVC setNavigationTitle:@"Add Bank Account"];
            [chooseMethodVC setTitle:@"Add Bank Account"];
            [chooseMethodVC setAchSetupComplete:self];
            
            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:chooseMethodVC];
            
            [self.navigationController presentModalViewController:navBar animated:YES];
            
            [navBar release];
            
        } else {
                AddACHOptionsViewController* controller = [[[AddACHOptionsViewController alloc] init] autorelease];
                [controller setAchSetupComplete: self];
                
                UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
                
                [self.navigationController presentModalViewController:navBar animated:YES];
                
                [navBar release];
                
            }
        } else {
            EditACHAccountViewController* controller = [[[EditACHAccountViewController alloc] init] autorelease];
            [controller setDeleteBankAccountProtocol: self];
            
            controller.bankAccount = [user.bankAccounts objectAtIndex: indexPath.row];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if(indexPath.section == 1)
    {
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
-(void) userSecurityPinDidFail: (NSString*) message withErrorCode:(int)errorCode {
    //[spinner stopAnimating];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Invalid security pin"];
}
-(void) optionDidSelect:(NSString*) optionId {
    
    selectedOption = optionId;
    accountType = selectModal.accountType;
    
    [selectModal hide];
    
    [self startSecurityPin];
}
-(void) startSecurityPin
{
    GenericSecurityPinSwipeController *controller=[[[GenericSecurityPinSwipeController alloc] init] autorelease];
    [controller setSecurityPinSwipeDelegate: self];
    
    /*
     Custom Security Pin Swipe Controller Example
     -==============================================-
     
     recipientName = @"Ryan Ricigliano";
     deliveryCharge = 0.0;
     amount = 14.59;
     deliveryType = @"Express";
     lblHeader.text = @"SWIPE YOUR SECURITY PIN TO CONFIRM";
     */
    
    if(accountType == @"Send")
    {
        [controller setNavigationTitle: @"Confirm Changes"];
        [controller setHeaderText:@"SWIPE YOUR SECURITY PIN TO CONFIRM CHANGES TO YOUR SEND ACCOUNT"];
    }
    else
    {
        [controller setNavigationTitle: @"Confirm Changes"];
        [controller setHeaderText:@"SWIPE YOUR SECURITY PIN TO CONFIRM CHANGES TO YOUR RECEIVE ACCOUNT"];

    }
    
    [self.navigationController presentModalViewController:controller animated:YES];
    
}

-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    if(accountType == @"Send") {
        [bankAccountService setPreferredSendAccount:selectedOption forUserId:user.userId withSecurityPin:pin];
    }
    else {
        [bankAccountService setPreferredReceiveAccount:selectedOption forUserId:user.userId withSecurityPin:pin];
    }
}

-(void)swipeDidCancel: (id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)setPreferredAccountDidComplete {

    if(accountType == @"Send") {
        user.preferredPaymentAccountId = selectedOption;
    }
    else {
        user.preferredReceiveAccountId = selectedOption;
    }
    [userAccountsTableView reloadData];
}
-(void)setPreferredAccountDidFail:(NSString*)message withErrorCode:(int)errorCode {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];

    [appDelegate handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Setting Preferred Account"];

}

-(void)achSetupDidComplete {
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ 
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
        user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
        [userAccountsTableView reloadData];
    });
}
-(void)userACHSetupDidFail:(NSString*) message withErrorCode:(int)errorCode {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Error linking account"];
}

-(void)deleteBankAccountDidComplete {
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController popViewControllerAnimated: YES];
        
        [userService getUserInformation: user.userId];
    });
}
-(void)deleteBankAccountDidFail:(NSString*)errorMessage withErrorCode:(int)errorCode {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate handleError:errorMessage withErrorCode:errorCode withDefaultTitle: @"Error Deleting Account"];
}

-(void)userInformationDidComplete:(User*)userInfo {
    ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user= userInfo;
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    [userAccountsTableView reloadData];
}
-(void)userInformationDidFail:(NSString*) message withErrorCode:(int)errorCode {
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) handleError:message withErrorCode:errorCode withDefaultTitle: @"Error Refreshing User"];
}

@end
