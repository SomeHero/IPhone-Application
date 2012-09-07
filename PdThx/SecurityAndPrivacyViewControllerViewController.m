//
//  SecurityAndPrivacyViewControllerViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecurityAndPrivacyViewControllerViewController.h"


@implementation SecurityAndPrivacyViewControllerViewController

@synthesize profileOptions, sections, currentUser, validationHelper;
@synthesize  savedPinSwipe, anotherSavedPinSwipe;
@synthesize userService;

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
    [self setTitle: @"Security & Privacy"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"security" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.profileOptions = dic;
    [dic release];
    
    NSArray *array = [[profileOptions allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.sections = array;
    
    [super viewDidLoad];
    //self.clearsSelectionOnViewWillAppear = NO;
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"SecurityAndPrivacyController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    validationHelper = [[ValidationHelper alloc] init];
    userService = [[UserService alloc] init];
    currentUser = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
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
    cell.imageView.highlightedImage = [UIImage  imageNamed:[[profileSection objectAtIndex:[indexPath row]] objectForKey:@"HighlightedImage"]];
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
    // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    switch(indexPath.section) 
    {
        case 0:
        {
            switch (indexPath.row) 
            {
                case 0:
                {
                    ChangePasswordViewController* controller = [[ChangePasswordViewController   alloc] init];
                    [controller setTitle: @"Change Password"];
                    [controller setHeaderText: @"To change your password, enter your current password and your new password below."];
                    
                    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
                    
                    [self.navigationController presentModalViewController:navBar animated:YES];
                    
                    [navBar release];
                    [controller release];
                    
                    break;
                }
                case 1:
                {
                    GenericSecurityPinSwipeController*pinSwipe = [[GenericSecurityPinSwipeController alloc] init];
                    [pinSwipe setNavigationTitle:@"Change Security Pin"];
                    [pinSwipe setHeaderText: @"To change your security pin, you must first swipe your current security pin."];
                    [pinSwipe setSecurityPinSwipeDelegate:self];
                    [pinSwipe setTag:0];
                    
                    [self.navigationController presentModalViewController:pinSwipe animated:YES];
                    break;
                }
                case 2:
                {
                    SecurityQuestionChallengeViewController* controller = [[SecurityQuestionChallengeViewController alloc] init];
                    [controller setTitle: @"Security Question"];
                    [controller setHeaderText: [NSString stringWithFormat:@"To continue, provide the answer to the security question you setup when you created your account."]]; 
                    controller.currUser = [user copy];
                    [controller setSecurityQuestionChallengeDelegate:self];
                    
                    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
                    [self.navigationController presentModalViewController:navBar animated:YES];
                    [controller release];
                }
            
            }
        }
    }

}

-(void) securityQuestionAnsweredCorrect
{
    [self dismissModalViewControllerAnimated: NO];
    
    GenericSecurityPinSwipeController*pinSwipe = [[GenericSecurityPinSwipeController alloc] init];
    [pinSwipe setNavigationTitle:@"Forgot Security Pin"];
    [pinSwipe setHeaderText: @"Enter your NEW Security Pin:"];
    [pinSwipe setSecurityPinSwipeDelegate:self];
    [pinSwipe setTag:1];
    
    [self presentModalViewController:pinSwipe animated:YES];
    
}

-(void)swipeDidCancel:(id)sender
{
    [sender dismissModalViewControllerAnimated:YES];
}

-(void)swipeDidComplete:(id)sender withPin: (NSString*)pin
{
    [sender dismissModalViewControllerAnimated:NO];
    
    if ( [sender tag] == 0 )
    {
        // User Completed First Swipe of Change Security Pin
        // Verify that it matches the user's security pin
        if ( [validationHelper isValidSecurityPinSwipe:pin] ){
            savedPinSwipe = pin;
            
            GenericSecurityPinSwipeController*pinSwipe = [[GenericSecurityPinSwipeController alloc] init];
            [pinSwipe setNavigationTitle:@"Change Security Pin"];
            [pinSwipe setHeaderText: @"Enter a NEW Security Pin for your account"];
            [pinSwipe setSecurityPinSwipeDelegate:self];
            [pinSwipe setTag:1];
            
            [self presentModalViewController:pinSwipe animated:YES];
        }
    }
    else if ( [sender tag] == 1 )
    {
        // User entered first swipe of NEW Security Pin. Validate Length, and ask for second confirmation pin.
        if ( ![validationHelper isValidSecurityPinSwipe:pin] ) {
            PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Connect 4+ dots"];
        } else {
            anotherSavedPinSwipe = pin;
            
            GenericSecurityPinSwipeController*pinSwipe = [[GenericSecurityPinSwipeController alloc] init];
            [pinSwipe setNavigationTitle:@"Change Security Pin"];
            [pinSwipe setHeaderText: @"Confirm your NEW Security pin by swiping it again"];
            [pinSwipe setSecurityPinSwipeDelegate:self];
            [pinSwipe setTag:2];
            
            [self presentModalViewController:pinSwipe animated:YES];
        }
    }
    else if ( [sender tag] == 2 )
    {
        // User confirmed pin of NEW Security pin. Confirm it matches saved pin, and submit service with old saved pin.
        if ( [validationHelper verifySecurityPinsMatch:anotherSavedPinSwipe andSecondPin:pin] )
        {
            [userService setUserSecurityPinCompleteDelegate:self];
            [userService changeSecurityPin:user.userId WithOld:savedPinSwipe AndNew:anotherSavedPinSwipe];
        }
        else
        {
            PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
            [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"New Pin Mismatch"];
        }
    }
    
    [sender release];
}

-(void)userSecurityPinDidComplete
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showSuccessWithStatus:@"Success!" withDetailedStatus:@"Pin Swipe Changed"];
}

-(void)userSecurityPinDidFail:(NSString *)message
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failed!" withDetailedStatus:@"Incorrect Pin Swipe"];
}

-(void) securityQuestionAnsweredInCorrect:(NSString *)errorMessage
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showErrorWithStatus:@"Failure" withDetailedStatus:@"Security Question Answer Incorrect."];
}



@end

