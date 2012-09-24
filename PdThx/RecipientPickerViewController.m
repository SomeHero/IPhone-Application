//
//  RecipientPickerViewController.m
//  PdThx
//
//  Created by Christopher Magee on 9/16/12.
//
//

#import "RecipientPickerViewController.h"
#import "SendDonationViewController.h"

@interface RecipientPickerViewController ()

@end

@implementation RecipientPickerViewController

@synthesize userService;

// Table View Data Source Arrays
@synthesize tableSections;
@synthesize shownContacts;

// Default contact return delegate
@synthesize contactChosenDelegate;

// Two ?custom? return delegates
@synthesize didSetContactAndAmountDelegate, didSetContactDelegate;


// App Delegate
@synthesize appDelegate;

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
    
    appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    shownContacts = [[NSMutableDictionary alloc] init];
    tableSections = [[NSMutableArray alloc] init];
    // Create custom arrays for each character in the alphabet.
    [self reloadContactTableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSString* contactSelectImage = [appDelegate getSelectedContactListImage];
    
    if([contactSelectImage isEqualToString: @"nav-selector-cause-52x30.png"])
        contactSelectImage = @"nav-selector-allcontacts-52x30.png";
    
    UIImage *bgImage = [UIImage imageNamed:contactSelectImage];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [settingsBtn addTarget:self action:@selector(showContextSelect:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsButtons = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    
    self.navigationItem.rightBarButtonItem = settingsButtons;
    [settingsButtons release];
}

- (void)viewDidUnload
{
    [txtSearchBox release];
    txtSearchBox = nil;
    [tableView release];
    tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [txtSearchBox release];
    [tableView release];
    [super dealloc];
}

- (IBAction)searchBoxChanged:(id)sender
{
    NSLog(@"Search box changed: %@",txtSearchBox.text);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Display chosen table cell
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableSections count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Getting number of rows for section: %@", [tableSections objectAtIndex:section]);
    
    // Check for "special" sections in the table.
    if ( [[tableSections objectAtIndex:section] isEqualToString:@"Loading"] )
        return 1;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"Searching"] )
        return 1;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"NoMeCodesFound"] )
        return 1;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"NoFacebookContactsFound"] )
        return 1;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"OrganizationsNotLoaded"] )
        return 1;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"NonprofitsNotLoaded"] )
        return 1;
    else {
        NSLog(@"Returning %d rows for section %d", [[shownContacts objectForKey:[tableSections objectAtIndex:section]] count], section);
        return [[shownContacts objectForKey:[tableSections objectAtIndex:section]] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check for "special" sections in the table.
    if ( [[tableSections objectAtIndex:indexPath.section] isEqualToString:@"Loading"] )
        return 25.0;
    else if ( [[tableSections objectAtIndex:indexPath.section] isEqualToString:@"Searching"] )
        return 25.0;
    else if ( [[tableSections objectAtIndex:indexPath.section] isEqualToString:@"NoMeCodesFound"] )
        return 25.0;
    else if ( [[tableSections objectAtIndex:indexPath.section] isEqualToString:@"NoFacebookContactsFound"] )
        return 85.0;
    else if ( [[tableSections objectAtIndex:indexPath.section] isEqualToString:@"OrganizationsNotLoaded"] )
        return 100.0;
    else if ( [[tableSections objectAtIndex:indexPath.section] isEqualToString:@"NonprofitsNotLoaded"] )
        return 100.0;
    
    return 60.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( [[tableSections objectAtIndex:section] isEqualToString:@"Loading"] )
        return 0.0;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"Searching"] )
        return 0.0;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"NoMeCodesFound"] )
        return 0.0;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"NoFacebookContactsFound"] )
        return 0.0;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"OrganizationsNotLoaded"] )
        return 0.0;
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"NonprofitsNotLoaded"] )
        return 0.0;
    
    return 15.0;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( [[tableSections objectAtIndex:section] isEqualToString:@"Loading"] )
        return @"Not shown";
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"Searching"] )
        return @"Not shown";
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"NoMeCodesFound"] )
        return @"Not shown";
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"NoFacebookContactsFound"] )
        return @"Not shown";
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"OrganizationsNotLoaded"] )
        return @"Not shown";
    else if ( [[tableSections objectAtIndex:section] isEqualToString:@"NonprofitsNotLoaded"] )
        return @"Not shown";
    
    return [tableSections objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // Use footer to display "connect more social networks" area when there are no/low results
    return 0.0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*newCell = [[UITableViewCell alloc] init];
    newCell.textLabel.text = [NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row];
    return newCell;
}



-(void) showContextSelect:(id)sender forEvent:(UIEvent*)event
{
    [txtSearchBox resignFirstResponder];
    
    ContactTypeSelectViewController *tableViewController = [[ContactTypeSelectViewController alloc] init];
    [tableViewController setContactSelectWasSelected: self];
    
    tableViewController.view.frame = CGRectMake(0,0, 220, 216);
    
    popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    [popoverController setContactSelectWasSelected: self];
    popoverController.cornerRadius = 5;
    popoverController.titleText = @"Select Context";
    popoverController.popoverBaseColor = [UIColor whiteColor];
    popoverController.popoverGradient= YES;
    //popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];
}


-(void)contactWasSelected:(NSInteger)contactType
{
    
    [popoverController dismissPopoverAnimatd:YES];
    
    switch (contactType)
    {
        case 1:
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"AllContacts"];
            
            
            break;
        case 2:
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"PhoneContacts"];
            
            break;
        case 3:
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"FacebookContacts"];
            
            break;
        case 4:
        {
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"NonProfits"];
            
            DoGoodViewController* dvc = [[DoGoodViewController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            [dvc release];
            
            SendDonationViewController *gvc = [[SendDonationViewController alloc]init];
            [[self navigationController] pushViewController:gvc animated:NO];
            
            [gvc pressedChooseRecipientButton:self];
            [gvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectAtIndex:1];
            [allViewControllers removeObjectAtIndex:0];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            
            [allViewControllers release];
            
            break;
        }
        case 5:
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"Organizations"];
            
            break;
        default:
            break;
    }
    
    NSString* contactSelectImage = [appDelegate getSelectedContactListImage];
    
    UIImage *bgImage = [UIImage imageNamed:contactSelectImage];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [settingsBtn addTarget:self action:@selector(showContextSelect:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsButtons = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    
    [self.navigationItem setRightBarButtonItem:settingsButtons];
    [settingsButtons release];
    
    // Change selected contact list and call refresh.
    
    [popoverController release];
    popoverController = nil;
}

/*                  Refactored Functions             */
/*  ----------------------------------------------  */
-(void)reloadContactTableView
{
    if ( [self isFiltered] )
    {
        // Handle filtered results.
    }
    else
    {
        // Load default contact table view according to the delegate.
        if ( [appDelegate.selectedContactList isEqualToString:@"FacebookContacts"] )
        {
            NSMutableArray*contactArray = appDelegate.faceBookContacts;
            
            for ( NSMutableArray*alphaArray in contactArray )
            {
                if ( [alphaArray count] > 0 )
                {
                    NSString* sectionTitle = [NSString stringWithFormat:@"%c",toupper([[[alphaArray objectAtIndex:0] lastName] characterAtIndex:0])];
                    
                    [tableSections addObject:sectionTitle];
                    
                    NSLog(@"Setting %@ for section [%@]",[[alphaArray objectAtIndex:0] lastName], sectionTitle);
                    [shownContacts setValue:alphaArray forKey:sectionTitle];
                }
            }
            
            NSLog(@"Facebook Contact Select loaded.");
            NSLog(@"Sections in table: %@",tableSections);
        }
        else if ( [appDelegate.selectedContactList isEqualToString:@"PhoneContacts"] )
        {
            
        }
    }
    
    [tableView reloadData];
}

-(bool)isSearchingForMeCode
{
    if ( [self isFiltered] && [txtSearchBox.text characterAtIndex:0] == '$' )
        return TRUE;
    
    return FALSE;
}

-(bool)isFiltered
{
    if ( [txtSearchBox.text isEqualToString:@""] )
        return FALSE;
    
    return TRUE;
}

-(bool)hasFilteredResults
{
    // This function returns TRUE if there are contacts found that match the filter
    // in the search box. There is an offset of one section because of the loading/informative section
    // normally in the table view.
    if ( [self isFiltered] && [tableSections count] > 1 )
        return TRUE;
    
    return false;
}

@end
