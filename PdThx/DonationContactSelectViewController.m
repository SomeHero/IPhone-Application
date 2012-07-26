//
//  ContactSelectViewController.m
//  PdThx
//
//  Created by James Rhodes on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DonationContactSelectViewController.h"
#import "ContactTableViewCell.h"
#import "Contact.h"
#import "PhoneNumberFormatting.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>
#import "Facebook.h"
#import "PdThxAppDelegate.h"
#import "IconDownloader.h"

@interface DonationContactSelectViewController ()

- (void)startIconDownload:(Contact*)contact forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation DonationContactSelectViewController

@synthesize searchBar, tvSubview, fBook;
@synthesize fbIconsDownloading, causeSelectDidComplete;
@synthesize txtSearchBox, filteredResults, isFiltered, foundFiltered;
@synthesize  allResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fBook = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fBook;
        
        allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).nonProfits;
        
        filteredResults = [[NSMutableArray alloc] init];
        for ( int i = 0 ; i < 28 ; i ++ )
            [filteredResults addObject:[[NSMutableArray alloc] init]];
    }
    return self;
}

-(void)refreshContactList:(NSNotification*)notification
{
    [tvSubview reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [txtSearchBox becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    //txtSearchBox.frame =  CGRectMake(txtSearchBox.frame.origin.x, txtSearchBox.frame.origin.y, txtSearchBox.frame.size.width, 40);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContactList:) name:@"refreshContactList" object:nil];
    
    self.fbIconsDownloading = [NSMutableDictionary dictionary];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /* ---------------------------------------------------- */
    /*      Custom Settings Button Implementation           */
    /* ---------------------------------------------------- */
    
    UIImage *bgImage = [UIImage imageNamed:@"nav-selector-cause-52x30.png"];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [settingsBtn addTarget:self action:@selector(showContextSelect:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsButtons = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    
    self.navigationItem.rightBarButtonItem = settingsButtons;
    [settingsButtons release];
}

-(void) showContextSelect:(id)sender forEvent:(UIEvent*)event
{
    [txtSearchBox resignFirstResponder];
    
    ContactTypeSelectViewController *tableViewController = [[ContactTypeSelectViewController alloc] init];
    
    tableViewController.view.frame = CGRectMake(0,0, 220, 216);
    [tableViewController setContactSelectWasSelected: self];
    
    popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    
    [popoverController setContactSelectWasSelected: self];
    popoverController.cornerRadius = 5;
    popoverController.titleText = @"Select Context";
    popoverController.popoverBaseColor = [UIColor clearColor];
    popoverController.popoverGradient= YES;
    //popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];
}

-(void) backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [searchBar release];
    searchBar = nil;
    [tvSubview release];
    tvSubview = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/*
 TABLE VIEW SETUP AND HANDLING
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ( isFiltered && !foundFiltered )
        return 1;
    else
        return 28;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if ( indexPath.section > 0 ) // screw it it's all one height.
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( isFiltered == YES )
    {
        if ( foundFiltered == NO ){
            return 0.0;
        } else if ( [[filteredResults objectAtIndex:section] count] > 0 ){
            return 22.0;
        }
    }
    else
    {
        if ( [[allResults objectAtIndex:section] count] == 0 )
            return 0.0;
        else 
            return 22.0;
    }
    
    return 0.0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [txtSearchBox resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if ( isFiltered == YES ){
        if ( [[filteredResults objectAtIndex:section] count] == 0 && section == 0 && !foundFiltered)
            return 1;
        else
            return [[filteredResults objectAtIndex:section] count];
    } else {
        return [[allResults objectAtIndex:section] count];
    }
}

-(int)isValidFormattedPayPoint {
    // Do handling for entry of text field where entry does not match
    // any contacts in the user's contact list.
    
    // The only cases we need to handle are: Phone Number and Email
    NSString * numOnly = [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSRange numOnly2 = [[[txtSearchBox.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-() "]] componentsJoinedByString:@""] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]  options:NSCaseInsensitiveSearch];
    
    if ( [txtSearchBox.text isEqualToString:numOnly] || numOnly2.location == NSNotFound ) {
        // Is only Numbers, I think?
        if ( [numOnly characterAtIndex:0] == '1' || [numOnly characterAtIndex:0] == '0' )
            numOnly = [numOnly substringFromIndex:1]; // Do not include country codes
        if ( [numOnly length] == 10 )
            return 1;
    } else {
        if ( [txtSearchBox.text rangeOfString:@"@"].location != NSNotFound && [txtSearchBox.text rangeOfString:@"."].location != NSNotFound ){
            // Contains both @ and a period. Now check if there's atleast:
            // SOMETHING before the @
            // SOMETHING after the @ before the .
            // SOMETHING after the .
            if ( [txtSearchBox.text rangeOfString:@"@"].location != 0 
                && [txtSearchBox.text rangeOfString:@"."].location != ([txtSearchBox.text rangeOfString:@"@"].location + 1) && [txtSearchBox.text length] != [txtSearchBox.text rangeOfString:@"."].location+1 )
                return 2;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *backgroundImage = [UIImage imageNamed: @"transaction_row_background"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    
    UIImage *altBackgroundImage = [UIImage imageNamed: @"transaction_rowalt_background"];
    UIImageView *altImageView = [[UIImageView alloc] initWithImage:altBackgroundImage];
    [altImageView setContentMode:UIViewContentModeScaleToFill];
    
    DoGoodUITableCellViewController *myCell = (DoGoodUITableCellViewController*)[tvSubview dequeueReusableCellWithIdentifier:@"myCell"];
    
    if ( myCell == nil ){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DoGoodUITableCellViewController" owner:self options:nil];
        myCell = [nib objectAtIndex:0];
        [myCell setDetailInfoButtonClicked: self];
    }

    //Wipe out old information in Cell
    [myCell.contactImage setBackgroundImage:NULL forState:UIControlStateNormal];
    [myCell.contactImage.layer setCornerRadius:4.0];
    [myCell.contactImage.layer setMasksToBounds:YES];
    myCell.userInteractionEnabled = YES;
    
    Contact *contact;
    if ( isFiltered == YES ) {
        if ( foundFiltered == NO ){ // Only Show it once (section0)
            int entryType = [self isValidFormattedPayPoint];
            [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
            if ( entryType == 0 ) {
                // Could not find contact by that name, so put the
                // "keep typing" screen
                myCell.contactName.text = [NSString stringWithFormat:@"'%@' not found", txtSearchBox.text];
                myCell.contactDetail.text = @"Continue typing or check entry";
                myCell.userInteractionEnabled = NO;
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
                return myCell;
            } else if ( entryType == 1 ) {
                // Valid phone number entered... show a new contact with that information
                // entered in the search box.
                myCell.contactName.text = [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                myCell.contactDetail.text = @"New Phone Recipient";
                return myCell;
            } else if ( entryType == 2 ) {
                // Valid email address entered, show a new contact box with that information
                // entered as the contaction information
                myCell.contactName.text = txtSearchBox.text;
                myCell.contactDetail.text = @"New Email Recipient";
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
                return myCell;
            } else if ( entryType == 3 ) {
                // Valid me code entered.. show new contact with that information
                // but $ME codes aren't done yet
            }
        } else {
            contact = [[filteredResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        
        if ( contact.facebookID.length > 0 ){
            myCell.contactName.text = contact.name;
            
            myCell.contactDetail.text = [NSString stringWithFormat:@"Facebook User#%@", contact.facebookID];
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!contact.imgData)
            {
                if (tvSubview.dragging == NO && tvSubview.decelerating == NO)
                {
                    [self startIconDownload:contact forIndexPath:indexPath];
                }
                
                // if a download is deferred or in progress, return a placeholder image
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
                return myCell;
            }
            else
            {
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            }
        } else {
            
            myCell.merchantId = contact.userId;
            myCell.contactName.text = contact.name;
            myCell.contactDetail.text = contact.phoneNumber;
            if ( contact.imgData )
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            else
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
        }
    } else {
        Contact *contact = [[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if ( contact.facebookID.length > 0 ){
            myCell.contactName.text = contact.name;
            
            myCell.contactDetail.text = [NSString stringWithFormat:@"Facebook User#%@", contact.facebookID];
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!contact.imgData)
            {
                if (tvSubview.dragging == NO && tvSubview.decelerating == NO)
                {
                    [self startIconDownload:contact forIndexPath:indexPath];
                }
                
                // if a download is deferred or in progress, return a placeholder image
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
                return myCell;
            }
            else
            {
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            }
        } else {
            myCell.merchantId = contact.userId;
            myCell.contactName.text = contact.name;
            myCell.contactDetail.text = contact.phoneNumber;
            
            if ( contact.imgData != nil )
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            else
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
        }
    }
    
    if (indexPath.row%2 == 0)  {
        myCell.backgroundView = imageView;
    } else {
        myCell.backgroundView = altImageView;
    }
    
    return myCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( isFiltered == YES ) {
        Contact* contact = [[Contact alloc] init];
        if ( foundFiltered == NO )
        {
            // Use Custom Contact Created Below ...
            int retVal = [self isValidFormattedPayPoint];
            if ( retVal > 0 ){ // Always > 0 (handled by enabled/disabled)
                if ( retVal == 1 ){
                    // Phone Number
                    contact.name = [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    contact.phoneNumber = @"New Phone Recipient";
                    contact.recipientUri = [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                } else if ( retVal == 2 ){
                    // Email
                    contact.name = txtSearchBox.text;
                    contact.emailAddress = @"New Email Address";
                    contact.recipientUri = txtSearchBox.text;
                }
            }
            [causeSelectDidComplete didChooseCause: contact];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [causeSelectDidComplete didChooseCause:[[filteredResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [causeSelectDidComplete didChooseCause:[[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction) btnGoClicked:(id)sender {
    Contact* contact = [[[Contact alloc] init] autorelease];
    
    contact.name = [[txtSearchBox text] copy];
    contact.recipientUri = [[txtSearchBox text] copy];
    
    [causeSelectDidComplete didChooseCause: contact];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( section != 27 )
        return [NSString stringWithFormat:@"%c",section+64];
    else {
        return [NSString stringWithString:@"#"];
    }
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#", nil];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // I guess this function returns the index of the section you want
    // to display. Should return section #. Same as index? Maybe it always isnt
    
    // NSLog(@"Weird Function: Title[%@] atIndex[%d]", title, index);
    return index;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.fbIconsDownloading allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}



#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(Contact *)contact forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [fbIconsDownloading objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.contact = contact;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [fbIconsDownloading setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}


// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ( isFiltered && [filteredResults count] > 0 )
    {
        NSArray *visiblePaths = [tvSubview indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            if ( indexPath.section > 0 )
            {
                Contact *contact = [[filteredResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                
                if (!contact.imgData && contact.facebookID.length > 0) // avoid the app icon download if the app already has an icon
                {
                    [self startIconDownload:contact forIndexPath:indexPath];
                }
            }
        }
    }
    else if ([allResults count] > 0)
    {
        NSArray *visiblePaths = [tvSubview indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            if ( indexPath.section > 0 ){
                Contact *contact = [[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                
                if (!contact.imgData && contact.facebookID.length > 0) // avoid the app icon download if the app already has an icon
                {
                    [self startIconDownload:contact forIndexPath:indexPath];
                }
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [fbIconsDownloading objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        ContactTableViewCell *cell = (ContactTableViewCell*)[tvSubview cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        [cell.contactImage setBackgroundImage:iconDownloader.contact.imgData forState:UIControlStateNormal];
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


- (void)dealloc {
    [searchBar release];
    [tvSubview release];
    [phoneNumberFormatter release];
    [fbIconsDownloading release];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (IBAction)textBoxChanged:(id)sender {
    foundFiltered = NO;
    // Search text bar changed, handle the change...
    // If the string is empty (deleted input or just hovered over), reset to full contacts
    if ( [txtSearchBox.text isEqualToString:@""] || [[[txtSearchBox.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-() "]] componentsJoinedByString:@""] isEqualToString:@""]){
        isFiltered = NO;
        [tvSubview reloadData];
    } else {
        isFiltered = YES;
        for ( NSMutableArray*arr in filteredResults ) // Empty out array
            [arr removeAllObjects];
        
        NSRange hasSimilarity;
        for ( NSMutableArray*arr3 in allResults ){
            for ( Contact*contact in arr3 ){
                hasSimilarity = [contact.name rangeOfString:txtSearchBox.text options:(NSCaseInsensitiveSearch)];
                
                if ( hasSimilarity.location == NSNotFound && contact.phoneNumber != NULL && [contact.phoneNumber length] > 0 ){
                    hasSimilarity = [[[contact.phoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-+ "]] componentsJoinedByString:@""] rangeOfString:[[txtSearchBox.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-+ "]] componentsJoinedByString:@""] options:(NSCaseInsensitiveSearch|NSLiteralSearch)];
                }
                if ( hasSimilarity.location == NSNotFound && contact.emailAddress != NULL && [contact.emailAddress length] > 0 ){
                    hasSimilarity = [contact.emailAddress rangeOfString:txtSearchBox.text options:(NSCaseInsensitiveSearch)];
                }
                // Add $me code implementation ** TODO: **
                
                
                if ( hasSimilarity.location != NSNotFound ){
                    @try {
                        [[filteredResults objectAtIndex:((int)toupper([contact.name characterAtIndex:0]))-64] addObject:contact];
                        foundFiltered = YES;
                    }
                    @catch (NSException* e) {
                        NSLog(@"Exception: %@", e);
                    }
                    
                }
            }
        }
    }
    [tvSubview reloadData];
}

-(void)infoButtonClicked: (NSString*) merchantId;
{
    OrganizationDetailViewController* controller = [[OrganizationDetailViewController alloc] init];
    [controller setMerchantId:merchantId];
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    
    [self.navigationController presentModalViewController:navBar animated:YES];
    
    [controller release];
    [navBar release];
}

-(void)contactWasSelected:(NSInteger)contactType {
    
    [popoverController dismissPopoverAnimatd:YES];
    switch (contactType) {
        case 1:
        case 2:
        case 3:
        case 5:
        {
            
            SendMoneyController *gvc = [[SendMoneyController alloc]init];
            [gvc viewDidLoad];
            [[self navigationController] pushViewController:gvc animated:NO];
            
            [gvc pressedChooseRecipientButton:self];
            [gvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectAtIndex:2];
            [allViewControllers removeObjectAtIndex:1];
            [allViewControllers removeObjectAtIndex:0];
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            
            [allViewControllers release];
            
            break;
        }
        case 4:
            allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).nonProfits;
            break;
        default:
            allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).nonProfits;
            break;
    }
    
    filteredResults = [[NSMutableArray alloc] init];
    for ( int i = 0 ; i < 28 ; i ++ )
        [filteredResults addObject:[[NSMutableArray alloc] init]];
    
    [tvSubview reloadData];
    
    [popoverController release];
    popoverController = nil;
}
- (void)tabBarClicked:(NSUInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        //Switch to the groups tab
        HomeViewController *gvc = [[HomeViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 1 )
    {
        //Switch to the groups tab
        PayStreamViewController *gvc = [[PayStreamViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 2 )
    {
        //Switch to the groups tab
        SendMoneyController *gvc = [[SendMoneyController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        
        [gvc pressedChooseRecipientButton:self];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 3 )
    {
        // Already the current view controller
        /*
         //Switch to the groups tab
         HomeViewController *gvc = [[HomeViewController alloc]init];
         [[self navigationController] pushViewController:gvc animated:NO];
         [gvc release];
         
         //Remove the view controller this is coming from, from the navigation controller stack
         NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
         [allViewControllers removeObjectIdenticalTo:self];
         [[self navigationController] setViewControllers:allViewControllers animated:NO];
         [allViewControllers release];
         */
    }
    if( buttonIndex == 4 )
    {
        //Switch to the groups tab
        DoGoodViewController *gvc = [[DoGoodViewController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
}

@end