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
    
    UIBarButtonItem *saveButton =  [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonSystemItemAction target:self action:@selector(saveClicked)];
    
    attributeValues = [[NSMutableArray alloc] init];
    
    self.navigationItem.rightBarButtonItem= saveButton;
    [saveButton release];
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

-(void)saveClicked {
    for(int i; i < [attributeValues count]; i++)
    {
        UserAttribute* attribute = [attributeValues objectAtIndex:i];
        
        
    }
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
        {
            ProfileItem* profileItem = [[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row - 1];
            
            if([profileItem.itemType isEqualToString: @"LongText"])
                return 120;
        }
    } else {
        
        ProfileItem* profileItem = [[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row];
        
        if([profileItem.itemType isEqualToString: @"LongText"])
            return 120;
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
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UICustomProfileHeaderViewController" owner:self options:nil];
                cell = [nib objectAtIndex:0];

            
            
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
            }
            ProfileItem* profileItem = [[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row - 1];
            
            
            return [self renderCell:cell withProfileItem: profileItem];
            
        }
    }
    else {
        UICustomProfileRowViewController *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UICustomProfileRowViewController" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        ProfileItem* profileItem = [[[profileSections objectAtIndex:indexPath.section] profileItems] objectAtIndex:indexPath.row];
        
        return [self renderCell:cell withProfileItem: profileItem];
    }
}
-(UITableViewCell*)renderCell: (UICustomProfileRowViewController*) cell withProfileItem:(ProfileItem*) profileItem
{
    cell.lblAttributeName.text = [profileItem label];
    
    
    if([[profileItem itemType] isEqualToString: @"ShortText"])
    {
        UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        txtField.delegate = self;
        txtField.tag = profileItem.itemId;
        
        bool found = NO;
        for(int i = 0; i < [user.userAttributes count]; i++)
        {
            UserAttribute* userAttribute = [user.userAttributes objectAtIndex:i];
            
            if([profileItem.attributeId isEqualToString:userAttribute.attributeId])
            {
                txtField.text = userAttribute.attributeValue;
                found = YES;
            }
        }
        
        if(!found) {
            txtField.text = [NSString stringWithFormat:@"Add +%d", profileItem.points];
            txtField.clearsOnBeginEditing = YES;
        }
        
        [cell.txtAttributeValue addSubview:txtField];

    } 
    else if([[profileItem itemType] isEqualToString: @"ImageCapture"])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 150, 30);
        [btn setTitle:@"take picture" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(captureImage:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setBackgroundColor: [UIColor clearColor]];
        [btn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
        
        [cell.txtAttributeValue addSubview:btn];
        
    } else if([[profileItem itemType] isEqualToString: @"SocialAccount"])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 150, 30);
        [btn setTitle:@"link account" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(linkAccount:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setBackgroundColor: [UIColor clearColor]];
        [btn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
        
        [cell.txtAttributeValue addSubview:btn];
        
    } 
    else if([[profileItem itemType] isEqualToString: @"Picker"])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 150, 30);
        [btn setTitle:@"select" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(linkAccount:) forControlEvents:UIControlEventTouchUpInside];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setBackgroundColor: [UIColor clearColor]];
        [btn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
        
        [cell.txtAttributeValue addSubview:btn];
        
    }
    else if([[profileItem itemType] isEqualToString: @"LongText"]) {
        
        UITextView* txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, cell.txtAttributeValue.frame.size.width, cell.txtAttributeValue.frame.size.height*3)];
        
        [cell.txtAttributeValue addSubview:txtView];
        
        [txtView release];
    }
    else if([[profileItem itemType] isEqualToString: @"Switch"])
    {
        UISwitch* switchItem = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, cell.txtAttributeValue.frame.size.width, cell.txtAttributeValue.frame.size.height)];
        
        
        
        [cell.txtAttributeValue addSubview:switchItem];
        
        [switchItem release];
        
    }
    
    
    return cell;

}
-(void)captureImage:(id)sender; {
    ChoosePictureViewController* controller = [[ChoosePictureViewController alloc] init];
    [controller setTitle: @"Choose Picture"];
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    
    [self.navigationController presentModalViewController:navBar animated:YES];
    
    [navBar release];
    [controller release];
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
#pragma mark UITextFieldDelegate methods
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UserAttribute* updatedAttribute = [[UserAttribute alloc] init];
    updatedAttribute.attributeId = [NSString stringWithFormat: @"%d", textField.tag];
    updatedAttribute.attributeValue = textField.text;
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if(textField.tag == 1)
    {
        [textField setText: @"$0.00"];
        
        return NO;
    } 
    
    return YES;
} 
@end
