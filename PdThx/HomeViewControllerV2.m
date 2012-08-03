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
@synthesize btnSendPhone, btnSendFacebook, btnSendNonprofit, tabBar;
@synthesize quickSendOpened;
@synthesize limitTextLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [btnSendPhone release];
    [btnSendNonprofit release];
    [btnSendFacebook release];
    [userService release];
    
    [quickSendView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (IBAction)qs1pressed:(id)sender {
    [self clickedQuickSend:1];
}

- (IBAction)qs2pressed:(id)sender {
    [self clickedQuickSend:2];
}

- (IBAction)qs3pressed:(id)sender {
    [self clickedQuickSend:3];
}

- (IBAction)qs4pressed:(id)sender {
    [self clickedQuickSend:4];
}

- (IBAction)qs5pressed:(id)sender {
    [self clickedQuickSend:5];
}

- (IBAction)qs6pressed:(id)sender {
    [self clickedQuickSend:6];
}

- (IBAction)qs7pressed:(id)sender {
    [self clickedQuickSend:7];
}

- (IBAction)qs8pressed:(id)sender {
    [self clickedQuickSend:8];
}

- (IBAction)qs9pressed:(id)sender {
    [self clickedQuickSend:9];
}

-(void)clickedQuickSend:(int)buttonValue
{
    buttonValue--;
    // REMEMBER: BUTTON INDEXES START AT 1 (number pad layout)
    // INDEX IN QUICK SEND ARRAY WILL BE BUTTONVALUE-1 (done above)
    
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
        case 3:
        {
            SendMoneyController* dvc = [[SendMoneyController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            [dvc viewDidLoad]; // Force load of SendMoneyViewController
            
            Contact *hugo = [[Contact alloc] init];
            [hugo.paypoints addObject:@"5712438777"];
            hugo.firstName = @"Hugo";
            hugo.lastName = @"Camacho";
            hugo.name = @"Hugo Camacho";
            hugo.imgData = [UIImage imageNamed:@"Hugo.png"];
            [dvc didChooseContact:hugo];
            [dvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:self];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            break;
        }
        case 4:
        {
            SendMoneyController* dvc = [[SendMoneyController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            [dvc viewDidLoad]; // Force load of SendMoneyViewController
            
            Contact *hugo = [[Contact alloc] init];
            [hugo.paypoints addObject:[NSString stringWithString:@"8044323290"]];
            hugo.firstName = @"Rob";
            hugo.lastName = @"Kirchner";
            hugo.name = @"Rob Kirchner";
            hugo.imgData = [UIImage imageNamed:@"ALL.png"];
            [dvc didChooseContact:hugo];
            [dvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:self];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            break;
        }
        case 5:
        {
            SendMoneyController* dvc = [[SendMoneyController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            [dvc viewDidLoad]; // Force load of SendMoneyViewController
            
            Contact *hugo = [[Contact alloc] init];
            [hugo.paypoints addObject:[NSString stringWithString:@"acs@pdthx.me"]];
            hugo.firstName = @"American";
            hugo.lastName = @"Cancer Society";
            hugo.name = @"American Cancer Society";
            hugo.imgData = [UIImage imageNamed:@"org-acs.png"];
            [dvc didChooseContact:hugo];
            [dvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:self];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            break;
        }
        case 6:
        {
            SendMoneyController* dvc = [[SendMoneyController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            [dvc viewDidLoad]; // Force load of SendMoneyViewController
            
            Contact *hugo = [[Contact alloc] init];
            [hugo.paypoints addObject:[NSString stringWithString:@"8043170066"]];
            hugo.firstName = @"Thomas";
            hugo.lastName = @"Eide";
            hugo.name = @"Thomas Eide";
            hugo.imgData = [UIImage imageNamed:@"thomas.png"];
            [dvc didChooseContact:hugo];
            [dvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:self];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            break;
        }
        case 7:
        {
            SendMoneyController* dvc = [[SendMoneyController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            [dvc viewDidLoad]; // Force load of SendMoneyViewController
            
            Contact *hugo = [[Contact alloc] init];
            [hugo.paypoints addObject:[NSString stringWithString:@"8043879693"]];
            hugo.firstName = @"James";
            hugo.lastName = @"Rhodes";
            hugo.name = @"James Rhodes";
            hugo.imgData = [UIImage imageNamed:@"jamesSebastian.png"];
            [dvc didChooseContact:hugo];
            [dvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:self];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            break;
        }
        case 8:
        {
            SendMoneyController* dvc = [[SendMoneyController alloc] init];
            [[self navigationController] pushViewController:dvc animated:NO];
            [dvc viewDidLoad]; // Force load of SendMoneyViewController
            
            Contact *hugo = [[Contact alloc] init];
            [hugo.paypoints addObject:[NSString stringWithString:@"$BSA2012"]];
            hugo.firstName = @"Boy Scouts";
            hugo.lastName = @"of America";
            hugo.name = @"Boy Scouts of America";
            hugo.imgData = [UIImage imageNamed:@"org_bsa.png"];
            [dvc didChooseContact:hugo];
            [dvc release];
            
            //Remove the view controller this is coming from, from the navigation controller stack
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:self];
            
            [[self navigationController] setViewControllers:allViewControllers animated:NO];
            break;
        }
    }
    
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
    [[viewPanel layer] setCornerRadius: 8.0];
    
    [btnUserImage.layer setCornerRadius:6.0];
    [btnUserImage.layer setMasksToBounds:YES];
    
    UIImage *imgProfileActive = [UIImage imageNamed: @"btn-profile-308x70-active.png"];
    [btnProfile setImage: imgProfileActive forState:UIControlStateHighlighted];
    
    [quickSendView addSubview:[[[NSBundle mainBundle] loadNibNamed:@"QuickSendView" owner:self options:nil] objectAtIndex:0]];
    
    [self setTitle: @"Home"];
}

#pragma mark - View lifecycle
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* userId = [prefs stringForKey:@"userId"];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showWithStatus:@"Loading" withDetailedStatus:@"Getting profile"];
    
    [userService getUserInformation:userId];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    lblUserName.text = @"";
    lblScore.text = @"";
    lblPayPoints.text = @"";
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
    }else {
        [btnUserImage setBackgroundImage:[UIImage imageNamed: @"avatar_unknown.jpg"] forState:UIControlStateNormal];
    }
    
    lblUserName.text = user.preferredName;
    if ( [[user.userName substringToIndex:3] isEqualToString:@"fb_"] )
        lblPayPoints.text = @"Facebook User";
    else
        lblPayPoints.text = user.userName;
    
    //lblScore.text = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%d",[user.instantLimit intValue]] attributes:nil];
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
    
    /* Create the attributes (for the attributed string) */
    
    CTFontRef amountFontRef = CTFontCreateWithName((CFStringRef)@"Helvetica-Bold", 35.0, NULL);
    CTFontRef dayFontRef = CTFontCreateWithName((CFStringRef)@"Helvetica-Bold", 10.0, NULL);
    
   
    NSDictionary *amountAttributes = [NSDictionary dictionaryWithObject:
            (id)amountFontRef forKey:(id)kCTFontAttributeName];
    
    NSDictionary *dayAttributes = [NSDictionary dictionaryWithObject:
                                      (id)dayFontRef forKey:(id)kCTFontAttributeName];
    
    /* Create the attributed string (text + attributes) */
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:labelString attributes:amountAttributes];
    
    [attrStr addAttributes:dayAttributes range:NSMakeRange([labelString rangeOfString:@"/"].location, 4)];
    
    CFRelease(amountFontRef);
    CFRelease(dayFontRef);
    
    /* Set the attributes string in the text layer :) */
    limitTextLayer.string = attrStr;
    [attrStr release];
    
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
    
    [numberFormatter release];
}


-(void)userInformationDidFail:(NSString*) message {
    PdThxAppDelegate* appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate dismissProgressHUD];
}
- (void)viewDidUnload
{
    self.tabBar = nil;
    [self setQuickSendView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)swipeUpQuickSend:(id)sender 
{
    if ( ! quickSendOpened ){
        [UIView animateWithDuration:0.4 animations:^{
            quickSendView.frame = CGRectMake(quickSendView.frame.origin.x, quickSendView.frame.origin.y-224, quickSendView.frame.size.width, quickSendView.frame.size.height+224);
        } completion:^(BOOL finished) {
            quickSendOpened = 1;
        }];
    }
}

- (IBAction)swipeDownQuickSend:(id)sender 
{
    if ( quickSendOpened ){
        [UIView animateWithDuration:0.4 animations:^{
            
            quickSendView.frame = CGRectMake(quickSendView.frame.origin.x, quickSendView.frame.origin.y+224, quickSendView.frame.size.width, quickSendView.frame.size.height-224);
        } completion:^(BOOL finished) {
            quickSendOpened = 0;
        }];
    }
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



- (void)tabBarClicked:(NSUInteger)buttonIndex
{
    if( buttonIndex == 0 )
    {
        //This is the home tab already so don't do anything
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
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
    }
    if( buttonIndex == 3 )
    {
        //Switch to the groups tab
        RequestMoneyController *gvc = [[RequestMoneyController alloc]init];
        [[self navigationController] pushViewController:gvc animated:NO];
        [gvc release];
        
        //Remove the view controller this is coming from, from the navigation controller stack
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:self];
        [[self navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
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
