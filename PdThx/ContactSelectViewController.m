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
@synthesize phoneNumberFormatter, fbIconsDownloading,contactSelectChosenDelegate;
@synthesize txtSearchBox, filteredResults, isFiltered, foundFiltered;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fBook = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fBook;
        
        allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).contactsArray;
        
        filteredResults = [[NSMutableArray alloc] init];
        for ( int i = 0 ; i < 27 ; i ++ )
            [filteredResults addObject:[[NSMutableArray alloc] init]];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    txtSearchBox.frame =  CGRectMake(txtSearchBox.frame.origin.x, txtSearchBox.frame.origin.y, txtSearchBox.frame.size.width, 40);
    
    self.fbIconsDownloading = [NSMutableDictionary dictionary];
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
        return 27;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSLog(@"Trying to load cell for section: %c and row: %d",(char)(indexPath.section+65),indexPath.row);
    ContactTableViewCell *myCell = (ContactTableViewCell*)[tvSubview dequeueReusableCellWithIdentifier:@"myCell"];
    
    if ( myCell == nil ){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
        myCell = [nib objectAtIndex:0];
    }
    
    //Wipe out old information in Cell
    [myCell.contactImage setBackgroundImage:NULL forState:UIControlStateNormal];
    [myCell.contactImage.layer setCornerRadius:12.0];
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
                return myCell;
            } else if ( entryType == 1 ) {
                // Valid phone number entered... show a new contact with that information
                // entered in the search box.
                myCell.contactName.text = [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                myCell.contactDetail.text = @"New Phone# Recipient";
                return myCell;
            } else if ( entryType == 2 ) {
                // Valid email address entered, show a new contact box with that information
                // entered as the contaction information
                myCell.contactName.text = txtSearchBox.text;
                myCell.contactDetail.text = @"New Email Recipient";
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
                return myCell;
            }
            else
            {
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            }
        } else {
            myCell.contactName.text = contact.name;
            myCell.contactDetail.text = contact.phoneNumber;
            [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
        }
    } else {
        Contact *contact = [[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                                                 
        if ( contact.facebookID.length > 0 ){
            myCell.contactName.text = contact.name;
            [myCell.contactImage.layer setCornerRadius:12.0];
            [myCell.contactImage.layer setMasksToBounds:YES];
        
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
                return myCell;
            }
            else
            {
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            }
        } else {
            myCell.contactName.text = contact.name;
            myCell.contactDetail.text = contact.phoneNumber;
            [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
        }
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
                    contact.name = @"New Phone Number";
                    contact.phoneNumber = [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    contact.recipientUri = [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                } else if ( retVal == 2 ){
                    // Email
                    contact.name = @"New Email Address";
                    contact.emailAddress = txtSearchBox.text;
                    contact.recipientUri = txtSearchBox.text;
                }
            }
            [contactSelectChosenDelegate didChooseContact:contact];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [contactSelectChosenDelegate didChooseContact:[[filteredResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        [contactSelectChosenDelegate didChooseContact:[[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(IBAction) btnGoClicked:(id)sender {
    Contact* contact = [[[Contact alloc] init] autorelease];
    
    contact.name = [[txtSearchBox text] copy];
    contact.recipientUri = [[txtSearchBox text] copy];
    
    [contactSelectChosenDelegate didChooseContact: contact];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( section != 26 )
        return [NSString stringWithFormat:@"%c",section+65];
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
            NSLog(@"Loading contact inside OnScreen for: %c-%d", (char)(indexPath.section+65), indexPath.row );
            Contact *contact = [[filteredResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            if (!contact.imgData && contact.facebookID.length > 0) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:contact forIndexPath:indexPath];
            }
        }
    }
    else if ([allResults count] > 0)
    {
        NSArray *visiblePaths = [tvSubview indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSLog(@"Loading contact inside OnScreen for: %c-%d", (char)(indexPath.section+65), indexPath.row );
            Contact *contact = [[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            if (!contact.imgData && contact.facebookID.length > 0) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:contact forIndexPath:indexPath];
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
                // Check first case normally
                hasSimilarity = [contact.name rangeOfString:txtSearchBox.text options:(NSCaseInsensitiveSearch)];
                if ( hasSimilarity.location == NSNotFound && contact.phoneNumber != NULL ){
                    hasSimilarity = [[[contact.phoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-+ "]] componentsJoinedByString:@""] rangeOfString:[[txtSearchBox.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-+ "]] componentsJoinedByString:@""] options:(NSCaseInsensitiveSearch|NSLiteralSearch)];
                }
                if ( hasSimilarity.location == NSNotFound && contact.emailAddress != NULL ){
                    hasSimilarity = [contact.emailAddress rangeOfString:txtSearchBox.text options:(NSCaseInsensitiveSearch)];
                }
                // Add $me code implementation ** TODO: **
            
                if ( hasSimilarity.location != NSNotFound ){
                    [[filteredResults objectAtIndex:((int)toupper([contact.name characterAtIndex:0]))-65] addObject:contact];
                    foundFiltered = YES;
                }
            }
        }
        
        [tvSubview reloadData];
    }
}
@end
