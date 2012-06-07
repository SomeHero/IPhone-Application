//
//  ProfileController.m
//  Fanatical
//
//  Created by James Rhodes on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"
#import "PdThxAppDelegate.h"
#import "MECodeSetupViewController.h"

@implementation ProfileController
@synthesize profileOptions, sections;

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
    [profileOptions release];
    [sections release];
    
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
    self.title = @"Settings";

    NSString *path = [[NSBundle mainBundle] pathForResource:@"options" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.profileOptions = dic;
    [dic release];
    
    NSArray *array = [[profileOptions allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.sections = array;

    [super viewDidLoad];
    //self.clearsSelectionOnViewWillAppear = NO;
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *optionSection = [sections objectAtIndex:section];
    
    NSArray *profileSection = [profileOptions objectForKey:optionSection];
    
    return [profileSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString *optionSection = [sections objectAtIndex:[indexPath section]];
    
    NSArray *profileSection = [profileOptions objectForKey:optionSection];
    
    // Configure the cell...
    NSLog(@"Section:%d Label:%@", indexPath.section, [[profileSection objectAtIndex:[indexPath row]] objectForKey:@"Label"] );
    cell.textLabel.text = [[profileSection objectAtIndex:[indexPath row]] objectForKey:@"Label"];
    cell.imageView.image =  [UIImage  imageNamed:[[profileSection objectAtIndex:[indexPath row]] objectForKey:@"Image"]];
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
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    switch(indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: {
                    MECodeSetupViewController * vC = [[MECodeSetupViewController alloc] initWithNibName:@"MECodeSetupViewController" bundle:nil];
                    
                    [self.navigationController pushViewController:vC animated:YES];
                    break;
                }
                    
                default:
                    break;
            } 
        case 1:
            break;
        case 2:
            break;
        case 3:
            switch(indexPath.row) {
                case 0: {
                    [appDelegate forgetMe];
                    
                    }
                
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    
}



@end
