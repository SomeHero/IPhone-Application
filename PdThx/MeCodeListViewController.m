//
//  MeCodeListViewControllerViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeCodeListViewController.h"
#import "UIProfileTableViewCell.h"
@implementation MeCodeListViewController

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
    [self setTitle: @"MeCodes"];
    
    payPointService = [[PayPointService alloc] init];
    [payPointService setGetPayPointsDelegate:self];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"payPointType == 'MeCode'"];
    
    meCodes = [[user.payPoints filteredArrayUsingPredicate:  predicate] copy];
    
    newPayPointAdded = false;
}
-(void)viewDidAppear:(BOOL)animated {
    
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
    user.payPoints =payPoints;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"payPointType == 'MeCode'"];
    
    meCodes = [[user.payPoints filteredArrayUsingPredicate:  predicate] copy];
    
    [payPointTable reloadData];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    if(newPayPointAdded)
    {
        [appDelegate showAlertWithResult:true withTitle:@"New Linked Pay Point!" withSubtitle:@"You can start receiving funds with this MeCode." withDetailText:@"You are all set to receive funds at this MeCode." withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:@"Ok" withLeftButtonTitleColor:[UIColor darkGrayColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"Cancel" withRightButtonTitleColor:[UIColor darkGrayColor] withTextFieldPlaceholderText: @"" withDelegate:self];
        
        newPayPointAdded = false;
    }
}
-(void)didSelectButtonWithIndex:(int)index
{
    if ( index == 0 ) {
        // Dismiss, error uploading image alert view clicked.
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate dismissAlertView];
        
    }
}
-(void)getPayPointsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([meCodes count] > 0)
        return 2;
    else 
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if([meCodes count] > 0)
    {
        if(section ==0)
            return [meCodes count];
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
    static NSString *CellIdentifier = @"CellIdentifier";

    if([meCodes count] == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }

        cell.textLabel.text = @"Add MeCode";
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

            cell.textLabel.text = @"Add MeCode";
            cell.imageView.image = [UIImage imageNamed: @"img-plus-40x40.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.textLabel.text = [[meCodes objectAtIndex: indexPath.row] uri];
            cell.imageView.image =  [UIImage  imageNamed: @"icon-settings-mecode-40x40.png"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 1 || [meCodes count] == 0)
    {
        AddMeCodeViewController* controller = [[[AddMeCodeViewController alloc] init] retain];
        [controller setTitle: @"Add $MeCode"];
        [controller setHeaderText: @"Create your MeCode, must contain at least 3 AlphaNumeric characters long."];
        [controller setAddPayPointComplete:self];
        
        UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
        
        [self.navigationController presentModalViewController:navBar animated:YES];
        
        [navBar release];
        [controller release];
        
    } else {
        
        PayPoint* payPoint = [meCodes objectAtIndex:indexPath.row];
        
        MeCodeDetailViewController *controller = [[MeCodeDetailViewController alloc] init];
        controller.payPoint = payPoint;
        [controller setDeletePayPointComplete:self];
        
        [controller setTitle: @"MeCode"];
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}
-(void)addPayPointsDidComplete:(NSString*)payPointId {
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    [payPointService getPayPoints:user.userId];
    
    newPayPointAdded = true;
}
-(void)addPayPointsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
}
-(void)deletePayPointCompleted {
    [self.navigationController popViewControllerAnimated:YES];
    
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate showSimpleAlertView: YES withTitle:@"Pay Point Removed" withSubtitle: @"MECode Un-linked From Your Account" withDetailedText: @"You've removed the MECode from your account.  You will no longer receive money sent to this pay point.  In the future, if you wish to use this pay point again, you will need to re-link the mobile # to your account."  withButtonText: @"OK" withDelegate:self];
    
    newPayPointAdded = false;
    
    [payPointService getPayPoints: user.userId];
}
-(void)deletePayPointFailed: (NSString*) errorMessage {
    
}


@end
