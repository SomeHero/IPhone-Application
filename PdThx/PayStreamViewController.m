//
//  PayStreamViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PayStreamViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJsonParser.h"
#import "SignInViewController.h"
#import "PdThxAppDelegate.h"
#import "Environment.h"

@implementation PayStreamViewController

@synthesize viewPanel;
@synthesize transactionsTableView;


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
    [viewPanel release];
    [transactionsTableView release];

    [transactions release];
    [sections release];
    [transactionsDict release];
    [responseData release];
    [transactionConnection release];
    [signInViewController release];
    
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
    // Do any additional setup after loading the view from its nib.
    //setup internal viewpanel
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    [transactionsTableView setRowHeight:60];
   
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
        Environment *myEnvironment = [Environment sharedInstance];
        NSString *rootUrl = myEnvironment.pdthxWebServicesBaseUrl;
        NSString *apiKey = myEnvironment.pdthxAPIKey;
        
        NSString *urlString = [NSString stringWithFormat: @"%@/services/TransactionService/Transactions/%@?apiKey=%@", rootUrl, userId, apiKey];    
        responseData = [[NSMutableData data] retain];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        transactionConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];

    NSString *teams = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *tempArray = [[parser objectWithString:teams] copy];

    NSMutableArray* tempTransactions = [[[NSMutableArray alloc] initWithArray:tempArray] copy];
    
    transactions = [[NSMutableArray alloc] init];
    sections = [[NSMutableArray alloc] init];
    
    for(int i = 0; i <[tempTransactions count]; i++)
    {
        [transactions addObject:[[[Transaction alloc] initWithDictionary: [tempTransactions objectAtIndex:(NSUInteger) i]] autorelease]];
    }

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
    
    if([transactions count] == 0) {
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

    [parser release];
    [dateFormatter release];
    [teams release];
    [tempArray release];
    [tempTransactions release];
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [sections objectAtIndex:(NSUInteger) section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[transactionsDict objectForKey:[sections objectAtIndex:(NSUInteger) section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TranasctionCell";

    UITransactionTableViewCell *cell = (UITransactionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITransactionTableViewCell alloc] initWithFrame: CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

    NSLog(@"%d", indexPath.section);
    NSLog(@"%d", indexPath.row);

    Transaction* item = [[transactionsDict  objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    // Configure the cell...
    if([item.transactionType isEqualToString: @"Withdrawal"]) {
        cell.lblRecipientUri.text = item.recipientUri;
    }
    else if([item.transactionType isEqualToString: @"Deposit"]) {
        cell.lblRecipientUri.text = item.senderUri;
    }
    [cell.imgTransactionType setImage: [UIImage imageNamed: @"paystream_sent_icon.png"]];
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    [dateFormatter setTimeZone: [NSTimeZone defaultTimeZone]];

    cell.lblAmount.text = [currencyFormatter stringFromNumber: item.amount];
    cell.lblTransactionDate.text = [dateFormatter stringFromDate: item.createDate];
    //cell.imageView.image = [UIImage  imageNamed:@"icon_checkmark.png"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if([item.transactionType isEqualToString: @"Withdrawal"]) {
            [cell.imgTransactionType setImage: [UIImage imageNamed: @"paystream_sent_icon.png"]];
    }
    else if([item.transactionType isEqualToString: @"Deposit"]) {
        [cell.imgTransactionType setImage: [UIImage imageNamed: @"paystream_received_icon.png"]];
    }
    cell.imgTransactionStatus.image = [UIImage imageNamed: @"transaction_complete_icon.png"];

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

    [currencyFormatter release];
    [dateFormatter release];

    [imageView release];
    [altImageView release];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
