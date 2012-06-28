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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [bankAccountService getUserAccounts: user.userId];
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
    userBankAccounts = bankAccounts;
    
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
        return 2;
    else if(section == 1)
        return 1;
    else {
        return [userBankAccounts count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(indexPath.section == 2)
    {
        if(indexPath.row == 1)
            cell.textLabel.text = @"Preferred Send Account";
        else
            cell.textLabel.text = @"Preferred Receive Account";
    }
    else if(indexPath.section == 1)
        cell.textLabel.text = @"Add Account";
    else {
        cell.textLabel.text = [[userBankAccounts objectAtIndex: indexPath.row] nickName];
    cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-bank-40x40.png"];
    //cell.imageView.highlightedImage = [UIImage  imageNamed:[[profileSection objectAtIndex:[indexPath row]] objectForKey:@"HighlightedImage"]];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
    if(indexPath.section == 0)  {
        EditACHAccountViewController* controller = [[EditACHAccountViewController alloc] init];
        controller.bankAccount = [userBankAccounts objectAtIndex: indexPath.row];
        
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    } else if(indexPath.section == 1){
        AddACHAccountViewController* controller = [[AddACHAccountViewController alloc] init];
        
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    } else {
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
        myPickerView.delegate = self;
        myPickerView.showsSelectionIndicator = YES;

        [self.view addSubview:myPickerView];
        
        [myPickerView reloadAllComponents];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    [bankAccountService setPreferredReceiveAccount:[[userBankAccounts objectAtIndex:row] bankAccountId] forUserId:user.userId];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [userBankAccounts count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [@"" stringByAppendingFormat:@"%@", [[userBankAccounts objectAtIndex:row] nickName]];

    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}
-(void)setPreferredAccountDidComplete {
    
    [myPickerView removeFromSuperview];
}
-(void)setPreferredAccountDidFail:(NSString*)errorMessage {
    
    [myPickerView removeFromSuperview];
}

-(void) userSecurityPinDidComplete {
    //[spinner stopAnimating];
    
    [self showAlertView: @"Security Pin Change Success!" withMessage: @"Security Pin successfully changed."];
}

-(void) userSecurityPinDidFail: (NSString*) message {
    //[spinner stopAnimating];
    
    [self showAlertView: @"Security Pin Change Failed" withMessage: message];
}

@end
