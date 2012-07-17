//
//  EditProfileViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

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
    profileSections = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).myApplication.profileSections;
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [profileSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1 + [[profileSections objectAtIndex: section] profileItems].count;
    else {
         return [[profileSections objectAtIndex: section] profileItems].count;
    }
}
- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
            return 90;
        else 
            return 45;
    }
    
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *HeaderCellIdentifier = @"Header";

    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            UICustomProfileHeaderViewController *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
            if (cell == nil){
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UICustomProfileHeaderViewController" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
            }
            
            
            [cell.btnUserImage.layer setCornerRadius:6.0];
            [cell.btnUserImage.layer setMasksToBounds:YES];
            
            if(user.imageUrl != (id)[NSNull null] && [user.imageUrl length] > 0) {
                [cell.btnUserImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: user.imageUrl]]] forState:UIControlStateNormal];
            }else {
                [cell.btnUserImage setBackgroundImage:[UIImage imageNamed: @"avatar_unknown.jpg"] forState:UIControlStateNormal];
            }
            
            
            return cell;
            
        }
        else {
            UICustomProfileRowViewController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UICustomProfileRowViewController" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
                ProfileItem* profileItem = [[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row - 1];
                
                cell.lblAttributeName.text = [profileItem label];
                
                for(int i = 0; i < [user.userAttributes count]; i++)
                {
                    UserAttribute* userAttribute = [user.userAttributes objectAtIndex:i];
                    if([profileItem.attributeId isEqualToString:userAttribute.attributeId])
                    {
                        cell.txtAttributeValue.text = [userAttribute attributeValue];
                    }
                }
                
                
                return cell;
            }
        }
    }
    else {
        UICustomProfileRowViewController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UICustomProfileRowViewController" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.lblAttributeName.text = [[[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row] label];
            //cell.txtAttributeValue.text = [[[profileSections objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row - 1]  attributeValue];
            
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        ChoosePictureViewController* controller = [[ChoosePictureViewController alloc] init];
        [controller setTitle: @"Choose Picture"];
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
        
        [self.navigationController presentModalViewController:navBar animated:YES];
        
        [navBar release];
        [controller release];
    }
}


@end
