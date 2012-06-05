//
//  PayStreamViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PayStreamViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SignInViewController.h"
#import "PdThxAppDelegate.h"
#import "GetPayStreamService.h"
#import "GetPayStreamCompleteProtocol.h"
#import "PaystreamMessage.h"
#import "UIPaystreamTableViewCell.h"
#import "IconDownloader.h"

@implementation PayStreamViewController

@synthesize viewPanel, psImagesDownloading;
@synthesize transactionsTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    getPayStreamService = [[GetPayStreamService alloc] init];
    [getPayStreamService setGetPayStreamCompleteDelegate:self];
    
    // Do any additional setup after loading the view from its nib.
    //setup internal viewpanel
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    [transactionsTableView setRowHeight:60];
    [transactionsTableView setEditing:NO];
    
    self.psImagesDownloading = [NSMutableDictionary dictionary];
}

- (void)dealloc
{
    [viewPanel release];
    [transactionsTableView release];

    [transactions release];
    [sections release];
    [transactionsDict release];
    [responseData release];
    [signInViewController release];
    [getPayStreamService release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)signInDidComplete {
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(void)achSetupDidComplete {
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

-(void) signOutClicked {
    PdThxAppDelegate *appDelegate = (PdThxAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate signOut];
    
    UINavigationController *navController = self.navigationController;
    
    signInViewController = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    [signInViewController setSignInCompleteDelegate: self];
    [signInViewController setAchSetupCompleteDelegate:self];
    
    [navController pushViewController:signInViewController animated: YES];
    
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* userId = [prefs stringForKey:@"userId"];
    
    if([userId length] == 0)
    {
       signInViewController = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
        
        [signInViewController setSignInCompleteDelegate: self];
        [signInViewController setAchSetupCompleteDelegate:self];
        
        //[self.view addSubview:signInViewController.view];
        [self.navigationController pushViewController:signInViewController animated:NO];

    } else {
        
        [getPayStreamService getPayStream:userId];

    }
}
-(void)getPayStreamDidComplete:(NSMutableArray*)payStreamMessages
{
    NSLog(@"Got paystream messages");
    
    transactions = [payStreamMessages copy];
    sections = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyy"];
    
    bool found;
    transactionsDict = [[NSMutableDictionary alloc] init];
    
    for(Transaction* item in transactions)
    {
        NSString* transactionDate = [dateFormatter stringFromDate: item.createDate];
        
        found = NO;
        
        for(int i = 0; i <[sections count]; i++)
        {
            NSString * myDate = [sections objectAtIndex:(NSUInteger) i];
            
            if ([myDate isEqualToString:transactionDate])
            {
                found = YES;
            }
        }
        
        if(!found) {
            [sections addObject: transactionDate];
            [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey: transactionDate];
        }
    }
    
    for(Transaction* item in transactions)
    {
        
        NSString* transactionDate = [dateFormatter stringFromDate: item.createDate];
        
        [[transactionsDict objectForKey:transactionDate] addObject:item];
    }
    
    if([transactions count] == 0) 
    {
        [transactionsTableView setHidden:YES];
        
        NSString* noItems = [NSString stringWithString:  @"You have no items in your paystream.  Start sending or requesting some money!"];
        
        CGSize constraintSize;
        
        constraintSize.width = 300.0f;
        constraintSize.height = MAXFLOAT;
        
        CGSize stringSize =[noItems sizeWithFont: [UIFont boldSystemFontOfSize: 16] constrainedToSize: constraintSize lineBreakMode: UILineBreakModeWordWrap];
        
        CGRect rect = CGRectMake(10, 120, stringSize.width, stringSize.height);
        
        UILabel* lblNoItems = [[UILabel alloc] initWithFrame: CGRectMake(12, 12, transactionsTableView.frame.size.width - 32, rect.size.height)];
        
        [lblNoItems setText: noItems];
        [lblNoItems setBackgroundColor: [UIColor clearColor]];
        lblNoItems.textAlignment = UITextAlignmentLeft;
        lblNoItems.lineBreakMode = UILineBreakModeWordWrap;
        lblNoItems.baselineAdjustment = UIBaselineAdjustmentNone;
        [lblNoItems setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
        lblNoItems.numberOfLines = 0;
        
        UIView* viewNoItems = [[UIView alloc] initWithFrame:CGRectMake(8, transactionsTableView.frame.origin.y + 20, transactionsTableView.frame.size.width - 20, rect.size.height + 24)];
        
        [[viewNoItems layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
        [[viewNoItems layer] setBorderWidth:1.5];
        [[viewNoItems layer] setCornerRadius: 8.0];
        [viewNoItems setBackgroundColor: [UIColor whiteColor]];
        [viewNoItems addSubview: lblNoItems];
        
        [self.view addSubview:viewNoItems];
        
        [lblNoItems release];
        [viewNoItems release];
        
    }
    else
    {
        [transactionsTableView setHidden:NO];
        
        [[self transactionsTableView] reloadData];
    }
    
    [dateFormatter release];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[transactionsDict allKeys] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [sections objectAtIndex:(NSUInteger) section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[transactionsDict objectForKey:[sections objectAtIndex:(NSUInteger) section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"transactionCell";
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* userId = [prefs stringForKey:@"userId"];
    NSString* mobileNumber = [prefs stringForKey:@"mobileNumber"];
    
    UIPaystreamTableViewCell*cell = (UIPaystreamTableViewCell*)[transactionsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
                                     
    if (cell == nil){
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.transactionImageButton setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];

    PaystreamMessage* item = [[transactionsDict  objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    // Configure the cell...
    if([item.direction isEqualToString:@"Out"]) {
        //cell.transactionRecipient.text = [NSString stringWithFormat:@"row:%d sec%d",indexPath.row,indexPath.section];
        cell.transactionRecipient.text = [NSString stringWithFormat: @"%@", item.recipientName];
    } else {
        //cell.transactionRecipient.text = [NSString stringWithFormat:@"row:%d sec%d",indexPath.row,indexPath.section];
        cell.transactionRecipient.text = [NSString stringWithFormat: @"%@", item.senderName];
    }
    
    NSLog(@"Image stored for amount %@ : %@", item.amount,item.transactionImageUri);
    if ( !item.imgData && item.transactionImageUri != (id)[NSNull null] )
    {
        if (transactionsTableView.dragging == NO && transactionsTableView.decelerating == NO)
        {
            [self startIconDownload:item forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        [cell.transactionImageButton setBackgroundImage:[UIImage imageNamed:@"avatar_unknown.jpg"] forState:UIControlStateNormal];
    } else if ( item.imgData ) {
        [cell.transactionImageButton setBackgroundImage:item.imgData forState:UIControlStateNormal];
    }
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    [dateFormatter setTimeZone: [NSTimeZone defaultTimeZone]];

    cell.transactionAmount.text = [currencyFormatter stringFromNumber: item.amount];
    cell.transactionDate.text = [dateFormatter stringFromDate: item.createDate];
    //cell.imageView.image = [UIImage  imageNamed:@"icon_checkmark.png"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if([item.senderUri isEqualToString: mobileNumber])
        if([item.messageType isEqualToString: @"Payment"])
            cell.transactionType.text = @"Payment";
        else
            cell.transactionType.text = @"Payment Request";
                      
    
    cell.transactionStatus.text = item.messageStatus;
        
    UIImage *backgroundImage = [UIImage imageNamed: @"transaction_row_background"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [imageView setContentMode:UIViewContentModeScaleToFill];

    UIImage *altBackgroundImage = [UIImage imageNamed: @"transaction_rowalt_background"];
    UIImageView *altImageView = [[UIImageView alloc] initWithImage:altBackgroundImage];
    [altImageView setContentMode:UIViewContentModeScaleToFill];
    
    if (indexPath.row%2 == 0)  {
        cell.backgroundView = imageView;
    } else {
        cell.backgroundView = altImageView;
    }
    
    [cell.transactionImageButton.layer setCornerRadius:12.0];
    [cell.transactionImageButton.layer setMasksToBounds:YES];
    
    [currencyFormatter release];
    [dateFormatter release];

    [imageView release];
    [altImageView release];

    return cell;
}




#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(PaystreamMessage *)message forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [psImagesDownloading objectForKey:indexPath];
    
    if ( iconDownloader == nil )
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.message = message;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [psImagesDownloading setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}


// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([transactionsDict count] > 0)
    {
        NSArray *visiblePaths = [transactionsTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            PaystreamMessage *message = [[transactionsDict  objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            
            if ( !message.imgData ) // avoid the app icon download if the app already has an icon
            {
                if ( [[message direction] isEqualToString:@"Out"] )
                    [self startIconDownload:message forIndexPath:indexPath];
                else
                    [self startIconDownload:message forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [psImagesDownloading objectForKey:indexPath];
    
    if (iconDownloader != nil)
    {
        UIPaystreamTableViewCell *cell = (UIPaystreamTableViewCell*)[transactionsTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        [cell.transactionImageButton setBackgroundImage:iconDownloader.message.imgData forState:UIControlStateNormal];
    }
    
    iconDownloader = nil;
    [iconDownloader release];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


@end
