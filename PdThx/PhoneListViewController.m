//
//  PhoneListViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhoneListViewController.h"
#import "UIProfileTableViewCell.h"

@interface PhoneListViewController ()

@end

@implementation PhoneListViewController

@synthesize newPayPointId;

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
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    if(newPayPointAdded)
    {
        [appDelegate showAlertWithResult:true withTitle:@"New Linked Pay Point!" withSubtitle:@"Action Needed to Complete Setup" withDetailText:@"You've successully linked a phone # to your account.  You need to complete verification of this phone #.  We sent a text to this mobile # with a verification code.  To verify this PayPoint, click verify below and enter the verification code. When you receive it, click the Verify button below." withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Verify" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Cancel" withRightButtonTitleColor:[UIColor darkGrayColor] withTextFieldPlaceholderText: @"" withDelegate:self];
    }
}
-(void)didSelectButtonWithIndex:(int)index
{
    if ( index == 0 && newPayPointAdded) {
        // Dismiss, error uploading image alert view clicked.
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        
        EnterVerificationCodeViewController *controller = [[EnterVerificationCodeViewController alloc] init];
        [controller setVerifyMobilePayPointDelegate: self];

        for(int i =0; i < [user.payPoints count]; i++)
        {
            
            PayPoint* tempPayPoint = [user.payPoints objectAtIndex:i];
            if([tempPayPoint.payPointId isEqualToString:self.newPayPointId])
            {
                controller.payPoint = tempPayPoint;
            }
                
        }
        
        [self.navigationController pushViewController:controller animated:YES];
        
        [controller release];
    } else {
        // Successfully saved image, just go back to personalize screen and load the image.
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        
        newPayPointAdded = false;
        
        // TODO: There needs to be a protocol here to load the image as being on top.
    }
}
-(void)getPayPointsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
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
    if([indexPath section] == 1 || [phones count] == 0)
    {
        AddPhoneViewController* controller = [[AddPhoneViewController alloc] init];
        [controller setTitle: @"Add Mobile #"];
        [controller setHeaderText: @"To add a mobile # to your PaidThx account, enter your new mobile # below."];
        [controller setAddPayPointComplete:self];
        
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
        
        [self.navigationController presentModalViewController:navBar animated:YES];
        
        [navBar release];
        [controller release];
    }
    else {
        PayPoint* currentPayPoint = [phones objectAtIndex:indexPath.row];
        

        PhoneDetailViewController *controller = [[PhoneDetailViewController alloc] init];
        controller.payPoint = currentPayPoint;
        [controller setDeletePayPointComplete:self];
        [controller setVerifyMobilePayPointDelegate:self];
        [controller setTitle: @"Phone #"];
            
        [self.navigationController pushViewController:controller animated:YES];
            
        [controller release];
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
-(void)addPayPointsDidComplete:(NSString*) payPointId {
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    self.newPayPointId = [payPointId copy];
    [payPointService getPayPoints: user.userId];
    
    newPayPointAdded = true;
}
-(void)addPayPointsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
}
-(void)deletePayPointCompleted {
    [self.navigationController popViewControllerAnimated:YES];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showSimpleAlertView: YES withTitle:@"Pay Point Removed" withSubtitle: @"Mobile # Un-linked From Your Account" withDetailedText: @"You've removed the mobile # from your account.  You will no longer receive money sent to this pay point.  In the future, if you wish to use this pay point again, you will need to re-link the mobile # to your account."  withButtonText: @"OK" withDelegate:self];
    
    newPayPointAdded = false;
    
    [payPointService getPayPoints: user.userId];
}
-(void)deletePayPointFailed: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
}
-(void)verifyMobilePayPointDidComplete: (bool) verified {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showSimpleAlertView: YES withTitle:@"Success" withSubtitle: @"Mobile # Verified" withDetailedText: @"You've successfully verified this mobile # and you can now begin receiving money sent to this pay point.  If there are pending payments sent to this pay point, these payment will be processed."  withButtonText: @"OK" withDelegate:self];
    
    newPayPointAdded = false;
    
    [payPointService getPayPoints: user.userId];
}
-(void) verifyMobilePayPointDidFail:(NSString *)errorMessage withErrorCode:(int)errorCode {
    
}
@end
