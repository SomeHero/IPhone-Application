//
//  HomeViewControllerV2.m
//  PdThx
//
//  Created by James Rhodes on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewControllerV2.h"
#import "PayStreamViewController.h"
#import "SendMoneyController.h"
#import "RequestMoneyController.h"
#import "DoGoodViewController.h"

#import "QuickSendView.h"

#import "PdThxAppDelegate.h"
#import "PhoneNumberFormatting.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation HomeViewControllerV2

@synthesize lblUserName;
@synthesize quickSendView;
@synthesize viewPanel;
@synthesize tabBar;

@synthesize quickSendOpened;

@synthesize swipeUpQuicksend;
@synthesize swipeDownQuicksend;
@synthesize incomingNotificationLabel, outgoingNotificationLabel;
@synthesize quickSendContacts;
@synthesize loadingActivityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        [self setTitle:@"Home"];
        
    }
    return self;
}

- (void)dealloc
{
    [tabBar release];
    [viewPanel release];
    [lblUserName release];
    [userService release];
    
    [quickSendView release];
    [swipeDownQuicksend release];
    [swipeUpQuicksend release];
    [incomingNotificationLabel release];
    [outgoingNotificationLabel release];
    [quickSendView release];
    [loadingActivityIndicator release];
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
    [super viewDidLoad];
    
    tabBar = [[HBTabBarManager alloc]initWithViewController:self topView:self.view delegate:self selectedIndex:0];
    
    // Do any additional setup after loading the view from its nib.
    //setup internal viewpanel
    userService = [[UserService alloc] init];
    [userService setUserInformationCompleteDelegate: self];
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:0.0]; // Old Width 1.0
    [[viewPanel layer] setBorderColor:[UIColor colorWithRed:166/255.0 green:168/255.0 blue:168/255.0 alpha:1.0].CGColor];
    
    [[viewPanel layer] setCornerRadius: 6.0];
    
    [[quickSendView layer] setCornerRadius: 8.0];
    
    [btnUserImage.layer setCornerRadius:11.0];
    [btnUserImage.layer setMasksToBounds:YES];
    [btnUserImage.layer setBorderWidth:0.2];
    [btnUserImage.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    UIImage *imgProfileActive = [UIImage imageNamed: @"btn-profile-308x70-active.png"];
    [btnProfile setImage: imgProfileActive forState:UIControlStateHighlighted];
    
    
    [quickSendView addSubview:[[[NSBundle mainBundle] loadNibNamed:@"QuickSendView" owner:self options:nil] objectAtIndex:0]];
    
    [quickSendView  setButtonDelegate:self];
    
    swipeUpQuicksend = [[UISwipeGestureRecognizer alloc] initWithTarget:quickSendView action:@selector(handleSwipeUp)];
    swipeDownQuicksend = [[UISwipeGestureRecognizer alloc] initWithTarget:quickSendView action:@selector(handleSwipeDown)];
    
    swipeUpQuicksend.numberOfTouchesRequired = 1;
    swipeDownQuicksend.numberOfTouchesRequired = 1;
    
    swipeUpQuicksend.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDownQuicksend.direction = UISwipeGestureRecognizerDirectionDown;
    
    [[quickSendView.subviews objectAtIndex:0] addGestureRecognizer:swipeUpQuicksend];
    [[quickSendView.subviews objectAtIndex:0] addGestureRecognizer:swipeDownQuicksend];
    
    swipeUpQuicksend.delegate = self;
    swipeDownQuicksend.delegate = self;
    
    [loadingActivityIndicator startAnimating];
    loadingActivityIndicator.hidesWhenStopped = YES;
    
    [self setTitle: @"Home"];
}

- (void) quicksendSwipedUp
{
    if ( ! quickSendOpened ){
        [UIView animateWithDuration:0.4 animations:^{
            quickSendView.frame = CGRectMake(quickSendView.frame.origin.x, quickSendView.frame.origin.y-219, quickSendView.frame.size.width, quickSendView.frame.size.height+219);
        } completion:^(BOOL finished) {
            quickSendOpened = 1;
        }];
    }
}

- (void) quicksendSwipedDown
{
    if ( quickSendOpened ){
        [UIView animateWithDuration:0.4 animations:^{
            
            quickSendView.frame = CGRectMake(quickSendView.frame.origin.x, quickSendView.frame.origin.y+219, quickSendView.frame.size.width, quickSendView.frame.size.height-219);
        } completion:^(BOOL finished) {
            quickSendOpened = 0;
        }];
    }
}

#pragma mark - View lifecycle
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    lblPayPoints.text = @"";
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    incomingNotificationLabel.text = [NSString stringWithFormat:@"%d",[prefs integerForKey:@"IncomingNotificationCount"]];
    outgoingNotificationLabel.text =  [NSString stringWithFormat:@"%d",[prefs integerForKey:@"OutgoingNotificationCount"]];
    
    lblUserName.text = [prefs stringForKey:@"PdThx_PreferredName"];
    
    NSString* userId = [prefs stringForKey:@"userId"];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    lblUserName.text = appDelegate.user.preferredName;
    
    
    NSString * numOnly = [[appDelegate.user.userUri componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    if ( [[appDelegate.user.userUri substringToIndex:3]  isEqualToString:@"fb_"] )
        lblPayPoints.text = @"Facebook User";
    else if ( [numOnly isEqualToString:appDelegate.user.userUri] )
        lblPayPoints.text = [phoneNumberFormatter stringToFormattedPhoneNumber:appDelegate.user.userUri];
    else
        lblPayPoints.text = appDelegate.user.userUri;
    
    if ( appDelegate.user.imageUrl != (id)[NSNull null] && appDelegate.user.imageUrl.length > 0 )
    {
        [btnUserImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:appDelegate.user.imageUrl]]] forState:UIControlStateNormal];
    } else {
        [btnUserImage setBackgroundImage:[UIImage imageNamed:@"avatar-50x50.png"] forState:UIControlStateNormal];
    }
    
    loadingActivityIndicator.hidden = NO;
    [loadingActivityIndicator startAnimating];
    [userService refreshHomeScreenInformation:userId];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)userHomeScreenInformationDidComplete:(NSMutableArray *)quickSendContactArray
{
    [loadingActivityIndicator stopAnimating];
    
    quickSendContacts = quickSendContactArray;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"Incoming: %d Outgoing: %d",[prefs integerForKey:@"IncomingNotificationCount"],[prefs integerForKey:@"OutgoingNotificationCount"]);
    incomingNotificationLabel.text = [NSString stringWithFormat:@"%d",[prefs integerForKey:@"IncomingNotificationCount"]];
    outgoingNotificationLabel.text =  [NSString stringWithFormat:@"%d",[prefs integerForKey:@"OutgoingNotificationCount"]];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //NSLog(@"Facebook Session: %@", [appDelegate.fBook isSessionValid] ? @"YES" : @"NO");
    
    [[quickSendView.subviews objectAtIndex:0] reloadQuickSendContacts:quickSendContacts];
}

-(void)userHomeScreenInformationDidFail:(NSString *)message withErrorCode:(int)errorCode
{
    NSLog(@"Loading homescreen&quicksendcontacts failed.");
}

-(void)userInformationDidComplete:(User*) user
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user = [user copy];
    
    if (user.securityQuestion != (id) [NSNull null] && user.securityQuestion.length > 0) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setValue:user.securityQuestion forKey:@"securityQuestion"];
        [prefs synchronize];
    }
    
    if(user.imageUrl != (id)[NSNull null] && [user.imageUrl length] > 0) {
        [btnUserImage setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: user.imageUrl]]] forState:UIControlStateNormal];
    } else {
        [btnUserImage setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
    }
    
    lblUserName.text = user.preferredName;
    if ( [[user.userName substringToIndex:3] isEqualToString:@"fb_"] )
        lblPayPoints.text = @"Facebook User";
    else
        lblPayPoints.text = user.userName;
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    [numberFormatter release];
}


-(void)userInformationDidFail:(NSString*) message withErrorCode:(int)errorCode {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
}
- (void)viewDidUnload
{
    self.tabBar = nil;
    [self setQuickSendView:nil];
    [incomingNotificationLabel release];
    incomingNotificationLabel = nil;
    [outgoingNotificationLabel release];
    outgoingNotificationLabel = nil;
    [self setQuickSendView:nil];
    [loadingActivityIndicator release];
    loadingActivityIndicator = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(IBAction) btnProfileClicked:(id) sender {
    EditProfileViewController* controller = [[EditProfileViewController alloc] init];
    [controller setTitle: @"Me"];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}
-(IBAction) btnPaystreamClicked: (id) sender {
    [self tabBarClicked:1];
}

-(IBAction) btnIncreaseScoreClicked: (id) sender {
    IncreaseProfileViewController* controller = [[IncreaseProfileViewController alloc] init];
    
    UINavigationController *navBar=[[UINavigationController alloc]initWithRootViewController:controller];
    //[controller setTitle: @"Add Your FaceBook Account"];
    //[controller setHeaderText: @"Add another bank account by entering the account information below"];
    
    [self presentModalViewController:navBar animated:YES];
    [navBar release];
    [controller release];
}



- (IBAction)qs1pressed:(id)sender
{
    [self clickedQuickSend:1];
}

- (IBAction)qs2pressed:(id)sender
{
    [self clickedQuickSend:2];
}

- (IBAction)qs3pressed:(id)sender
{
    [self clickedQuickSend:3];
}

- (IBAction)qs4pressed:(id)sender
{
    [self clickedQuickSend:4];
}

- (IBAction)qs5pressed:(id)sender
{
    [self clickedQuickSend:5];
}

- (IBAction)qs6pressed:(id)sender
{
    [self clickedQuickSend:6];
}

- (IBAction)qs7pressed:(id)sender
{
    [self clickedQuickSend:7];
}

- (IBAction)qs8pressed:(id)sender
{
    [self clickedQuickSend:8];
}

- (IBAction)qs9pressed:(id)sender
{
    [self clickedQuickSend:9];
}

-(void)clickedQuickSend:(int)buttonValue
{
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    buttonValue--;
    // REMEMBER: BUTTON INDEXES START AT 1 (number pad layout)
    // INDEX IN QUICK SEND ARRAY WILL BE BUTTONVALUE-1 (done above)
    
    //NSDictionary*contactDict = [quickSendContacts objectAtIndex:buttonValue];
    
    switch (buttonValue)
    {
        case 0:
        {
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"PhoneContacts"];
            
            SendMoneyController* dvc = [[SendMoneyController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            
            [dvc viewDidLoad]; // Force load of SendMoneyViewController
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:self];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            
            [allViewControllers release];
            
            [dvc pressedChooseRecipientButton:self];
            [dvc release];
            break;
        }
        case 1:
        {
            // Load Facebook Contact Send Screen
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"FacebookContacts"];
            
            SendMoneyController* dvc = [[SendMoneyController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            [dvc viewDidLoad]; // Force load of SendMoneyViewController
            
            [dvc pressedChooseRecipientButton:self];
            [dvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:self];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            break;
        }
        case 2:
        {
            // Load Nonprofit Contact Send Screen
            [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) setSelectedContactList: @"NonProfits"];
            
            DoGoodViewController* dvc = [[DoGoodViewController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            [dvc viewDidLoad]; // Force load of SendMoneyViewController
            
            SendDonationViewController* controller = [[SendDonationViewController alloc] init];
            [dvc.navigationController pushViewController:controller animated:YES];
            [controller viewDidLoad];
        
            [controller release];
            [dvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:self];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            
            break;
        }
        default:
        {
            NSDictionary*contact = [appDelegate.quickSendArray objectAtIndex:buttonValue-3];
            
            if ( [[contact valueForKey:@"userType"] intValue] == 0 )
            {
                [self loadQuickSendWithType:0 andContactObject:contact];
            }
            else
            {
                [self loadQuickSendWithType:[[contact valueForKey:@"userType"] intValue] andContactObject:contact];
            }
        }
    }
}

-(void)loadQuickSendWithType:(int)type andContactObject:(NSDictionary*)contact
{
    if ( type == 0 )
    {
        // Normal user (type 0) --> Load SendMoney screen
        SendMoneyController* dvc = [[SendMoneyController alloc] init];
        [[self navigationController] pushViewController:dvc animated:NO];
        [dvc viewDidLoad]; // Force load of SendMoneyViewController
        
        Contact *newContact = [[Contact alloc] init];
        [newContact.paypoints addObject:[contact objectForKey:@"userUri"]];
        
        if ( [contact objectForKey:@"userName"] != (id)[NSNull null] ) {
            newContact.name = [contact objectForKey:@"userName"];
        } else {
            newContact.name = [contact objectForKey:@"userUri"];
        }
        
        
        
        
        if ( [contact objectForKey:@"userImage"] != (id)[NSNull null] && [(NSString*)[contact valueForKey:@"userImage"] length] > 0 )
            newContact.imgData = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contact objectForKey:@"userImage"]]]];
        
        [dvc didChooseContact:newContact];
        [dvc release];
        
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
    }
    else
    {
        // Non-profit/Organization (type > 0) --> Load Donate screen
        DoGoodViewController* dvc = [[DoGoodViewController alloc] init];
        [[self navigationController] pushViewController:dvc animated:NO];
        [dvc viewDidLoad]; // Force load of SendMoneyViewController
        
        SendDonationViewController* controller = [[SendDonationViewController alloc] init];
        [dvc.navigationController pushViewController:controller animated:YES];
        [controller viewDidLoad];
        
        Contact *newContact = [[Contact alloc] init];
        [newContact.paypoints addObject:[contact objectForKey:@"userUri"]];
        newContact.userId = [contact objectForKey:@"userUri"];
        newContact.recipientId = [contact objectForKey:@"userUri"];
        newContact.name = [contact objectForKey:@"userName"];
        
        if ( [contact objectForKey:@"userImage"] != (id)[NSNull null] && [[contact objectForKey:@"userImage"] length] > 0 )
            newContact.imgData = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contact objectForKey:@"userImage"]]]];
        
        [controller didChooseCause:newContact];
        [dvc release];
        [controller release];
        
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
    }
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


@end
