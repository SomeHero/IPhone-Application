//
//  ContactSelectViewController.m
//  PdThx
//
//  Created by James Rhodes on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactSelectViewController.h"
#import "ContactTableViewCell.h"
#import "Contact.h"
#import "PhoneNumberFormatting.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>
#import "Facebook.h"
#import "PdThxAppDelegate.h"
#import "IconDownloader.h"

@interface ContactSelectViewController ()

- (void)startIconDownload:(Contact*)contact forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ContactSelectViewController

@synthesize searchBar, tvSubview, fBook, allResults;
@synthesize fbIconsDownloading,contactSelectChosenDelegate;
@synthesize txtSearchBox, filteredResults, isFiltered, foundFiltered;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fBook = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fBook;
        
        allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).contactsArray;
        
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
    txtSearchBox.frame =  CGRectMake(txtSearchBox.frame.origin.x, txtSearchBox.frame.origin.y, txtSearchBox.frame.size.width, 40);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContactList:) name:@"refreshContactList" object:nil];
    
    self.fbIconsDownloading = [NSMutableDictionary dictionary];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSString* contactSelectImage = [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelectedContactListImage];
    
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
    //if ( indexPath.section > 0 )
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
    if ( [txtSearchBox isFirstResponder] )
        NSLog(@"Table view scrolled, getting rid of keyboard.");
    
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
    
    ContactTableViewCell *myCell = (ContactTableViewCell*)[tvSubview dequeueReusableCellWithIdentifier:@"myCell"];
    
    if ( myCell == nil ){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
        myCell = [nib objectAtIndex:0];
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
            
            myCell.contactDetail.text = @"Facebook Friend";
            
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
            myCell.contactName.text = contact.name;
            
            if ([contact.paypoints count] == 1)
            {
                myCell.contactDetail.text = [contact.paypoints objectAtIndex:0];
            }
            else {
                myCell.contactDetail.text = [NSString stringWithFormat:@"%d paypoints", [contact.paypoints count]];
            }
            if ( contact.imgData )
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            else
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
        }
    } else {
        Contact *contact = [[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if ( contact.facebookID.length > 0 ){
            myCell.contactName.text = contact.name;
            
            myCell.contactDetail.text = [NSString stringWithFormat:@"Facebook Friend", contact.facebookID];
            
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
            myCell.contactName.text = contact.name;
            
            if ([contact.paypoints count] == 1)
            {
                myCell.contactDetail.text = [contact.paypoints objectAtIndex:0];
            }
            else {
                myCell.contactDetail.text = [NSString stringWithFormat:@"%d paypoints", [contact.paypoints count]];
            }
            
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
                    [contact.paypoints addObject: [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
                    contact.name = @"New Phone Recipient";
                } else if ( retVal == 2 ){
                    // Email
                    [contact.paypoints addObject: txtSearchBox.text];
                    contact.name = @"New Email Address";
                }
            }
            [contactSelectChosenDelegate didChooseContact:contact];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [contactSelectChosenDelegate didChooseContact:[[filteredResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [contactSelectChosenDelegate didChooseContact:[[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction) btnGoClicked:(id)sender {
    Contact* contact = [[[Contact alloc] init] autorelease];
    
    contact.name = [[txtSearchBox text] copy];
    [contact.paypoints addObject:[[txtSearchBox text] copy]];
    
    [contactSelectChosenDelegate didChooseContact: contact];
    [self.navigationController popViewControllerAnimated:YES];
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
    popoverController.popoverBaseColor = [UIColor clearColor];
    popoverController.popoverGradient= YES;
    //popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];
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
                for (NSString* paypoint in contact.paypoints)
                {
                // Check first case normally
                hasSimilarity = [contact.name rangeOfString:txtSearchBox.text options:(NSCaseInsensitiveSearch)];
                if ( hasSimilarity.location == NSNotFound && paypoint != NULL ){
                    hasSimilarity = [[[paypoint componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-+ "]] componentsJoinedByString:@""] rangeOfString:[[txtSearchBox.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-+ "]] componentsJoinedByString:@""] options:(NSCaseInsensitiveSearch|NSLiteralSearch)];
                }
                /*if ( hasSimilarity.location == NSNotFound && contact.emailAddress != NULL ){
                 hasSimilarity = [contact.emailAddress rangeOfString:txtSearchBox.text options:(NSCaseInsensitiveSearch)];
                 }*/
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
    }
    [tvSubview reloadData];
}
-(void)contactWasSelected:(NSInteger)contactType {
    
    [popoverController dismissPopoverAnimatd:YES];
    
    switch (contactType) {
        case 1:
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"AllContacts"];
            
            allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).contactsArray;
            break;
        case 2:
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"PhoneContacts"];
            
            allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).phoneContacts;
            break;
        case 3:
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"FacebookContacts"];
            
            allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).faceBookContacts;
            
            for(int i = 0; i < [allResults count]; i++)
            {
                
                
            }
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
            allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).organizations;
            break;
        default:
            allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).contactsArray;
            break;
    }
    
    NSString* contactSelectImage = [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) getSelectedContactListImage];
    
    UIImage *bgImage = [UIImage imageNamed:contactSelectImage];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    [settingsBtn addTarget:self action:@selector(showContextSelect:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsButtons = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    
    self.navigationItem.rightBarButtonItem = settingsButtons;
    [settingsButtons release];
    
    filteredResults = [[NSMutableArray alloc] init];
    for ( int i = 0 ; i < 28 ; i ++ )
        [filteredResults addObject:[[NSMutableArray alloc] init]];
    
    [tvSubview reloadData];
    
    [popoverController release];
    popoverController = nil;
}
@end