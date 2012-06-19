//
//  ProfileController.m
//  Fanatical
//
//  Created by James Rhodes on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"
#import "PdThxAppDelegate.h"
#import "MeCodeViewController.h"

#import "MECodeSetupViewController.h"

#define kScreenWidth  320
#define kScreenHeight  400

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
    [oldSecurityPin release];
    [newSecurityPin release];
    [securityPinModal release];
    [confirmSecurityPinModal release];
    
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
    
    userService = [[UserService alloc] init];
    [userService setUserSecurityPinCompleteDelegate:self];
    
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString *optionSection = [sections objectAtIndex:[indexPath section]];
    
    NSArray *profileSection = [profileOptions objectForKey:optionSection];
    
    // Configure the cell...
    NSLog(@"Section:%d Label:%@", indexPath.section, [[profileSection objectAtIndex:[indexPath row]] objectForKey:@"Label"] );
    if ([[[profileSection objectAtIndex:[indexPath row]]objectForKey:@"Label"]isEqual: @"Security Pin"]) {
        if ([prefs boolForKey:@"setupSecurityPin"]) {
            cell.textLabel.text = @"Change Security Pin";
        }
        else {
            cell.textLabel.text = @"Setup Security Pin";
        }
    }
    else {
        
        cell.textLabel.text = [[profileSection objectAtIndex:[indexPath row]] objectForKey:@"Label"];
        
    }
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    switch(indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {   
                    ChangeSecurityPinController *controller = [[ChangeSecurityPinController alloc] initWithNibName:@"ChangeSecurityPinController" bundle:nil];
                    
                    [self.navigationController pushViewController:controller animated:YES];
                    break;
                }
                case 1:
                {
                    MeCodeViewController *VC = [[MeCodeViewController alloc] initWithNibName:@"MeCodeViewController" bundle:nil];
                    [self.navigationController pushViewController:VC animated:YES];                  break; 
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

- (void) showOldSecurityPin {
    securityPinModal = [[[SetupSecurityPin alloc] initWithFrame:self.view.bounds] autorelease];
    
    securityPinModal.delegate = self;
    securityPinModal.lblTitle.text = @"Input Your Old Pin";
    securityPinModal.lblHeading.text = @"";
    securityPinModal.tag = 1;
    
    ///////////////////////////////////
    // Add the panel to our view
    [self.view addSubview:securityPinModal];
    
    ///////////////////////////////////
    // Show the panel from the center of the button that was pressed
    [securityPinModal show];  
}

- (void) showNewSecurityPin {
    securityPinModal = [[[SetupSecurityPin alloc] initWithFrame:self.view.bounds] autorelease];
    
    securityPinModal.delegate = self;
    securityPinModal.lblTitle.text = @"Input Your New Pin";
    securityPinModal.lblHeading.text = @"";
    securityPinModal.tag = 2;
    
    ///////////////////////////////////
    // Add the panel to our view
    [self.view addSubview:securityPinModal];
    
    ///////////////////////////////////
    // Show the panel from the center of the button that was pressed
    [securityPinModal show];  
}

-(void) securityPinComplete:(SetupSecurityPin*) modalPanel 
               selectedCode:(NSString*) code {
    
    if([code length] < 4) {
        [self showAlertView:@"Invalid Pin" withMessage:@"Select atleast 4 dots when setting up a pin"];
    } else {
        [modalPanel hide];
        
        
        if (modalPanel.tag == 1) {
            oldSecurityPin = [[NSString alloc] initWithString: code];
            [self showNewSecurityPin];
        }
        else if (modalPanel.tag == 2) {
            newSecurityPin = [[NSString alloc] initWithString: code];
            
            modalPanel.lblTitle.text = @"Confirm Your Pin";
            modalPanel.lblHeading.text = @"";
            
            [modalPanel setNeedsDisplay];
            
            [self showConfirmSecurityPin];
        }
    }
    
    
}

-(void) showConfirmSecurityPin {
    confirmSecurityPinModal = [[ConfirmSecurityPinDialog alloc] initWithFrame:self.view.bounds];
    
    confirmSecurityPinModal.tag = 3;
    confirmSecurityPinModal.delegate = self;
    
    ///////////////////////////////////
    // Add the panel to our view
    [self.view addSubview:confirmSecurityPinModal];
    
    ///////////////////////////////////
    // Show the panel from the center of the button that was pressed
    [confirmSecurityPinModal show];
}
-(void) confirmSecurityPinComplete:(ConfirmSecurityPinDialog*) modalPanel 
                      selectedCode:(NSString*) code {
    
    if([code length] < 4) {
        [self showAlertView:@"Invalid Pin" withMessage:@"Your pin is atleast 4 dots"];
    }
    else if(![code isEqualToString:newSecurityPin])
        [self showAlertView: @"Pin Mismatch" withMessage:@"The pins don't match. Try again"];
    else {
        [modalPanel hide];
        [modalPanel removeFromSuperview];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)]; // I do this because I'm in landscape mode
        [self.view addSubview:spinner]; // spinner is not visible until started
        
        [spinner startAnimating];
        
        //Do something.
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString* userId = [prefs stringForKey:@"userId"];
        
        
        if (oldSecurityPin != NULL) {
            [userService changeSecurityPin:userId WithOld:oldSecurityPin AndNew:newSecurityPin];
        }
        else {
            [userService setupSecurityPin:userId WithPin:newSecurityPin];
        }
        
        
        
    }
    
}

-(void) userSecurityPinDidComplete {
    [spinner stopAnimating];
    
    [self showAlertView: @"Security Pin Change Success!" withMessage: @"Security Pin successfully changed."];
}

-(void) userSecurityPinDidFail: (NSString*) message {
    [spinner stopAnimating];
    
    [self showAlertView: @"Security Pin Change Failed" withMessage: message];
}



@end
