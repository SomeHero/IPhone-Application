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

#import "PdThxAppDelegate.h"
#import "IconDownloader.h"
#import "SocialNetworksViewController.h"
#import "UIPaystreamLoadingCell.h"
#import "ConnectFacebookCell.h"

#import "DAKeyboardControl.h"
#import <CoreText/CoreText.h>

@interface ContactSelectViewController ()

- (void)startIconDownload:(Contact*)contact forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ContactSelectViewController

@synthesize searchBar, tvSubview, allResults;
@synthesize fbIconsDownloading,contactSelectChosenDelegate;
@synthesize txtSearchBox, filteredResults, isFiltered, foundFiltered;
@synthesize didSetContactAndAmount;
@synthesize didSetContact;
@synthesize userService;
@synthesize appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if ( [[appDelegate selectedContactList] isEqualToString:@"FacebookContacts"] )
            allResults = appDelegate.faceBookContacts;
        else if ( [[appDelegate selectedContactList] isEqualToString:@"NonProfits"] )
            allResults = appDelegate.nonProfits;
        else
            allResults = appDelegate.contactsArray;
        
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
    self.view.keyboardTriggerOffset = 0.0;
    
    [tvSubview setBounces:NO];
    
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
    }];
    
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
    // Return the number of sections
    
    
    if ( isFiltered && !foundFiltered )
        return 1;
    else if ( [appDelegate.selectedContactList isEqualToString:@"FacebookContacts"] && appDelegate.numberOfFacebookFriends == 0 )
        return 1;
    else
        return 28;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if ( indexPath.section > 0 )
    if ( indexPath.section == 0 && [self isSearchingForMeCodes] )
        return 32.0;
    else if ( indexPath.section == 0 && [self shouldShowFacebookLinkCell] )
        return 150.0;
    else
        return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( isFiltered == YES )
    {
        if ( foundFiltered == NO ){
            return 0.0;
        } else if ( [[filteredResults objectAtIndex:section] count] > 0 )
        {
            if ( [self isSearchingForMeCodes] )
                return 0.0;
            else
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ( isFiltered == YES )
    {
        if ( [[filteredResults objectAtIndex:section] count] == 0 && section == 0 && !foundFiltered)
            return 1; // Loading Cell
        else
            return [[filteredResults objectAtIndex:section] count];
    } else if ( [appDelegate.selectedContactList isEqualToString:@"FacebookContacts"] && appDelegate.numberOfFacebookFriends == 0 ) {
        return 1; // Facebook Connect Cell
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
/*
 if ( !limitTextLayer )
 {
 limitTextLayer = [[CATextLayer alloc] init];
 //_textLayer.font = [UIFont boldSystemFontOfSize:13].fontName; // not needed since `string` property will be an NSAttributedString
 limitTextLayer.backgroundColor = [UIColor clearColor].CGColor;
 limitTextLayer.wrapped = NO;
 CALayer *layer = lblScore.layer; //self is a view controller contained by a navigation controller
 limitTextLayer.frame = CGRectMake(0, 0, layer.frame.size.width, layer.frame.size.height);
 limitTextLayer.alignmentMode = kCAAlignmentCenter;
 limitTextLayer.contentsScale = [[UIScreen mainScreen] scale];
 [layer addSublayer:limitTextLayer];
 }
 
 NSString* labelString = [NSString stringWithFormat:@"$%d/day",[user.instantLimit intValue]];
 
 CTFontRef unboldedFontRef = CTFontCreateWithName((CFStringRef)@"Helvetica", 19.0, NULL);
 CTFontRef boldedFontRef = CTFontCreateWithName((CFStringRef)@"Helvetica-Bold", 19.0, NULL);
 
 
 NSDictionary *unboldedAttributes = [NSDictionary dictionaryWithObject:
 (id)unboldedFontRef forKey:(id)kCTFontAttributeName];
 
 NSDictionary *boldedAttributes = [NSDictionary dictionaryWithObject:
 (id)boldedFontRef forKey:(id)kCTFontAttributeName];
 
 NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:labelString attributes:amountAttributes];
 
 [attrStr addAttributes:dayAttributes range:NSMakeRange([labelString rangeOfString:@" "].location, ([labelString length]-1-[labelString rangeOfString:@" "].location))];
 
 CFRelease(amountFontRef);
 CFRelease(dayFontRef);
 
 limitTextLayer.string = attrStr;
 [attrStr release];
 */

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtSearchBox resignFirstResponder];
    
    return false;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *backgroundImage = [UIImage imageNamed: @"transaction_row_background"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    
    UIImage *altBackgroundImage = [UIImage imageNamed: @"transaction_rowalt_background"];
    UIImageView *altImageView = [[UIImageView alloc] initWithImage:altBackgroundImage];
    [altImageView setContentMode:UIViewContentModeScaleToFill];
    
    // Loading Cell
    if ( indexPath.section == 0 && [self isSearchingForMeCodes] ) // Should Display Fetching Matching Me Codes
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIPaystreamLoadingTableViewCell" owner:self options:nil];
        UIPaystreamLoadingCell*cell = [nib objectAtIndex:0];
        return cell;
    }
    
    if ( indexPath.section == 0 && [self shouldShowFacebookLinkCell] )
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"ConnectFacebookCellView" owner:self options:nil];
        ConnectFacebookCell* connectFb = [nib objectAtIndex:0];
        return connectFb;
    }
    
    ContactTableViewCell *myCell = (ContactTableViewCell*)[tvSubview dequeueReusableCellWithIdentifier:@"myCell"];
    
    if ( myCell == nil ){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
        myCell = [nib objectAtIndex:0];
        [myCell setDetailInfoButtonClicked: self];
    }
    
    if ( ! myCell.contactNameLayer )
    {
        myCell.contactNameLayer = [[CATextLayer alloc] init];
        //_textLayer.font = [UIFont boldSystemFontOfSize:13].fontName; // not needed since `string` property will be an NSAttributedString
        myCell.contactNameLayer.backgroundColor = [UIColor clearColor].CGColor;
        myCell.contactNameLayer.wrapped = NO;
        CALayer *layer = myCell.contactNameField.layer; //self is a view controller contained by a navigation controller
        myCell.contactNameLayer.frame = CGRectMake(0, 0, layer.frame.size.width, layer.frame.size.height);
        myCell.contactNameLayer.alignmentMode = kCAAlignmentLeft;
        myCell.contactNameLayer.contentsScale = [[UIScreen mainScreen] scale];
        
        [layer addSublayer:myCell.contactNameLayer];
    }
    else if ( myCell.contactNameLayer && ![myCell.contactNameLayer superlayer])
    {
        [myCell.contactNameField.layer addSublayer:myCell.contactNameLayer];
    }
    
    //Wipe out old information in Cell
    [myCell.contactImage setBackgroundImage:NULL forState:UIControlStateNormal];
    [myCell.contactImage.layer setCornerRadius:4.0];
    [myCell.contactImage.layer setMasksToBounds:YES];
    [myCell.contactImage.layer setBorderWidth:0.2];
    [myCell.contactImage.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    myCell.userInteractionEnabled = YES;
    
    myCell.contactNameField.text = @"";
    
    NSString* contactLabel;
    NSRange boldRange;
    
    contactLabel = @"";
    
    CTFontRef boldedFont = CTFontCreateWithName((CFStringRef)@"Helvetica-Bold", 19.0, NULL);
    CTFontRef unboldedFont = CTFontCreateWithName((CFStringRef)@"Helvetica", 19.0, NULL);
    
    NSDictionary *boldedAttributes = [NSDictionary dictionaryWithObject:
                                      (id)boldedFont forKey:(id)kCTFontAttributeName];
    
    NSDictionary *unboldedAttributes = [NSDictionary dictionaryWithObject:
                                        (id)unboldedFont forKey:(id)kCTFontAttributeName];
    
    Contact *contact;
    if ( isFiltered == YES )
    {
        if ( foundFiltered == NO )
        {
            // Only Show it once (section0)
            int entryType = [self isValidFormattedPayPoint];
            [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
            if ( entryType == 0 ) {
                // Could not find contact by that name, so put the
                // "keep typing" screen
                contactLabel = @"No matches found";
                boldRange = NSMakeRange(0, [contactLabel length]);
                
                //[NSString stringWithFormat:@"'%@' not found", txtSearchBox.text];
                myCell.contactDetail.text = @"Continue typing or check entry";
                myCell.userInteractionEnabled = NO;
                
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
                /* Create the attributed string (text + attributes) */
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contactLabel attributes:unboldedAttributes];
                
                [attrStr addAttributes:boldedAttributes range:boldRange];
                
                CFRelease(boldedFont);
                CFRelease(unboldedFont);
                
                /* Set the attributes string in the text layer :) */
                myCell.contactNameLayer.string = attrStr;
                [attrStr release];
                
                return myCell;
            } else if ( entryType == 1 ) {
                // Valid phone number entered... show a new contact with that information
                // entered in the search box.
                contactLabel = [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                boldRange = NSMakeRange(0, [contactLabel length]);
                
                myCell.contactDetail.text = @"New Phone Recipient";
                
                /* Create the attributed string (text + attributes) */
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contactLabel attributes:unboldedAttributes];
                
                [attrStr addAttributes:boldedAttributes range:boldRange];
                
                CFRelease(boldedFont);
                CFRelease(unboldedFont);
                
                /* Set the attributes string in the text layer :) */
                myCell.contactNameLayer.string = attrStr;
                [attrStr release];
                
                return myCell;
            } else if ( entryType == 2 ) {
                // Valid email address entered, show a new contact box with that information
                // entered as the contaction information
                
                contactLabel = txtSearchBox.text;
                boldRange = NSMakeRange(0, [contactLabel length]);
                
                
                myCell.contactDetail.text = @"New Email Recipient";
                
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
                /* Create the attributed string (text + attributes) */
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contactLabel attributes:unboldedAttributes];
                
                [attrStr addAttributes:boldedAttributes range:boldRange];
                
                CFRelease(boldedFont);
                CFRelease(unboldedFont);
                
                /* Set the attributes string in the text layer :) */
                myCell.contactNameLayer.string = attrStr;
                [attrStr release];
                
                return myCell;
            } else if ( entryType == 3 ) {
                // Valid me code entered.. show new contact with that information
                // but $ME codes aren't done yet
            }
        } else {
            contact = [[filteredResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        
        if ( contact.recipientId > 0 )
        {
            // This is an organization...
            if ( [myCell.contactNameLayer superlayer] )
                [myCell.contactNameLayer removeFromSuperlayer];
            
            myCell.contactNameField.text = contact.name;
            myCell.contactDetail.text = @"";
            
            [myCell.btnInfo setContact:contact];
            if(!contact.showDetailIcon)
                [myCell.btnInfo setHidden:YES];
            else {
                [myCell.btnInfo setHidden:NO];
            }
            
            if (!contact.imgData)
            {
                if (tvSubview.dragging == NO && tvSubview.decelerating == NO)
                {
                    [self startIconDownload:contact forIndexPath:indexPath];
                }
                
                // if a download is deferred or in progress, return a placeholder image
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
                
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
            }
            else
            {
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            }
            
            return myCell;
        }
        
        if ( contact.facebookID.length > 0 ){
            if ( contact.firstName != (id)[NSNull null] && contact.lastName != (id)[NSNull null] ){
                if ( contact.firstName.length > 0 && contact.lastName.length > 0 )
                {
                    contactLabel = [NSString stringWithFormat:@"%@ %@",contact.firstName, contact.lastName];
                    boldRange = [contactLabel rangeOfString:contact.lastName];
                    
                } else if ( contact.lastName.length == 0 && contact.firstName.length > 0 ) {
                    contactLabel = [NSString stringWithFormat:@"%@",contact.firstName];
                    boldRange = NSMakeRange(0, [contactLabel length]);
                }
            }
            
            myCell.contactDetail.text = @"Facebook Friend";
            [myCell.btnInfo setContact:contact];
            if(!contact.showDetailIcon)
                [myCell.btnInfo setHidden:YES];
            else {
                [myCell.btnInfo setHidden:NO];
            }
            
            // Only load cached images; defer new downloads until scrolling ends
            if (!contact.imgData)
            {
                if (tvSubview.dragging == NO && tvSubview.decelerating == NO)
                {
                    [self startIconDownload:contact forIndexPath:indexPath];
                }
                
                // if a download is deferred or in progress, return a placeholder image
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
                
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
                /* Create the attributed string (text + attributes) */
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contactLabel attributes:unboldedAttributes];
                
                [attrStr addAttributes:boldedAttributes range:boldRange];
                
                CFRelease(boldedFont);
                CFRelease(unboldedFont);
                
                /* Set the attributes string in the text layer :) */
                myCell.contactNameLayer.string = attrStr;
                [attrStr release];
                
                return myCell;
            }
            else
            {
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            }
        } else {
            if ( contact.firstName != (id)[NSNull null] && contact.lastName != (id)[NSNull null] ){
                if ( contact.firstName.length > 0 && contact.lastName.length > 0 )
                {
                    contactLabel = [NSString stringWithFormat:@"%@ %@",contact.firstName, contact.lastName];
                    boldRange = [contactLabel rangeOfString:contact.lastName];
                } else if ( contact.lastName.length == 0 && contact.firstName.length > 0 ) {
                    contactLabel = [NSString stringWithFormat:@"%@",contact.firstName];
                    boldRange = NSMakeRange(0, [contactLabel length]);
                }
            }
            
            
            
            if ([contact.paypoints count] == 1)
            {
                myCell.contactDetail.text = [contact.paypoints objectAtIndex:0];
                
                if ( [[contact.paypoints objectAtIndex:0] isEqualToString:contact.name] && [contact.name characterAtIndex:0] == '$')
                {
                    contactLabel = [NSString stringWithFormat:@"%@",contact.name];
                    boldRange = [contactLabel rangeOfString:contact.name];
                    myCell.contactDetail.text = @"";
                }
            }
            else
            {
                myCell.contactDetail.text = [NSString stringWithFormat:@"%d paypoints", [contact.paypoints count]];
            }
            
            [myCell.btnInfo setContact:contact];
            if(!contact.showDetailIcon)
                [myCell.btnInfo setHidden:YES];
            else {
                [myCell.btnInfo setHidden:NO];
            }
            
            if ( contact.imgData )
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            else
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
        }
    } else {
        Contact *contact = [[allResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if ( contact.recipientId > 0 )
        {
            // This is an organization...
            if ( [myCell.contactNameLayer superlayer] )
                [myCell.contactNameLayer removeFromSuperlayer];
            
            myCell.contactNameField.text = contact.name;
            myCell.contactDetail.text = @"";
            myCell.merchantId = contact.userId;
            [myCell.btnInfo setContact:contact];
            
            if(!contact.showDetailIcon)
                [myCell.btnInfo setHidden:YES];
            else {
                [myCell.btnInfo setHidden:NO];
            }
            if (!contact.imgData)
            {
                if (tvSubview.dragging == NO && tvSubview.decelerating == NO)
                {
                    [self startIconDownload:contact forIndexPath:indexPath];
                }
                
                // if a download is deferred or in progress, return a placeholder image
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
                
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
            }
            else
            {
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            }
            
            return myCell;
        }
        
        if ( contact.facebookID.length > 0 )
        {
            if ( contact.firstName != (id)[NSNull null] && contact.lastName != (id)[NSNull null] ){
                if ( contact.firstName.length > 0 && contact.lastName.length > 0 )
                {
                    contactLabel = [NSString stringWithFormat:@"%@ %@",contact.firstName, contact.lastName];
                    boldRange = [contactLabel rangeOfString:contact.lastName];
                    
                } else if ( contact.lastName.length == 0 && contact.firstName.length > 0 ) {
                    contactLabel = [NSString stringWithFormat:@"%@",contact.firstName];
                    boldRange = NSMakeRange(0, [contactLabel length]);
                }
            }
            
            myCell.contactDetail.text = [NSString stringWithFormat:@"Facebook Friend"];
            
            [myCell.btnInfo setContact:contact];
            if(!contact.showDetailIcon)
                [myCell.btnInfo setHidden:YES];
            else {
                [myCell.btnInfo setHidden:NO];
            }
            // Only load cached images; defer new downloads until scrolling ends
            if (!contact.imgData)
            {
                if (tvSubview.dragging == NO && tvSubview.decelerating == NO)
                {
                    [self startIconDownload:contact forIndexPath:indexPath];
                }
                
                // if a download is deferred or in progress, return a placeholder image
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
                
                
                if (indexPath.row%2 == 0)  {
                    myCell.backgroundView = imageView;
                } else {
                    myCell.backgroundView = altImageView;
                }
                
                /* Create the attributed string (text + attributes) */
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contactLabel attributes:unboldedAttributes];
                
                [attrStr addAttributes:boldedAttributes range:boldRange];
                
                CFRelease(boldedFont);
                CFRelease(unboldedFont);
                
                /* Set the attributes string in the text layer :) */
                myCell.contactNameLayer.string = attrStr;
                [attrStr release];
                
                return myCell;
            }
            else
            {
                [myCell.contactImage setBackgroundImage:contact.imgData forState:UIControlStateNormal];
            }
        } else {
            if ( contact.firstName == (id)[NSNull null] && contact.lastName == (id)[NSNull null] &&
                contact.name != (id)[NSNull null] && contact.name.length > 0 )
            {
                //Organization Probably? We have no "type" of contact... bad idea.
                contactLabel = contact.name;
                boldRange = NSMakeRange(0, [contactLabel length]);
            }
            if ( contact.firstName != (id)[NSNull null] && contact.lastName != (id)[NSNull null] )
            {
                if ( contact.firstName.length > 0 && contact.lastName.length > 0 )
                {
                    contactLabel = [NSString stringWithFormat:@"%@ %@",contact.firstName, contact.lastName];
                    boldRange = [contactLabel rangeOfString:contact.lastName];
                } else if ( contact.lastName.length == 0 && contact.firstName.length > 0 ) {
                    contactLabel = [NSString stringWithFormat:@"%@",contact.firstName];
                    boldRange = NSMakeRange(0, [contactLabel length]);
                }
            }
            [myCell.btnInfo setContact:contact];
            if(!contact.showDetailIcon)
                [myCell.btnInfo setHidden:YES];
            else {
                [myCell.btnInfo setHidden:NO];
            }
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
                [myCell.contactImage setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
        }
    }
    
    if (indexPath.row%2 == 0)  {
        myCell.backgroundView = imageView;
    } else {
        myCell.backgroundView = altImageView;
    }
    
    /* Create the attributed string (text + attributes) */
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contactLabel attributes:unboldedAttributes];
    
    [attrStr addAttributes:boldedAttributes range:boldRange];
    
    CFRelease(boldedFont);
    CFRelease(unboldedFont);
    
    /* Set the attributes string in the text layer :) */
    myCell.contactNameLayer.string = attrStr;
    [attrStr release];
    
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
                    contact.name = [[txtSearchBox.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                } else if ( retVal == 2 ){
                    // Email
                    [contact.paypoints addObject: txtSearchBox.text];
                    contact.name = txtSearchBox.text;
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
    popoverController.popoverBaseColor = [UIColor whiteColor];
    popoverController.popoverGradient= YES;
    //popoverController.arrowPosition = TSPopoverArrowPositionHorizontal;
    [popoverController showPopoverWithTouch:event];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ( section != 27 )
        return [NSString stringWithFormat:@"%c",section+64];
    else {
        return @"#";
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

-(void)findMeCodesMatchingString:(NSString*)searchTerm
{
    NSLog(@"Searching for %@",searchTerm);
    
    if ( userService == nil )
        userService = [[UserService alloc] init];
    
    [userService setFindMeCodeDelegate:self];
    
    [userService findMeCodesMatchingSearchTerm:searchTerm];
}

-(void)foundMeCodes:(NSMutableArray *)meCodes matchingSearchTerm:(NSString *)searchTerm
{
    // Created filteredArray for ContactList
    NSMutableArray*sortedArray = [[NSMutableArray alloc] init];
    
    // Make sure it's the correct
    if ( [searchTerm isEqualToString:txtSearchBox.text] )
    {
        // Create a contact for each one of the meCodes entries.
        Contact *newContact;
        
        for ( NSDictionary*meCodeDict in meCodes )
        {
            if ( [[meCodeDict objectForKey:@"meCode"] characterAtIndex:0] != '$' )
                continue;
            
            //NSLog("Starting meCodeDictionary: %@", meCodeDict);
            if ( meCodeDict == nil )
                NSLog(@"Hi");
            
            newContact = [[Contact alloc] init];
            newContact.userId = [meCodeDict objectForKey:@"userId"];
            newContact.name = [meCodeDict objectForKey:@"meCode"];
            
            
            if( [meCodeDict objectForKey:@"userImageUri"] != (id)[NSNull null] )
                newContact.imgData = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[meCodeDict objectForKey:@"userImageUri"]]]];
            
            [newContact.paypoints addObject:[meCodeDict objectForKey:@"meCode"]];
            
            [sortedArray addObject:newContact];
            [newContact release];
        }
    }
    
    [self setFilteredResults:[appDelegate sortContacts:sortedArray]];
    isFiltered = YES;
    foundFiltered = YES;
    [tvSubview reloadData];
}

- (IBAction)textBoxChanged:(id)sender
{
    foundFiltered = NO;
    // Search text bar changed, handle the change...
    // If the string is empty (deleted input or just hovered over), reset to full contacts
    if ( [txtSearchBox.text isEqualToString:@""] || [[[txtSearchBox.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-() "]] componentsJoinedByString:@""] isEqualToString:@""]){
        isFiltered = NO;
        [tvSubview reloadData];
    } else {
        isFiltered = YES;
        
        if ( txtSearchBox.text &&  txtSearchBox.text.length > 0 && [txtSearchBox.text characterAtIndex:0] == '$' )
        {
            if ( txtSearchBox.text.length < 4 )
            {
                // Do not search for ME Code Results
                foundFiltered = NO;
            }
            else
            {
                [[filteredResults objectAtIndex:0] removeAllObjects];
                [[filteredResults objectAtIndex:0] addObject:[[[Contact alloc] init] autorelease]];
                [tvSubview reloadData];
                
                [self findMeCodesMatchingString:txtSearchBox.text];
                //[self performSelector:@selector(findMeCodesMatchingString:) withObject:txtSearchBox.text afterDelay:1.0];
            }
        }
        else
        {
            for ( NSMutableArray*conArr in filteredResults )
                [conArr removeAllObjects];
            
            NSRange hasSimilarity;
            for ( NSMutableArray*arr3 in allResults )
            {
                for ( Contact*contact in arr3 )
                {
                    hasSimilarity.location = NSNotFound;
                    for (NSString* paypoint in contact.paypoints)
                    {
                        if ( hasSimilarity.location != NSNotFound )
                            break;
                        
                        // Check first case normally
                        hasSimilarity = [contact.name rangeOfString:txtSearchBox.text options:(NSCaseInsensitiveSearch)];
                        if ( hasSimilarity.location == NSNotFound && paypoint != NULL ){
                            hasSimilarity = [[[paypoint componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-+ "]] componentsJoinedByString:@""] rangeOfString:[[txtSearchBox.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()-+ "]] componentsJoinedByString:@""] options:(NSCaseInsensitiveSearch|NSLiteralSearch)];
                        }
                        /*if ( hasSimilarity.location == NSNotFound && contact.emailAddress != NULL ){
                         hasSimilarity = [contact.emailAddress rangeOfString:txtSearchBox.text options:(NSCaseInsensitiveSearch)];
                         }*/
                        // Add $me code implementation ** TODO: **
                        
                        if ( hasSimilarity.location != NSNotFound )
                        {
                            @try
                            {
                                if ( contact.lastName != (id)[NSNull null] && contact.lastName.length > 0 ){
                                    [[filteredResults objectAtIndex:((int)toupper([contact.lastName characterAtIndex:0]))-64] addObject:contact];
                                } else if ( contact.firstName != (id)[NSNull null] && contact.firstName.length > 0 ) {
                                    [[filteredResults objectAtIndex:((int)toupper([contact.firstName characterAtIndex:0]))-64] addObject:contact];
                                } else {
                                    [[filteredResults objectAtIndex:((int)toupper([contact.name characterAtIndex:0]))-64] addObject:contact];
                                }
                                
                                foundFiltered = YES;
                            }
                            @catch (NSException* e) {
                                NSLog(@"Exception: %@, %@ - %@", e, contact.lastName, contact.firstName);
                            }
                        }
                    }
                }
            }
        }
    }
    [tvSubview reloadData];
}

-(void)contactWasSelected:(NSInteger)contactType
{
    
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

-(void)infoButtonClicked: (Contact*) contact;
{
    OrganizationDetailViewController* controller = [[OrganizationDetailViewController alloc] init];
    [controller setContact: contact];
    [controller setDidSetContactAndAmount: self];
    [controller setDidSetContact: self];
    [controller setTitle: @"Info"];
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    
    [self.navigationController presentModalViewController:navBar animated:YES];
    
    [controller release];
    [navBar release];
}
-(void)didSetContactAndAmount: (Contact*)contact amount:(double)amountToSend
{
    [didSetContactAndAmount didSetContactAndAmount:contact amount:amountToSend];
}
-(void)didSetContact: (Contact*)contact
{
    [didSetContact didSetContact:contact];
}

-(void) didSelectButtonWithIndex:(int)index
{
    switch(index)
    {
        case 0:
        {
            [appDelegate dismissAlertView];
            SocialNetworksViewController* controller =
            [[SocialNetworksViewController alloc] init];
            
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller release];
            break;
        }
        case 1:
        {
            [appDelegate dismissAlertView];
            break;
        }
        default:
        {
            [appDelegate dismissAlertView];
            break;
        }
    }
}

-(bool)isSearchingForMeCodes
{
    if ( txtSearchBox.text &&  txtSearchBox.text.length > 0 && [txtSearchBox.text characterAtIndex:0] == '$' )
        return YES;
    else
        return NO;
}

-(bool)shouldShowFacebookLinkCell
{
    if ( [appDelegate.selectedContactList isEqualToString:@"FacebookContacts"] && appDelegate.numberOfFacebookFriends == 0 )
        return TRUE;
    else
        return FALSE;
}

@end