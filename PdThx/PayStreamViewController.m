//
//  PayStreamViewController.m
//  PdThx
//
//  Created by James Rhodes on 4/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewControllerV2.h"
#import "PayStreamViewController.h"
#import "SendMoneyController.h"
#import "RequestMoneyController.h"
#import "DoGoodViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SignInViewController.h"
#import "PdThxAppDelegate.h"
#import "GetPayStreamService.h"
#import "GetPayStreamCompleteProtocol.h"
#import "PaystreamMessage.h"
#import "UIPaystreamTableViewCell.h"
#import "IconDownloader.h"
#import "CreateAccountViewController.h"
#import "PaystreamOutgoingPaymentViewController.h"
#import "UIPaystreamLoadingCell.h"
#import "ConnectFacebookCell.h"

@implementation PayStreamViewController
@synthesize tabBar;

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define REFRESH_HEADER_HEIGHT 52.0f

@synthesize viewPanel, psImagesDownloading;
@synthesize transactionsTableView, shadedLayer;
@synthesize ctrlPaystreamTypes, detailView;

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;

@synthesize seenItems;

@synthesize findUserService;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self setupStrings];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setupStrings];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    getPayStreamService = [[GetPayStreamService alloc] init];
    [getPayStreamService setGetPayStreamCompleteDelegate:self];
    
    streamService = [[PaystreamService alloc] init];
    [streamService setUpdateSeenMessagesDelegate:self];
    
    filteredTransactions = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    //setup internal viewpanel
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:0.0]; // Old Width 1.0
    [[viewPanel layer] setCornerRadius: 8.0];
    
    [transactionsTableView setRowHeight:90];
    [transactionsTableView setEditing:NO];
    
    self.psImagesDownloading = [NSMutableDictionary dictionary];
}

- (void)dealloc
{
    [tabBar release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    
    [viewPanel release];
    [transactionsTableView release];

    //[transactions release];
    //[filteredTransactions release];
    [sections release];
    [transactionsDict release];
    [responseData release];
    [signInViewController release];
    [getPayStreamService release];
    [ctrlPaystreamTypes release];
    
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


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tabBar = [[HBTabBarManager alloc]initWithViewController:self topView:self.view delegate:self selectedIndex:1];
    
    [self addPullToRefreshHeader];
    
    CGFloat xOffset = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        xOffset = 224;
    }
    findUserService = [[UserService alloc] init];
    detailView = [[PullableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.90, [[UIScreen mainScreen] bounds].size.height-20)];
    detailView.backgroundColor = [UIColor redColor]; // Transparent view with subviews
    detailView.animate = YES;
    detailView.delegate = self;
    
    detailView.handleView.backgroundColor = [UIColor darkGrayColor];
    detailView.handleView.frame = CGRectMake(0, 0, 40, 40);
    
    detailView.closedCenter = CGPointMake([[UIScreen mainScreen] bounds].size.width + (detailView.frame.size.width/2), [[UIScreen mainScreen] bounds].size.height*0.5+10);
    detailView.openedCenter = CGPointMake([[UIScreen mainScreen] bounds].size.width - (detailView.frame.size.width/2)+20, [[UIScreen mainScreen] bounds].size.height*0.5+10);
    detailView.center = detailView.closedCenter;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:detailView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(8.0, 8.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = detailView.bounds;
    maskLayer.path = maskPath.CGPath;
    detailView.layer.mask = maskLayer;
    
    // Darkened Layer
    shadedLayer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    shadedLayer.backgroundColor = [UIColor blackColor];
    shadedLayer.layer.opacity = 0.0;
    shadedLayer.userInteractionEnabled = NO;
    
    /*
    // Create Shadow Layer
    CAShapeLayer *shadowLayer = [CAShapeLayer layer];
    [shadowLayer setFrame:detailView.bounds];
    [shadowLayer setMasksToBounds:NO];
    [shadowLayer setShadowRadius:5.0];
    [shadowLayer setShouldRasterize:YES];
    [shadowLayer setShadowPath:maskedPath.CGPath];
    [shadowLayer setShadowColor:[UIColor blackColor].CGColor];
    [shadowLayer setShadowOpacity:1.0];
    [shadowLayer setShadowOffset:CGSizeMake(-4.0,5.0)];
    
    CALayer * roundedLayer = [CALayer layer];
    [roundedLayer setFrame:detailView.bounds];
    [roundedLayer setContents:(id)detailView.layer];
    

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    [maskLayer setFrame:detailView.bounds];
    [maskLayer setPath:maskedPath.CGPath];
    
    roundedLayer.mask = maskLayer;
    detailView.layer.mask = maskLayer;
    
    [detailView.layer addSublayer:shadowLayer];
    [detailView.layer addSublayer:roundedLayer];
     */
    
    /* Tracking Seen Paystream Items */
    if ( seenItems == nil )
        seenItems = [[NSMutableArray alloc] init];
    else
        [seenItems removeAllObjects];
    
    /*  Navigation Bar  */
    [self setTitle:@"Paystream"];
    
    // Show View
    [detailView.handleView.layer setCornerRadius:8.0];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:detailView];
    [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:detailView];
    
    [detailView release];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"PayStreamViewController"
                                        withError:&error]){
        //Handle Error Here
    }
    
    // Loading from scratch, show a hard refresh progress dialog.
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) showWithStatus:@"Loading" withDetailedStatus:@"Please wait"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if ( [seenItems count] > 0 ){
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString* userId = [prefs stringForKey:@"userId"];
        
        // Call message service to say that you read items in the array.
        // Using json, construct a dictionary of dictionaries?
        [streamService updateSeenItems:userId withArray:seenItems];
    }
}

-(void)paystreamUpdated:(bool)success
{
    NSLog(@"%@ updating paystream messages as seen/viewed.", success ? @"Succeeded" : @"Failed");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* userId = [prefs stringForKey:@"userId"];
    
    ctrlPaystreamTypes.tintColor = UIColorFromRGB(0x2b9eb8);
    
    if ( [[transactionsDict objectForKey:@"Loading"] count] == 0 ){
        [[transactionsDict objectForKey:@"Loading"] addObject:[[[NSObject alloc] init] autorelease]];
        [transactionsTableView reloadData];
    }
    
    [getPayStreamService getPayStream:userId];
}

-(void)getPayStreamDidFail
{
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    [appDelegate showSimpleAlertView:NO withTitle:@"Paystream Error" withSubtitle:@"No response from server" withDetailedText:@"Loading your paystream items failed. This error will only happen in development. Please be patient." withButtonText:@"Dismiss" withDelegate:self];
}

-(void)didSelectButtonWithIndex:(int)index
{
    // No options, just dismiss.
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) dismissAlertView];
}

-(void)getPayStreamDidComplete:(NSMutableArray*)payStreamMessages
{
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    transactions = [payStreamMessages copy];
    
    [self buildTransactionDictionary: transactions];
    
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
        
        //[self.view addSubview:viewNoItems];
        
        [lblNoItems release];
        [viewNoItems release];
        
    }
    else
    {
        if ( transactionsTableView.hidden == YES )
            [transactionsTableView setHidden:NO];
        
        
        [[self transactionsTableView] reloadData];
        [self loadImagesForOnscreenRows];
    }
    
    // (resort after load if necessary) **pull to refresh
    [self segmentedControlChanged]; // Fix for refreshing paystream while on a non-all tab..
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tabBar = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)buildTransactionDictionary:(NSMutableArray*) array
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate *todaysDate = [NSDate date];
    
    NSDateComponents* comps = [calendar components:NSYearForWeekOfYearCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:todaysDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    [comps setWeekday:1];
    
    NSDate *firstDayOfWeek = [calendar dateFromComponents:comps];
    if ( [comps weekOfMonth] > 0 ) {
        [comps setWeekOfMonth:[comps weekOfMonth]-1];
    }
    
    NSString* todaysDateString = [dateFormatter stringFromDate:todaysDate];
    NSString* todayMonth = [todaysDateString substringToIndex:2];
    NSString* todayYear = [todaysDateString substringFromIndex:6];
    
    
    
    if ( transactionsDict != nil )
        [transactionsDict release];
    
    transactionsDict = [[NSMutableDictionary alloc] init];
    
    if ( sections != nil )
        [sections release];
    
    sections = [[NSMutableArray alloc] init];
    
    int found;
    
    // Creating the loading section.
    [sections addObject:@"Loading"];
    [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey:@"Loading"];
    
    NSDateComponents* itemComponents;
    
    for(Transaction* item in array)
    {
        NSString* transactionDate = [dateFormatter stringFromDate: item.createDate];
        NSString* transactionMonth = [transactionDate substringToIndex:2];
        NSString* transactionYear = [transactionDate substringFromIndex:6];
        
        // NSLog(@"days between dates: TODAY %@ and Transaction %@ -- %d", todaysDateString, transactionDate, [self daysBetweenDate:todaysDate andDate:item.createDate] );
        
        itemComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:item.createDate];
        
        if ( [transactionYear isEqualToString:todayYear] )
        {
            if ( [transactionMonth isEqualToString:todayMonth] )
            {
                if ( [[dateFormatter stringFromDate:todaysDate] isEqualToString:transactionDate] )
                {
                    found = NO;
                    
                    
                    for(int i = 0; i <[sections count]; i++)
                    {
                        if ( [[sections objectAtIndex:i] isEqualToString:@"Today"] )
                        {
                            found = YES;
                            [[transactionsDict objectForKey:@"Today"] addObject:item];
                        }
                    }
                    
                    if ( !found ){
                        [sections addObject:@"Today"];
                        [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey:@"Today"];
                        [[transactionsDict objectForKey:@"Today"] addObject:item];
                    }
                } else if ( [self daysBetweenDate:todaysDate andDate:item.createDate] == 1 ) {
                    found = NO;
                    
                    
                    for(int i = 0; i <[sections count]; i++)
                    {
                        if ( [[sections objectAtIndex:i] isEqualToString:@"Yesterday"] )
                        {
                            found = YES;
                            [[transactionsDict objectForKey:@"Yesterday"] addObject:item];
                        }
                    }
                    
                    if ( !found ){
                        [sections addObject:@"Yesterday"];
                        [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey:@"Yesterday"];
                        [[transactionsDict objectForKey:@"Yesterday"] addObject:item];
                    }
                } else if ( [item.createDate compare:todaysDate] == NSOrderedAscending && [item.createDate compare:firstDayOfWeek] == NSOrderedDescending ) {
                    found = NO;
                    
                    
                    for(int i = 0; i <[sections count]; i++)
                    {
                        if ( [[sections objectAtIndex:i] isEqualToString:@"This Week"] )
                        {
                            found = YES;
                            [[transactionsDict objectForKey:@"This Week"] addObject:item];
                        }
                    }
                    
                    if ( !found ){
                        [sections addObject:@"This Week"];
                        [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey:@"This Week"];
                        [[transactionsDict objectForKey:@"This Week"] addObject:item];
                    }
                } else if ( [item.createDate compare:firstDayOfWeek] == NSOrderedAscending && [self daysBetweenDate:firstDayOfWeek andDate:item.createDate] <= 7 ) {
                    found = NO;
                    
                    
                    for(int i = 0; i <[sections count]; i++)
                    {
                        if ( [[sections objectAtIndex:i] isEqualToString:@"Last Week"] )
                        {
                            found = YES;
                            [[transactionsDict objectForKey:@"Last Week"] addObject:item];
                        }
                    }
                    
                    if ( !found ){
                        [sections addObject:@"Last Week"];
                        [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey:@"Last Week"];
                        [[transactionsDict objectForKey:@"Last Week"] addObject:item];
                    }
                } else {
                    found = NO;
                    
                    
                    for(int i = 0; i <[sections count]; i++)
                    {
                        if ( [[sections objectAtIndex:i] isEqualToString:@"This Month"] )
                        {
                            found = YES;
                            [[transactionsDict objectForKey:@"This Month"] addObject:item];
                        }
                    }
                    
                    if ( !found ){
                        [sections addObject:@"This Month"];
                        [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey:@"This Month"];
                        [[transactionsDict objectForKey:@"This Month"] addObject:item];
                    }
                }
            } else if ( [itemComponents month] == ( [todayMonth intValue] == 1 ? 12 : [todayMonth intValue]-1 ) ) {
                found = NO;
                
                
                for(int i = 0; i <[sections count]; i++)
                {
                    if ( [[sections objectAtIndex:i] isEqualToString:@"Last Month"] )
                    {
                        found = YES;
                        [[transactionsDict objectForKey:@"Last Month"] addObject:item];
                    }
                }
                
                if ( !found ){
                    [sections addObject:@"Last Month"];
                    [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey:@"Last Month"];
                    [[transactionsDict objectForKey:@"Last Month"] addObject:item];
                }
            } else {
                found = NO;
                
                for(int i = 0; i <[sections count]; i++)
                {
                    if ( [[sections objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]] )
                    {
                        found = YES;
                        [[transactionsDict objectForKey:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]] addObject:item];
                    }
                }
                
                if ( !found ){
                    [sections addObject:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]];
                    [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]];
                    [[transactionsDict objectForKey:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]] addObject:item];
                }
            }
        } else {
            found = NO;
            
            for(int i = 0; i <[sections count]; i++)
            {
                if ( [[sections objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]] )
                {
                    found = YES;
                    [[transactionsDict objectForKey:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]] addObject:item];
                }
            }
            
            if ( !found ){
                [sections addObject:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]];
                [transactionsDict setValue:[[[NSMutableArray alloc] init] autorelease] forKey:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]];
                [[transactionsDict objectForKey:[NSString stringWithFormat:@"%@ %@", [[dateFormatter monthSymbols] objectAtIndex:([transactionMonth intValue]-1)], transactionYear]] addObject:item];
            }
        }
    }
    
    [dateFormatter release];
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

/*
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,320,25)] autorelease];
    
    // create the imageView with the image in it
    
    //UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-section-320x25.png"]] autorelease];
    //imageView.frame = CGRectMake(0,0,320,25);
    
    customView.backgroundColor = [UIColor colorWithRed:109/255.0 green:110/255.0 blue:114/255.0 alpha:1.0];

    
    // create the label objects
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    headerLabel.frame = CGRectMake(0,0,320,25);
    headerLabel.text =  [sections objectAtIndex:section];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment =  UITextAlignmentCenter;
    
    //[customView addSubview:imageView];
    [customView addSubview:headerLabel];
    
    return customView;
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
        return 32.0;
    else
        return transactionsTableView.rowHeight; // We're setting table row height somewhere lower in the project.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section == 0 ) // Loading Label Section -- No header, only one small height cell.
        return 0.0;
    else if ( [[transactionsDict  objectForKey:[sections objectAtIndex:section]] count] )
        return 25.0;
    else
        return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"transactionCell";
    
    if ( indexPath.section == 0 )
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"UIPaystreamLoadingTableViewCell" owner:self options:nil];
        UIPaystreamLoadingCell*cell = [nib objectAtIndex:0];
        return cell;
    }
    
    UIPaystreamTableViewCell*cell = (UIPaystreamTableViewCell*)[transactionsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    
    [cell.transactionImageButton setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
    
    
    PaystreamMessage* item = [[transactionsDict  objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    // Configure the cell...
    if([item.direction isEqualToString:@"Out"])
    {
        if ( [self isPhoneNumber:item.recipientUri] )
        {
            Contact * foundContact;
            
            foundContact = [findUserService findContactByPhoneNumber:item.recipientUri];
            
            if ( foundContact )
            {
                [item setRecipientName:foundContact.name];
                [item setImgData:foundContact.imgData];
            }
        }
        
        cell.transactionRecipient.text = [NSString stringWithFormat: @"%@", item.recipientName];
    } else {
        //019)(109)(113)
        
        if ( [self isPhoneNumber:item.senderUri] )
        {
            Contact * foundContact;
            
            foundContact = [findUserService findContactByPhoneNumber:item.senderUri];
            
            if ( foundContact )
            {
                [item setSenderName:foundContact.name];
                [item setImgData:foundContact.imgData];
            }
        }
        
        cell.transactionRecipient.text = [NSString stringWithFormat: @"%@", item.senderName];
    }
    
    
    if ( !item.imgData && item.transactionImageUri != (id)[NSNull null] )
    {
        
        if (transactionsTableView.dragging == NO && transactionsTableView.decelerating == NO) {
            [self startIconDownload:item forIndexPath:indexPath];
        } 
        
        // if a download is deferred or in progress, return a placeholder image
        [cell.transactionImageButton setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
    } else if ( item.imgData ) {
        [cell.transactionImageButton setBackgroundImage:item.imgData forState:UIControlStateNormal];
    }
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    [dateFormatter setTimeZone: [NSTimeZone defaultTimeZone]];

    NSString* amount = [NSString stringWithString:[currencyFormatter stringFromNumber: item.amount]];
    
    
    // Coloring
    if([item.messageType isEqualToString: @"Payment"])
    {
        if([item.direction isEqualToString: @"In"])
        {
            if ( item.recipientHasSeen == false )
                cell.newColorStrip.backgroundColor = UIColorFromRGB(0x3D934C); // UPDATED BRIGHT PAYSTREAM GREEN
            else
                cell.newColorStrip.backgroundColor = [UIColor clearColor];
        }
        else
        {
            if ( item.senderHasSeen == false )
                cell.newColorStrip.backgroundColor = UIColorFromRGB(0x136D71); // UPDATED BRIGHT PAYSTREAM BLUE
            else
                cell.newColorStrip.backgroundColor = [UIColor clearColor];
        }
    }
    else
    {
        if([item.direction isEqualToString: @"In"])
        {
            if ( item.senderHasSeen == false ){
                if ( [item.messageStatus isEqualToString:@"Accepted"] || [item.messageStatus isEqualToString:@"Rejected"] )
                    cell.newColorStrip.backgroundColor = UIColorFromRGB(0x136D71); // BLUE
                else
                    cell.newColorStrip.backgroundColor = UIColorFromRGB(0x688891); // FADED BLUE (Pending)
            }
            else
                cell.newColorStrip.backgroundColor = [UIColor clearColor];
        }
        else
        {
            if ( item.senderHasSeen == false ){
                if ( [item.messageStatus isEqualToString:@"Accepted"] || [item.messageStatus isEqualToString:@"Rejected"] )
                    cell.newColorStrip.backgroundColor = UIColorFromRGB(0x3D934C); // Green
                else
                    cell.newColorStrip.backgroundColor = UIColorFromRGB(0x648E6F); // Faded Green
            }
            else
                    cell.newColorStrip.backgroundColor = [UIColor clearColor];
        }
    }
    
    // Coloring
    if([item.messageType isEqualToString: @"Payment"])
    {
        if([item.direction isEqualToString: @"In"])
        {
            cell.transactionAmount.textColor = UIColorFromRGB(0x3D934C); // Green
            cell.transactionAmount.text = [NSString stringWithFormat: @"+ %@", amount];
        }
        else
        {
            cell.transactionAmount.textColor = UIColorFromRGB(0x136D71); // BLUE
            cell.transactionAmount.text = [NSString stringWithFormat: @"- %@", amount];
        }
    }
    else
    {
        if([item.direction isEqualToString: @"In"])
        {
                if ( [item.messageStatus isEqualToString:@"Accepted"] || [item.messageStatus isEqualToString:@"Rejected"] )
                    cell.transactionAmount.textColor = UIColorFromRGB(0x136D71); // BLUE
                else
                    cell.transactionAmount.textColor = UIColorFromRGB(0x688891); // FADED BLUE (Pending)
            
            cell.transactionAmount.text = [NSString stringWithFormat: @"- %@", amount];
        }
        else
        {
                if ( [item.messageStatus isEqualToString:@"Accepted"] || [item.messageStatus isEqualToString:@"Rejected"] )
                    cell.transactionAmount.textColor = UIColorFromRGB(0x3D934C); // Green
                else
                    cell.transactionAmount.textColor = UIColorFromRGB(0x648E6F); // Faded Green
            
            cell.transactionAmount.text = [NSString stringWithFormat: @"+ %@", amount];
        }
    }
    
    // Coloring
    if([item.messageType isEqualToString: @"Payment"])
    {
        if([item.direction isEqualToString: @"In"])
        {
            cell.lblTransactionDirection.textColor = UIColorFromRGB(0x3D934C); // Green
        }
        else
        {
            cell.lblTransactionDirection.textColor = UIColorFromRGB(0x136D71); // BLUE
        }
    }
    else
    {
        if([item.direction isEqualToString: @"In"])
        {
            if ( [item.messageStatus isEqualToString:@"Accepted"] || [item.messageStatus isEqualToString:@"Rejected"] )
                cell.lblTransactionDirection.textColor = UIColorFromRGB(0x136D71); // BLUE
            else
                cell.lblTransactionDirection.textColor = UIColorFromRGB(0x688891); // FADED BLUE (Pending)
        }
        else
        {
            if ( [item.messageStatus isEqualToString:@"Accepted"] || [item.messageStatus isEqualToString:@"Rejected"] )
                cell.lblTransactionDirection.textColor = UIColorFromRGB(0x3D934C); // Green
            else
                cell.lblTransactionDirection.textColor = UIColorFromRGB(0x648E6F); // Faded Green
        }
    }
    
    cell.transactionDate.text = [dateFormatter stringFromDate: item.createDate];
    //cell.imageView.image = [UIImage  imageNamed:@"icon_checkmark.png"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if([item.messageType isEqualToString: @"Payment"])
    {
        if([item.direction isEqualToString: @"In"])
            cell.lblTransactionDirection.text = @"Sent money to you";
        else
            cell.lblTransactionDirection.text = @"You sent money to them";
    }
    else {
        if([item.direction isEqualToString: @"In"])
            cell.lblTransactionDirection.text = @"Request money from you";
        else
            cell.lblTransactionDirection.text = @"You requested money from them";
    }
    
    cell.overlayView.layer.opacity = 0.0;   
   
    UIImage *imgAcceptedImageView = [UIImage imageNamed: @"stampPaid.png"];
    
    UIImage *imgRejectedImageView = [UIImage imageNamed: @"stampRejected.png"];
    
    UIImage *imgCancelledImageView = [UIImage imageNamed: @"stampCancelled.png"];
    
    UIImage *imgReturnedImageView = [UIImage imageNamed: @"stampReturned.png"];
    
    [cell.stampView setHidden:YES];
    if([item.messageStatus isEqualToString: @"Accepted"])
    {
        [cell.stampView setHidden:NO];
        [cell.stampView setImage: imgAcceptedImageView];
        cell.overlayView.layer.opacity = 0.6;   
    }
    if([item.messageStatus isEqualToString: @"Rejected"])
    {
        [cell.stampView setHidden:NO];
        [cell.stampView setImage:imgRejectedImageView];
        cell.overlayView.layer.opacity = 0.6;   
    }
    
    if([item.messageStatus isEqualToString: @"Cancelled"])
    {
        [cell.stampView setHidden:NO];
        [cell.stampView setImage: imgCancelledImageView];
        cell.overlayView.layer.opacity = 0.6;   
    }
        
    cell.transactionStatus.text = item.messageStatus;
    cell.lblComments.text = item.comments;
        
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
    [cell.transactionImageButton.layer setBorderWidth:0.2];
    [cell.transactionImageButton.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    [currencyFormatter release];
    [dateFormatter release];

    [imageView release];
    [altImageView release];

    return cell;
}

-(bool)isPhoneNumber:(NSString*)recipientName
{
    // The only cases we need to handle are: Phone Number and Email
    NSString * numOnly = [[recipientName componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSRange numOnly2 = [[[recipientName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-() "]] componentsJoinedByString:@""] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]  options:NSCaseInsensitiveSearch];
    
    if ( [recipientName isEqualToString:numOnly] || numOnly2.location == NSNotFound ) {
        // Is only Numbers, I think?
        if ( [numOnly characterAtIndex:0] == '1' || [numOnly characterAtIndex:0] == '0' )
            numOnly = [numOnly substringFromIndex:1]; // Do not include country codes
        
        if ( [numOnly length] == 10 )
            return YES;
    }
    
    return NO;
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
    } else {
        [self appImageDidLoad:indexPath];
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
    
    if (iconDownloader != nil && iconDownloader.message.imgData )
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

/*
 
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
    PaystreamMessage* item = [[transactionsDict  objectForKey:[sections objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    // Record the paystream item as being "seen".
    [seenItems addObject:[NSString stringWithFormat:@"%@",item.messageId]];
    if ( [item.direction isEqualToString:@"Out"] ){
        // Outgoing, user is sender.
        item.senderHasSeen = true;
        [transactionsTableView reloadData];
    } else if ( [item.direction isEqualToString:@"In"] ) {
        // Outgoing, user is sender.
        item.recipientHasSeen = true;
        [transactionsTableView reloadData];
    }
    
    PaystreamDetailBaseViewController* outgoingView =  [[PaystreamOutgoingPaymentViewController alloc] init];
    
    outgoingView.messageDetail = item;
    
    [self.navigationController pushViewController:outgoingView animated:YES];
}

-(IBAction)segmentedControlChanged
{
    // then use a switch statement or series of if statements to determine which selectedSegmentIndex was touched to control the views
    
    filteredTransactions = [[NSMutableArray alloc] init];
    
    if ([ctrlPaystreamTypes selectedSegmentIndex] == 0) {
        for (PaystreamMessage* transaction in transactions ){
            [filteredTransactions addObject: transaction];
        }
    }
    else if([ctrlPaystreamTypes selectedSegmentIndex] == 1) {
        for (PaystreamMessage* transaction in transactions ){
            if(([transaction.direction isEqualToString: @"Out"]) && ([transaction.messageType isEqualToString: @"Payment"]) && (([transaction.messageStatus isEqualToString: @"Submitted"]) || ([transaction.messageStatus isEqualToString: @"Processing"]) || ([transaction.messageStatus isEqualToString  : @"Complete"])))
                [filteredTransactions addObject: transaction];
        }
    }
    else if([ctrlPaystreamTypes selectedSegmentIndex] == 2) {
        for (PaystreamMessage* transaction in transactions ){
            if(([transaction.direction isEqualToString: @"In"]) && ([transaction.messageType isEqualToString: @"Payment"]) && (([transaction.messageStatus isEqualToString: @"Submitted"]) || ([transaction.messageStatus isEqualToString: @"Processing"]) || ([transaction.messageStatus isEqualToString  : @"Complete"])))
                [filteredTransactions addObject: transaction];
        }
    }
    else if([ctrlPaystreamTypes selectedSegmentIndex] == 3) {
        for (PaystreamMessage* transaction in transactions ){
            if(([transaction.messageType isEqualToString: @"PaymentRequest"]))
                [filteredTransactions addObject: transaction];
        }
    }
    
    [self buildTransactionDictionary: filteredTransactions];
    
    [transactionsTableView reloadData];
    
    [filteredTransactions release];
}


- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened
{
    if ( ! opened ) { // View totally closed
        [shadedLayer removeFromSuperview];
    }
}

- (void)pullableView:(PullableView *)pView didMoveLocation:(float)relativePosition
{
    shadedLayer.layer.opacity = ( 0.7 - (0.7 * relativePosition));
}


- (void)pullableView:(PullableView *)pView startedAnimation:(float)animationDuration withDirection:(BOOL)directionBoolean;
{
    
    if ( directionBoolean ){
        [[[[UIApplication sharedApplication] delegate] window] addSubview:shadedLayer];
        [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:detailView];
    
        if ( detailView.layer.position.x != detailView.openedCenter.x ){
            [UIView animateWithDuration:animationDuration animations:^{
                shadedLayer.layer.opacity = 0.7;
            }];
            
            /*
            [UIView beginAnimations:@"Darken" context:NULL];
            [UIView setAnimationDuration:animationDuration];
            shadedLayer.layer.opacity = 0.7;
            [UIView commitAnimations];
             */
        }
    } else {
        [UIView animateWithDuration:animationDuration animations:^{
            shadedLayer.layer.opacity = 0.0;
        }];
    }
}

/* -------------------------------------
        Pull to Refresh
    ------------------------------------ */


- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-pulltorefresh.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.transactionsTableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.transactionsTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.transactionsTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else { 
                // User is scrolling somewhere within the header
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}


// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (isLoading)
    {
        return;
    }
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
    else if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (isLoading)
    {
        return;
    }
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
    else {
        [self loadImagesForOnscreenRows];
        
    }
}


- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.transactionsTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.transactionsTableView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    } 
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete:finished:context:)];
                     }];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
    
    [self loadImagesForOnscreenRows];
}

- (void)refresh
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* userId = [prefs stringForKey:@"userId"];
    
    ctrlPaystreamTypes.tintColor = UIColorFromRGB(0x2b9eb8);
    
    [getPayStreamService getPayStream:userId];
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0.5];
}



- (void)tabBarClicked:(NSUInteger)buttonIndex
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //NSLog(@"Switching to tab index:%d",buttonIndex);
    UIViewController* newView = [appDelegate switchMainAreaToTabIndex:buttonIndex fromViewController:self];
    
    //NSLog(@"NewView: %@",newView);
    if ( newView != nil  && ! [self isEqual:newView])
    {
        //NSLog(@"Switching views, validated that %@ =/= %@",[self class],[newView class]);
        
        [[self navigationController] pushViewController:newView animated:NO];
        
        // Get the list of view controllers
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
}



- (int)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return abs([difference day]);
}


@end
