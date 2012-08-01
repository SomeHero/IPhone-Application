//
//  PhoneListViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhoneListViewController.h"
#import "UIProfileTableViewCell.h"
#import "VerifyPhoneNumberViewController.h"
@interface PhoneListViewController ()

@end

@implementation PhoneListViewController

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
    // Do any additional setup after loading the view from its nib.
    [self setTitle: @"Phones"];
    
    phoneNumberFormatter = [[PhoneNumberFormatting alloc] init];
    
    payPointService = [[PayPointService alloc] init];
    [payPointService setGetPayPointsDelegate:self];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"payPointType == 'Phone'"];
    
    phones = [[user.payPoints filteredArrayUsingPredicate:  predicate] copy];
    
}
-(void)viewDidAppear:(BOOL)animated {
    
    //[payPointService getPayPoints:user.userId ofType:@"Phone"];
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
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"payPointType == 'Phone'"];
    
    phones = [[user.payPoints filteredArrayUsingPredicate:  predicate] copy];
    
    [payPointTable reloadData];
}
-(void)getPayPointsDidFail: (NSString*) errorMessage {
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([phones count] > 0)
        return 2;
    else 
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([phones count] > 0)
    {
        if(section == 0)
            return [phones count];
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
    
    if([phones count] == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = @"Add Mobile Number";
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
        
            cell.textLabel.text = @"Add Mobile Number";
            cell.imageView.image = [UIImage imageNamed: @"img-plus-40x40.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
        else {
            UIProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewCellIdentifier];
            if (cell == nil){
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIProfileTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.lblHeading.text = [phoneNumberFormatter stringToFormattedPhoneNumber: [[phones objectAtIndex: indexPath.row] uri]];
            
            cell.ctrlImage.image =  [UIImage  imageNamed: @"icon-settings-phones-40x40.png"];
            if([[phones objectAtIndex: indexPath.row] verified])
            {
                cell.lblDescription.text = @"Verified";
            }
            else {
                cell.lblDescription.text = @"Pending Verification";
            }
            
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
    switch(indexPath.section) {
        case 0:
        {
            PayPoint* payPoint = [phones objectAtIndex:indexPath.row];
              
            if([payPoint verified])
            {
                PhoneDetailViewController *controller = [[PhoneDetailViewController alloc] init];
                controller.payPoint = payPoint;
                [controller setDeletePayPointComplete:self];
                
                [controller setTitle: @"Phone #"];
                    
                [self.navigationController pushViewController:controller animated:YES];
            }
            else 
            {
                VerifyPhoneNumberViewController *controller = [[VerifyPhoneNumberViewController alloc] init];
                controller.payPoint = payPoint;
                    
                [controller setTitle: @"Verify"];
                    
                [self.navigationController pushViewController:controller animated:YES];
            }

            break;
        }
        case 1:
        {
            
            AddPhoneViewController* controller = [[AddPhoneViewController alloc] init];
            [controller setTitle: @"Add Mobile #"];
            [controller setHeaderText: @"To add a mobile # to your PaidThx account, enter your new mobile # below."];
            [controller setAddPayPointComplete:self];
            
            UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
            
            [self.navigationController presentModalViewController:navBar animated:YES];
            
            [navBar release];
            [controller release];

            break;
        }

    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    AddPhoneViewController* controller = [[AddPhoneViewController alloc] init];
//    [controller setTitle: @"Add Mobile #"];
//    [controller setHeaderText: @"To add a mobile # to your PaidThx account, enter your new mobile # below."];
//    [controller setAddPayPointComplete:self];
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
