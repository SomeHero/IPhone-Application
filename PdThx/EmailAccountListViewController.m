//
//  EmailAccountListViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmailAccountListViewController.h"
#import "VerifyEmailViewController.h"
#import "UIProfileTableViewCell.h"
@interface EmailAccountListViewController ()

@end

@implementation EmailAccountListViewController

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
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"payPointType == 'EmailAddress'"];

    // Do any additional setup after loading the view from its nib.
    emailAddresses = [[user.payPoints filteredArrayUsingPredicate:  predicate] copy];
    
    payPointService = [[PayPointService alloc] init];
    [payPointService setGetPayPointsDelegate:self];
    
    [self setTitle: @"Email Accounts"];
    
}
-(void)viewDidAppear:(BOOL)animated {
    
    //[payPointService getPayPoints:user.userId ofType:@"EmailAddress"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)getPayPointsDidComplete:(NSMutableArray*)payPoints {
    user.payPoints = payPoints;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"payPointType == 'EmailAddress'"];
    
    // Do any additional setup after loading the view from its nib.
    emailAddresses = [[user.payPoints filteredArrayUsingPredicate:  predicate] copy];
    
    [payPointTable reloadData];
}
-(void)getPayPointsDidFail: (NSString*) errorMessage {
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([emailAddresses count] > 0)
        return 2;
    else 
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([emailAddresses count] > 0)
    {
        if(section ==0)
            return [emailAddresses count];
        else {
            return 1;
        }
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomTableViewCellIdentifier = @"CustomTableViewCell";
    static NSString *CellIdentifier = @"CellIdentifier";

    if([emailAddresses count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = @"Add Email Address";
        cell.imageView.image = [UIImage imageNamed: @"img-plus-40x40.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else 
    {
        if(indexPath.section == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.textLabel.text = @"Add Email Address";
            cell.imageView.image = [UIImage imageNamed: @"img-plus-40x40.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;   
        }
        else {
            		
            UIProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewCellIdentifier];
            if (cell == nil) {
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIProfileTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.lblHeading.text = [[emailAddresses objectAtIndex: indexPath.row] uri];
            if([[emailAddresses objectAtIndex:indexPath.row] verified])
                cell.lblDescription.text =@"Verified";
            else
                cell.lblDescription.text = @"Pending Verification";
            
            cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-email-40x40.png"];
            //cell.imageView.highlightedImage = [UIImage  imageNamed:[[profileSection objectAtIndex:[indexPath row]] objectForKey:@"HighlightedImage"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
    }
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
-(void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([indexPath section] == 1 || [emailAddresses count] == 0)
    {
        AddEmailAddressViewController* controller = [[AddEmailAddressViewController alloc] init];
        [controller setTitle: @"Add Email"];
        [controller setHeaderText: @"To add an email address# to your PaidThx account, enter the email address below."];
        [controller setAddPayPointComplete:self];
        
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
        
        [self.navigationController presentModalViewController:navBar animated:YES];
        
        [navBar release];
        [controller release];   
    }
    else {
        PayPoint* payPoint = [emailAddresses objectAtIndex:indexPath.row];
        
        if([payPoint verified])
        {
            EmailAccountDetailViewController *controller = [[EmailAccountDetailViewController alloc] init];
            controller.payPoint = payPoint;
            [controller setDeletePayPointComplete: self];
            
            [controller setTitle: @"Email Account"];
            
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller release];
            
        }
        else {
            VerifyEmailViewController *controller = [[VerifyEmailViewController alloc] init];
            controller.payPoint = payPoint;
            
            [controller setTitle: @"Verify"];
            
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller release];
        }
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    AddEmailAddressViewController* controller = [[AddEmailAddressViewController alloc] init];
//    [controller setTitle: @"Add Email"];
//    [controller setHeaderText: @"To add a new email address to your PaidThx account, enter it below."];[controller setAddPayPointComplete:self];
//    
//    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
//    
//    [self.navigationController presentModalViewController:navBar animated:YES];
//    
//    [navBar release];
//    [controller release];
//}
-(void)addPayPointsDidComplete {
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    [payPointService getPayPoints: user.userId];
}
-(void)addPayPointsDidFail: (NSString*) errorMessage {
    
}
-(void)deletePayPointCompleted {
    [self.navigationController popViewControllerAnimated:YES];
    
    [payPointService getPayPoints: user.userId];
}
-(void)deletePayPointFailed: (NSString*) errorMessage {
    
}

@end
