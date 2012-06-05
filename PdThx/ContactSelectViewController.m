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
@synthesize txtSearchBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fBook = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fBook;
        
        allResults = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).contactsArray;
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
    return 27;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( [[allResults objectAtIndex:section] count] == 0 )
        return 0.0;
    else 
        return 22.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return allResults.count;
    NSLog(@"Contents of Section[%d]:",section);
    for (Contact*person in [allResults objectAtIndex:section])
        NSLog(@"-> %@" , person.name);
    return [[allResults objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *myCell = (ContactTableViewCell*)[tvSubview dequeueReusableCellWithIdentifier:@"myCell"];
    
    if ( myCell == nil ){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
        myCell = [nib objectAtIndex:0];
    }
    //Wipe out old information in Cell
    [myCell.contactImage setBackgroundImage:NULL forState:UIControlStateNormal];
    
    NSLog(@"Looking for object at: contactsArray[%d][%d]",indexPath.section, indexPath.row);
    NSLog(@"Contact Selected: %@" , [[[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] name] );
                                     
    Contact *contact = [[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSLog(@"Contact Address: %@" , contact);
    
                                                 
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
    
    return myCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [contactSelectChosenDelegate didChooseContact:[[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    if ([allResults count] > 0)
    {
        NSArray *visiblePaths = [tvSubview indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
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
@end
