//
//  SharingPreferencesViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharingPreferencesViewController.h"

@interface SharingPreferencesViewController ()

@end

@implementation SharingPreferencesViewController

@synthesize notificationOptions;
@synthesize sections;

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
    [self setTitle: @"Sharing"];
    
    userConfigurationService= [[UserConfigurationService alloc] init];
    [userConfigurationService setUserConfigurationCompleteDelegate: self];
    
    configurationKeys = [[NSMutableArray  alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sharing" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.notificationOptions = dic;
    [dic release];
    
    NSArray *array = [[notificationOptions allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.sections = array;
    
    sections = array;
    
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

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sections objectAtIndex:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    label.font = [UIFont boldSystemFontOfSize:12];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *optionSection = [sections objectAtIndex:section];
    
    NSArray *profileSection = [notificationOptions objectForKey:optionSection];
    
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
    
    NSArray *notificationItems = [notificationOptions objectForKey:optionSection];
                          
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"Key == %@", [[notificationItems objectAtIndex:indexPath.row] valueForKey: @"ConfigurationKey"]];

    NSArray* results = [user.userConfigurationItems filteredArrayUsingPredicate:  predicate];
    
    BOOL configurationValue = false;
    
    if([results count] == 1)
        configurationValue = [[[results objectAtIndex:0] Value] boolValue];
    
    [configurationKeys addObject:  [[notificationItems objectAtIndex:[indexPath row]] objectForKey:@"ConfigurationKey"]];
    cell.textLabel.text = [[notificationItems objectAtIndex:[indexPath row]] objectForKey:@"Description"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    [switchView setTag: [configurationKeys count] - 1];

    if(configurationValue)
        [switchView setOn:YES animated:NO];
    else
        [switchView setOn:NO animated:NO];

    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [switchView release];
    
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
    
}
- (void) switchChanged:(id)sender {
    
    UISwitch* switchControl = sender;
    
    UserConfiguration* configurationItem = [[UserConfiguration alloc] init];
    configurationItem.Key = [configurationKeys objectAtIndex:switchControl.tag];
    if(switchControl.on){
        configurationItem.Value = @"true";
    }
    else {
        configurationItem.Value = @"false";
    }
    
    [userConfigurationService updateUserConfiguration:configurationItem.Value forKey:configurationItem.Key forUserId:user.userId];
    
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}
-(void)getUserConfigurationDidComplete: (NSMutableArray*) userSettings {
    user.userConfigurationItems = userSettings;
    
    [tableUserSettings reloadData];
}
-(void)getUserConfigurationDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
}
-(void)updateUserConfigurationDidComplete: (NSString*) configurationKey  withValue:(NSString*) configurationValue {
    NSLog(@"%@", @"Update Configuration");
    
    bool found = false;
    for(int i = 0; i < [user.userConfigurationItems count]; i++)
    {
        UserConfiguration* configurationItem = [user.userConfigurationItems objectAtIndex:i];
        
        if([configurationKey isEqualToString:configurationItem.Key])
        {
            configurationItem.Value = configurationValue;
            found = true;
        }
    }
    
    if(!found)
    {
        UserConfiguration* newConfigurationItem = [[UserConfiguration alloc] init];
        newConfigurationItem.Key = configurationKey;
        newConfigurationItem.Value = configurationValue;
        
        [user.userConfigurationItems addObject: newConfigurationItem];
        
        [newConfigurationItem release];
    }
}
-(void)updateUserConfigurationDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    
}

@end
