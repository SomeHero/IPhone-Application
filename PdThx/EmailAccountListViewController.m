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
    
    newPayPointAdded = false;
    
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
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    if(newPayPointAdded)
    {
        [appDelegate showAlertWithResult:true withTitle:@"New Linked Pay Point!" withSubtitle:@"Action Needed to Complete Setup." withDetailText:@"You've successfully linked an email address to your account.  You need to verify this pay point before this pay point can be used.  We sent an email to this email address with a verification.  To verify this PayPoint, click the link in this email." withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Ok" withRightButtonTitleColor:[UIColor darkGrayColor] withTextFieldPlaceholderText: @"" withDelegate:self];
        
        newPayPointAdded = false;
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
-(void)getPayPointsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
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
        
            EmailAccountDetailViewController *controller = [[EmailAccountDetailViewController alloc] init];
            controller.payPoint = payPoint;
            [controller setDeletePayPointComplete: self];
            
            [controller setTitle: @"Email Account"];
            
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller release];
            
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
-(void)addPayPointsDidComplete:(NSString*)payPointId {
    newPayPointAdded = true;
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    [payPointService getPayPoints: user.userId];
}
-(void)addPayPointsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
}
-(void)deletePayPointCompleted {
    [self.navigationController popViewControllerAnimated:YES];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showSimpleAlertView: YES withTitle:@"Pay Point Removed" withSubtitle: @"Mobile # Un-linked From Your Account" withDetailedText: @"You've removed the mobile # from your account.  You will no longer receive money sent to this pay point.  In the future, if you wish to use this pay point again, you will need to re-link the mobile # to your account."  withButtonText: @"OK" withDelegate:self];
    [payPointService getPayPoints: user.userId];
}
-(void)deletePayPointFailed: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
}

@end
