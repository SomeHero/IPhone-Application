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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [viewPanel.layer setMasksToBounds:YES];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    scrollview.frame = CGRectMake(0, 0, 320, 460);
    [scrollview setContentSize:CGSizeMake(320, 800)];
    
    bankAccountService = [[BankAccountService alloc] init];
    [bankAccountService setBankAccountRequestDelegate: self];

    [userAccountsTableView setRowHeight:120];
    [userAccountsTableView setEditing:NO];
    [userAccountsTableView setDelegate:self];
    [userAccountsTableView setDataSource: self];

}
-(void)viewDidAppear:(BOOL)animated
{
    [bankAccountService getUserAccounts: user.userId];
}

- (IBAction)addAccountClicked:(id)sender {
    AddACHAccountViewController* controller = [[AddACHAccountViewController alloc] init];
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    
    [self presentModalViewController:navBar animated:YES];
    [navBar release];
    [controller release];
}
-(void)getUserAccountsDidComplete:(NSMutableArray*)bankAccounts {
    userBankAccounts = [bankAccounts copy];
    
    [userAccountsTableView reloadData];
    //[senderAccountPickerView reloadAllComponents];
    //[receiveAccountPickerView reloadAllComponents];
}
-(void)getUserAccountsDidFail:(NSString*)errorMessage {
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [userBankAccounts count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[userBankAccounts objectAtIndex:row] accountNumber];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    [userAccountsTableView  setFrame: CGRectMake(0, userAccountsTableView.frame.origin.y, userAccountsTableView.frame.size.width, [userBankAccounts count]*120)];
    
    [editAccountView setFrame: CGRectMake(0, userAccountsTableView.frame.origin.y + userAccountsTableView.frame.size.height + 1, editAccountView.frame.size.width, editAccountView.frame.size.height)];
    
    return [userBankAccounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"accountCell";
    
    UIAccountTableCell* cell = (UIAccountTableCell*)[userAccountsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIAccountTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    BankAccount* item = [userBankAccounts objectAtIndex: 0];
    
    cell.lblAccountInformation.text = item.accountNumber;

    return cell;
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

@end
