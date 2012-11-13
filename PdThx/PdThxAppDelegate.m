//
//  PdThxAppDelegate.m
//  PdThx
//
//  Created by James Rhodes on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PdThxAppDelegate.h"
#import "SendMoneyController.h"
#import "SendMoneyRequest.h"
#import "RequestMoneyController.h"
#import "Environment.h"
#import "SBJsonParser.h"
#import "JSON.h"

#import "Contact.h"
#import <AddressBook/AddressBook.h>
#import <FacebookSDK/FacebookSDK.h>

#import "PhoneNumberFormatting.h"
#import "ContactSelectViewController.h"
#import "UINavigationBar+CustomImage.h"
#import "GANTracker.h"
#import "myProgressHud.h"
#import "CustomAlertViewController.h"
#import "HomeViewController.h"
#import "HomeViewControllerV2.h"
#import "WelcomeScreenViewController.h"
#import "AboutPageViewController.h"
#import "AddACHAccountViewController.h"
#import "AddACHOptionsViewController.h"
#import "EnablePaymentsNoMoneyWaitingViewController.h"

@implementation PdThxAppDelegate

@synthesize window=_window;

@synthesize welcomeTabBarController;

@synthesize deviceToken, phoneNumberFormatter, friendRequest, infoRequest,permissions, contactsArray, areFacebookContactsLoaded;
@synthesize user, myProgHudOverlay, animationTimer, myProgHudInnerView, customAlert, setupFlowViewController;

@synthesize myApplication;
@synthesize phoneContacts;
@synthesize faceBookContacts;
@synthesize nonProfits;
@synthesize organizations;
@synthesize securityQuestions;

@synthesize fbAppId;

@synthesize mainAreaTabBarController;
@synthesize selectedContactList;
@synthesize quickSendArray;
@synthesize numberOfFacebookFriends;
@synthesize setupFlowController;

// Static Tab Bar View Controllers..
@synthesize LoggedInCenterViewController, LoggedInFifthViewController, LoggedInFirstViewController, LoggedInFourthViewController, LoggedInSecondViewController;

/*      Temporary New User Flow Booleans    */
@synthesize shownEnablePayments, shownPersonalize, shownPhone;

-(UIViewController*)switchMainAreaToTabIndex:(int)tabIndex fromViewController:(UIViewController*)oldVC
{
    UIViewController * viewToSwitchTo;
    
    if ( tabIndex < 0 && tabIndex > 4 )
        return nil;
    
    switch ( tabIndex )
    {
        case 0:
        {
            viewToSwitchTo = LoggedInFirstViewController;
            
            if ( viewToSwitchTo == nil ){
                LoggedInFirstViewController = [[HomeViewControllerV2 alloc] init];
                viewToSwitchTo = LoggedInFirstViewController;
            }
            
            break;
        }
        case 1:
        {
            viewToSwitchTo = LoggedInSecondViewController;
            
            if ( viewToSwitchTo == nil ){
                LoggedInSecondViewController = [[PayStreamViewController alloc] init];
                viewToSwitchTo = LoggedInSecondViewController;
            }
            
            break;
        }
        case 2:
        {
            viewToSwitchTo = LoggedInCenterViewController;
            
            if ( viewToSwitchTo == nil ){
                LoggedInCenterViewController = [[SendMoneyController alloc] init];
                viewToSwitchTo = LoggedInCenterViewController;
            }
            
            break;
        }
        case 3:
        {
            viewToSwitchTo = LoggedInFourthViewController;
            
            if ( viewToSwitchTo == nil ){
                LoggedInFourthViewController = [[RequestMoneyController alloc] init];
                viewToSwitchTo = LoggedInFourthViewController;
            }
            
            break;
        }
        case 4:
        {
            viewToSwitchTo = LoggedInFifthViewController;
            
            if ( viewToSwitchTo == nil ){
                LoggedInFifthViewController = [[DoGoodViewController alloc] init];
                viewToSwitchTo = LoggedInFifthViewController;
            }
            
            break;
        }
    }
    
    if ( [viewToSwitchTo isKindOfClass:[oldVC class]] )
        return nil;
    else
    {
        // Remove Duplicate of new view if it exists.
        NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:oldVC.navigationController.viewControllers];
        [allViewControllers removeObjectIdenticalTo:viewToSwitchTo];
        [[oldVC navigationController] setViewControllers:allViewControllers animated:NO];
        [allViewControllers release];
        
        return viewToSwitchTo;
    }
}

-(void)switchToMainAreaTabbedView
{
    [self.welcomeTabBarController.view removeFromSuperview];
    //[self.createNewUserController.view removeFromSuperview];
    
    [self.window addSubview:self.mainAreaTabBarController.view];
    [self.window bringSubviewToFront:self.mainAreaTabBarController.view];
    
    // Keep Progress Bar & Alert Views on top
    if ( myProgHudOverlay.view.superview ){
        [self.window bringSubviewToFront:myProgHudOverlay.view];
        [self.window bringSubviewToFront:myProgHudInnerView.view];
    }
    if ( customAlert.view.superview ){
        [self.window bringSubviewToFront:myProgHudOverlay.view];
        [self.window bringSubviewToFront:customAlert.view];
    }
    
    [self startUserSetupFlow:nil];
}

-(void)startUserSetupFlow:(id)caller
{
    if ( caller == nil ) // Setup flow not created, start.
    {
        if ( [self ShouldShowEnablePhoneOption] == true )
        {
            setupFlowViewController = [[UINavigationController alloc] initWithRootViewController:[[ActivatePhoneViewController alloc] init]];
            [mainAreaTabBarController pushViewController:[[setupFlowViewController viewControllers] objectAtIndex:0] animated:NO];
        } else if ( [self ShouldShowPersonalizationOptions] ) {
            setupFlowViewController = [[UINavigationController alloc] initWithRootViewController:[[PersonalizeViewController alloc] init]];
            [mainAreaTabBarController pushViewController:[[setupFlowViewController viewControllers] objectAtIndex:0] animated:NO];
        } else if ( [self ShouldShowBankAccountOptions] ) {
            EnablePaymentsNoMoneyWaitingViewController*enableVC = [[EnablePaymentsNoMoneyWaitingViewController alloc] init];
            setupFlowViewController = [[UINavigationController alloc] initWithRootViewController:enableVC];
            
            [mainAreaTabBarController pushViewController:[[setupFlowViewController viewControllers] objectAtIndex:0] animated:NO];
        } else {
            [mainAreaTabBarController popToRootViewControllerAnimated:YES];
        }
    } else {
        // setupFlowViewController already is shown.
        if ( [self ShouldShowPersonalizationOptions] && [caller isKindOfClass:[ActivatePhoneViewController class]] ) {
            [[caller navigationController] pushViewController:[[PersonalizeViewController alloc] init] animated:NO];
            
            // Get the list of view controllers
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:((UIViewController*)caller).navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:caller];
            [[caller navigationController] setViewControllers:allViewControllers animated:NO];
            [allViewControllers release];
        } else if ( [self ShouldShowBankAccountOptions] && ![caller isKindOfClass:[AddACHAccountViewController class]] && ![caller isKindOfClass:[AddACHOptionsViewController class]] && ![caller isKindOfClass:[EnablePaymentsNoMoneyWaitingViewController class]] ) {
            EnablePaymentsNoMoneyWaitingViewController*enableVC = [[EnablePaymentsNoMoneyWaitingViewController alloc] init];
            [[caller navigationController] pushViewController:enableVC animated:NO];
            
            
            // Get the list of view controllers
            NSMutableArray *allViewControllers = [[NSMutableArray alloc]initWithArray:((UIViewController*)caller).navigationController.viewControllers];
            [allViewControllers removeObjectIdenticalTo:caller];
            [[caller navigationController] setViewControllers:allViewControllers animated:NO];
            [allViewControllers release];
        } else {
            [mainAreaTabBarController popToRootViewControllerAnimated:YES];
        }
    }
}

-(bool)ShouldShowEnablePhoneOption
{
    if ( self.user.mobileNumber == (id)[NSNull null] )
        return true;
    else
        return false;
}

-(bool)ShouldShowPersonalizationOptions
{
    if ( ( self.user.firstName != (id)[NSNull null] && self.user.lastName != (id)[NSNull null] ) )
        return false;
    else
        return true;
}

-(bool)ShouldShowBankAccountOptions
{
    if ( self.user.bankAccounts != (id)[NSNull null] && self.user.bankAccounts.count > 0 )
        return false;
    else
        return true;
}


-(void)endUserSetupFlow
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    currentReminderTab = 5;
    
    if(setupFlowController != nil) {
        [[myProgHudInnerView activityIndicator] stopAnimating];
        
        [prefs setBool:false forKey:@"isNewUser"];
        
        [prefs synchronize];
        
        [mainAreaTabBarController dismissModalViewControllerAnimated:YES];
        
        [setupFlowController release];
        setupFlowController = nil;
        
    }
}

-(void)backToWelcomeTabbedArea
{
    [mainAreaTabBarController.view removeFromSuperview];
    
    [mainAreaTabBarController.navigationController popToRootViewControllerAnimated:NO];
    
    WelcomeScreenViewController *gvc = [[WelcomeScreenViewController alloc]init];
    welcomeTabBarController = [[UINavigationController alloc] initWithRootViewController:gvc];
    [gvc release];
    
    [self.window addSubview:self.welcomeTabBarController.view];
    
    // TODO: Set tab bar tab to 0/1
    
    [self.window bringSubviewToFront:self.welcomeTabBarController.view];
    
    // Keep Progress Bar & Alert Views on top
    if ( myProgHudOverlay.view.superview ){
        [self.window bringSubviewToFront:myProgHudOverlay.view];
        [self.window bringSubviewToFront:myProgHudInnerView.view];
    }
    if ( customAlert.view.superview ){
        [self.window bringSubviewToFront:myProgHudOverlay.view];
        [self.window bringSubviewToFront:customAlert.view];
    }
}

-(void)didSelectButtonWithIndex:(int)index
{
    [self dismissAlertView];
}


#pragma mark - Application LifeCycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    
    //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    //Change the host name here to change the server your monitoring
	//hostReach = [[Reachability reachabilityWithHostName: @"www.google.com"] retain];
	//[hostReach startNotifier];
	//[self updateInterfaceWithReachability: hostReach];
    
    [FBSettings setLoggingBehavior:[NSSet setWithObjects:FBLoggingBehaviorFBRequests, FBLoggingBehaviorFBURLConnections, nil]];
    
    shownEnablePayments = false;
    shownPersonalize = false;
    shownPhone = false;
    
    selectedContactList = @"AllContacts";
    
    // Override point for customization after application launch.
    permissions = [[NSArray alloc] initWithObjects:@"email",@"read_friendlists", nil];
    
    [mainAreaTabBarController setDelegate:self];
    
    myEnvironment = [Environment sharedInstance];
    
    merchantServices = [[MerchantServices alloc] init];
    [merchantServices setMerchantServicesCompleteProtocol: self];
    
    applicationServices = [[ApplicationService alloc] init];
    [applicationServices setApplicationSettingsDidComplete: self];
    
    securityQuestionServices = [[SecurityQuestionService alloc] init];
    [securityQuestionServices setGetSecurityQuestionsDelegate: self];
    
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *googleAnalyticsKey = [NSString stringWithString: myEnvironment.GoogleAnalyticsKey];
    
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v1.png"]];
    
    HomeViewControllerV2 *hvc = [[HomeViewControllerV2 alloc]init];
    mainAreaTabBarController = [[UINavigationController alloc] initWithRootViewController:hvc];
    [hvc release];
    
    [self.welcomeTabBarController setDelegate:self];
    
    WelcomeScreenViewController *gvc = [[WelcomeScreenViewController alloc]init];
    welcomeTabBarController = [[UINavigationController alloc] initWithRootViewController:gvc];
    [gvc release];
    
    [self.window addSubview:self.welcomeTabBarController.view];
    [self.window bringSubviewToFront:welcomeTabBarController.view];
    
    
    // Make the device expect notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert )];
    
    // Create ContactsArray variable with 0-26 indeces (A-Z and Other)
    phoneNumberFormatter = [[PhoneNumberFormatting alloc] init];
    
    contactsArray = [[NSMutableArray alloc] init];
    contactsArray =  [self sortContacts: contactsArray];
    
    phoneContacts = [[NSMutableArray alloc] init];
    phoneContacts = [self sortContacts:phoneContacts];
    phoneContactsSize = 0;
    
    faceBookContacts = [[NSMutableArray alloc] init];
    faceBookContacts = [self sortContacts:faceBookContacts];
    
    nonProfits = [[NSMutableArray alloc] init];
    nonProfits = [self sortContacts:nonProfits];
    
    organizations = [[NSMutableArray alloc] init];
    organizations = [self sortContacts:organizations];
    
    securityQuestions = [[NSMutableArray alloc] init];
    
    areFacebookContactsLoaded = NO;
    currentReminderTab = 0;
    
    [self loadPhoneContacts];
    
    [self loadNonProfits];
    [self loadOrganizations];
    [self loadApplicationSettings];
    [self loadSecurityQuestions];
    
    [self.window makeKeyAndVisible];
    
    [[GANTracker sharedTracker] startTrackerWithAccountID:googleAnalyticsKey
                                           dispatchPeriod:10
                                                 delegate:nil];
    
    NSError *error; 
    if(![[GANTracker sharedTracker] setCustomVariableAtIndex:1
                                                        name:@"iPhone1"
                                                       value:@"iv1"
                                                   withError:&error]){
        //Handle Error Here
    }
    if(![[GANTracker sharedTracker] trackEvent:@"my_category"
                                        action:@"my_action"
                                         label:@"my_label"
                                         value:-1
                                     withError:&error]){
        //Handle Error Here
    }
    if(![[GANTracker sharedTracker] trackPageview:@"app_entry_point"
                                        withError:&error]){
        //Handle Error Here
    }
    
    [FBSession setDefaultAppID:@"332189543469634"];
    
    // Initialize the paystream view controller early...
    LoggedInSecondViewController = [[PayStreamViewController alloc] init];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    for (NSMutableArray * array in contactsArray)
    {
        [array removeAllObjects];
    }
    // I think this is why we keep getting duplicate facebook contacts. We're merging in facebook contacts without first clearing contactArray.
    //[self mergeAllContacts:faceBookContacts];
    
    [self loadPhoneContacts];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface
     */
    
    
    // Bugged FBSDK 3.1.1 functionality
    //[[FBSession activeSession] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    for (NSMutableArray *array in contactsArray)
    {
        [array removeAllObjects];
    }
    
    for (NSMutableArray *array in faceBookContacts)
    {
        [array removeAllObjects];
    }
    
    for (NSMutableArray *array in phoneContacts)
    {
        [array removeAllObjects];
    }
    
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)signOut 
{
    NSLog(@"You Logged Out");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"userId"];
    [prefs removeObjectForKey:@"mobileNumber"];
    [prefs removeObjectForKey:@"paymentAccountId"];      
    [prefs removeObjectForKey:@"setupPassword"];
    [prefs removeObjectForKey:@"setupSecurityPin"];
    [prefs removeObjectForKey:@"deviceToken"];
    [prefs removeObjectForKey:@"facebookId"];
    
    [prefs synchronize];
    
    // Implement Removal of Facebook Contacts from contactArray when they log out of their FACEBOOK-lined account.
    [[FBSession activeSession] closeAndClearTokenInformation];
    
    areFacebookContactsLoaded = NO;
    numberOfFacebookFriends = 0;
    
    currentReminderTab = 0;
    
    for (NSMutableArray* array in faceBookContacts)
    {
        [array removeAllObjects];
    }
    
    for (NSMutableArray* array in contactsArray)
    {
        [array removeAllObjects];
    }
    
    [quickSendArray release];
    quickSendArray = nil;
    
    [LoggedInCenterViewController release];
    LoggedInCenterViewController = nil;
    
    [LoggedInFifthViewController release];
    LoggedInFifthViewController = nil;
    
    [LoggedInFirstViewController release];
    LoggedInFirstViewController = nil;
    
    [LoggedInFourthViewController release];
    LoggedInFourthViewController = nil;
    
    [LoggedInSecondViewController release];
    LoggedInSecondViewController = nil;
    
    // Re-initialize the paystream view controller
    LoggedInSecondViewController = [[PayStreamViewController alloc] init];
    
    [mainAreaTabBarController release];
    
    HomeViewControllerV2 *hvc = [[HomeViewControllerV2 alloc]init];
    mainAreaTabBarController = [[UINavigationController alloc] initWithRootViewController:hvc];
    [hvc release];
    
    // Reload all Contacts (without Facebook permissions)
    [self loadPhoneContacts];
    
    [prefs synchronize];
    
    [self backToWelcomeTabbedArea];
}

/*       Push Notification Handling         */
- (void)application:(UIApplication*)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devicesToken {
    
    NSString *tokenStr = [devicesToken description];
    
    NSString *pushToken = [[[[tokenStr 
                              stringByReplacingOccurrencesOfString:@"<" withString:@""] 
                             stringByReplacingOccurrencesOfString:@">" withString:@""] 
                            stringByReplacingOccurrencesOfString:@" " withString:@""] retain];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setValue:pushToken forKey:@"deviceToken"];
    
    [prefs synchronize];
    
    NSLog(@"Prefs object for token: %@" , [prefs stringForKey:@"deviceToken"]);
    
    NSLog(@"Device token stored as: %@" , devicesToken );
    
    Environment * theEnvironment = [[Environment alloc] init];
    theEnvironment.deviceToken = tokenStr;
    [theEnvironment release];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog( @"Failed to get token, error %@" , error );
}

-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ( application.applicationState == UIApplicationStateActive ){
        // Application was Open when the Notification Arrived. Simply Notify 
        // the user with a AlertView and take them to the payment/details screen
        // based on the notification
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        NSString * jsonString = [writer stringWithObject:userInfo];
        [writer release];
        NSLog ( @"%@" , jsonString );
        
        if ( [userInfo objectForKey:@"nType"] == @"recPCNF" ) { // Payment Received
            // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
            // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
            // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
            // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
            [self showAlertWithResult:true withTitle:@"New Payment Received" withSubtitle:@"Received payment of $X.XX" withDetailText:@"You just received a payment from ?. You can either dismiss this notification and continue with your current process, or press below to view more details." withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGreen240x78.png" withLeftButtonSelectedImageString:@"smallButtonGreen240x78_a.png" withLeftButtonTitle:@"Details" withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78_a.png" withRightButtonTitle:@"Dismiss" withRightButtonTitleColor:[UIColor darkGrayColor] withTextFieldPlaceholderText: @"" withDelegate:self];
        } else if ( [userInfo objectForKey:@"nType"] == @"recPRQ" ) { // Payment Requested
            // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
            // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
            // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
            // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
            [self showAlertWithResult:true withTitle:@"New Payment Request" withSubtitle:@"Received payment request for $X.XX" withDetailText:@"You just received a payment request from ?. You can dismiss this and pay it later, or press below to see more details." withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGreen240x78.png" withLeftButtonSelectedImageString:@"smallButtonGreen240x78_a.png" withLeftButtonTitle:@"Details" withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78_a.png" withRightButtonTitle:@"Dismiss" withRightButtonTitleColor:[UIColor darkGrayColor]  withTextFieldPlaceholderText: @"" withDelegate:self];
        }
    } else {
        // Application Just Resumed from Background, so load the notification
        // details pane or the payment processing screen (based on notification)
        if ( [userInfo objectForKey:@"nType"] == @"recPCNF" ) { // Payment Received
            // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
            // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
            // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
            // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
            [self showAlertWithResult:true withTitle:@"New Payment Received" withSubtitle:@"Received payment of $X.XX" withDetailText:@"You just received a payment from ?. You can either dismiss this notification and continue with your current process, or press below to view more details." withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGreen240x78.png" withLeftButtonSelectedImageString:@"smallButtonGreen240x78_a.png" withLeftButtonTitle:@"Details" withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78_a.png" withRightButtonTitle:@"Dismiss" withRightButtonTitleColor:[UIColor darkGrayColor] withTextFieldPlaceholderText:@"" withDelegate:self];
        } else if ( [userInfo objectForKey:@"nType"] == @"recPRQ" ) { // Payment Requested
            // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
            // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
            // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
            // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
            [self showAlertWithResult:true withTitle:@"New Payment Request" withSubtitle:@"Received payment request for $X.XX" withDetailText:@"You just received a payment request from ?. You can dismiss this and pay it later, or press below to see more details." withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGreen240x78.png" withLeftButtonSelectedImageString:@"smallButtonGreen240x78_a.png" withLeftButtonTitle:@"Details" withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78_a.png" withRightButtonTitle:@"Dismiss" withRightButtonTitleColor:[UIColor darkGrayColor] withTextFieldPlaceholderText:@"" withDelegate:self];
        }
        
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        NSString * jsonString = [writer stringWithObject:userInfo];
        [writer release];
        NSLog ( @"%@" , jsonString );
        
        // Load Paystream Detail View
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[defaults integerForKey:@"PaystreamNotificationCount"]];
    }
}


-(void) loadNonProfits
{
    [merchantServices getNonProfits];
}

-(void) loadOrganizations
{
    [merchantServices getOrganizations];
}

-(void) loadApplicationSettings
{
    [applicationServices getApplicationSettings:myEnvironment.pdthxAPIKey];
}

-(void) loadSecurityQuestions
{
     [securityQuestionServices getSecurityQuestions:NO];
}

#pragma mark - Organizations Delegate
- (void) processOrganizationsList:(id)merchants
{
    [organizations removeAllObjects];
    
    NSMutableArray* tempOrganizations = [[NSMutableArray alloc] init];
    
    for(int i=0; i < [merchants count]; i++)
    {
        Merchant* merchant = [merchants objectAtIndex:i];
        
        Contact* contact = [[Contact alloc] init];
        contact.userId = merchant.merchantId;
        contact.firstName = @"";
        contact.lastName = @"";
        contact.name = merchant.name;
        contact.imgData = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: merchant.imageUrl]]];
        contact.recipientId =  merchant.merchantId;
        contact.merchant = merchant;
        
        if([merchant.merchantListings count] > 0)
            contact.showDetailIcon = true;
        
        [tempOrganizations addObject:contact];
    }
    
    
    tempOrganizations =  [self sortContacts:tempOrganizations];
    
    for(int i = 0; i <[tempOrganizations count]; i++)
    {
        [organizations addObject:[tempOrganizations objectAtIndex:i]];
    }
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          organizations forKey:@"contacts"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrganizationList" object:self userInfo:dict];
}
-(void)getOrganizationsDidComplete:(NSMutableArray*)merchants
{
    /* Operation Queue init (autorelease) */
    NSOperationQueue *queue = [NSOperationQueue new];
    
    /* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(processOrganizationsList:)
                                                                              object:merchants];
    
    /* Add the operation to the queue */
    [queue addOperation:operation];
    [operation release];
}

-(void)getOrganizationsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode
{
    NSLog( @"Failed to get merchants, error %@" , errorMessage );
    
    //[self loadOrganizations];
}

#pragma mark - NonProfits Delegates
- (void) processNonProfitsList:(id)merchants
{
    NSMutableArray* tempOrganizations = [[NSMutableArray alloc] init];
    
    for(int i=0; i < [merchants count]; i++)
    {
        Merchant* merchant = [merchants objectAtIndex:i];
        
        Contact* contact = [[Contact alloc] init];
        contact.userId = merchant.merchantId;
        contact.name = merchant.name;
        contact.imgData = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: merchant.imageUrl]]];
        contact.recipientId =  merchant.merchantId;
        contact.merchant = merchant;
        
        if([merchant.merchantListings count] > 0)
            contact.showDetailIcon = true;
        
        [tempOrganizations addObject:contact];
    }
    
    
    tempOrganizations =  [self sortContacts:tempOrganizations];
    
    for(int i = 0; i <[tempOrganizations count]; i++)
    {
        [nonProfits addObject:[tempOrganizations objectAtIndex:i]];
    }
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          nonProfits forKey:@"contacts"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNonProfitList" object:self userInfo:dict];
}
-(void)getNonProfitsDidComplete:(NSMutableArray*)merchants
{
    [nonProfits removeAllObjects];
    
    /* Operation Queue init (autorelease) */
    NSOperationQueue *queue = [NSOperationQueue new];
    
    /* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(processNonProfitsList:)
                                                                              object:merchants];
    
    /* Add the operation to the queue */
    [queue addOperation:operation];
    [operation release];
}

-(void)getNonProfitsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode {
    NSLog( @"Failed to get merchants, error %@" , errorMessage );
    
    //[self loadNonProfits];
}

-(void)facebookFriendsDidLoad:(id)result
{
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    NSArray *friendArray = [result objectForKey:@"data"];
    NSArray *splitName;
    Contact *friend;
    
    for ( NSDictionary *dict in friendArray ){
        friend = [[Contact alloc] init];
        friend.facebookID = [dict objectForKey:@"id"];
        friend.name = [dict objectForKey:@"name"];
        splitName = [friend.name componentsSeparatedByString:@" "];
        
        friend.firstName = [splitName objectAtIndex:0];
        friend.lastName = [splitName objectAtIndex:([splitName count]-1)];
        
        friend.imgData = NULL;
        [friend.paypoints addObject:[NSString stringWithFormat: @"fb_%@", [dict objectForKey:@"id"]]];
        
        [tempArray addObject:friend];
        
        [friend release];
    }
    
    if ( areFacebookContactsLoaded == YES )
    {
        [contactsArray removeAllObjects];
        
        for ( int i = 0 ; i < 28 ; i ++ )
            [contactsArray addObject:[[NSMutableArray alloc] init]];
        
        [self loadPhoneContacts];
    }
    
    areFacebookContactsLoaded = YES;
    
    [faceBookContacts removeAllObjects];
    
    for ( int i = 0 ; i < 28 ; i ++ )
        [faceBookContacts addObject:[[NSMutableArray alloc] init]];
    
    faceBookContacts = [self sortContacts:tempArray];
    
    numberOfFacebookFriends = [tempArray count];
    
    [self mergeAllContacts:faceBookContacts];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          contactsArray forKey:@"contacts"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshContactList" object:self userInfo:dict];
    
    NSLog(@"Facebook Contacts Added.");
    [self setSelectedContactList:@"AllContacts"];
    
    [tempArray release];
}

-(void)mergeAllContacts:(NSMutableArray*)arrayOfContacts
{
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 28; i++)
    {
        NSMutableArray* subTempArray = [arrayOfContacts objectAtIndex:i];
        
        for(int j = 0; j < [subTempArray count]; j++)
        {
            Contact* contact = [subTempArray objectAtIndex:j];
            
            if ( [tempArray indexOfObject:contact] == NSNotFound )
                [tempArray addObject:contact];
        }
    }
    
    for(int i = 0; i < 28; i++)
    {
        NSMutableArray* subTempArray = [contactsArray objectAtIndex:i];
        
        for(int j = 0; j < [subTempArray count]; j++)
        {
            Contact* contact = [subTempArray objectAtIndex:j];
            
            if ( [tempArray indexOfObject:contact] == NSNotFound )
                [tempArray addObject:contact];
        }
    }
    
    contactsArray = [self sortContacts:tempArray];
    [tempArray release];
}

-(NSMutableArray*)sortContacts:(NSMutableArray*)arrayOfContacts
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    
    for ( int i = 0 ; i < 28 ; i ++)
        [results addObject:[[NSMutableArray alloc] init]];
    
    NSMutableArray* tmpArray = [[arrayOfContacts sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    NSString * comparedString;
    
    /*
     *      Now we need to take the sorted array and split it into sub
     *      arrays for each letter of the alphabet. This is done by:
     *      
     *      ASCII character A = 65. SubArray index = (int)toupper('?')-65
     */
    for (Contact*person in tmpArray)
    {
        if ( person.lastName.length > 0 )
            comparedString = person.lastName;
        else if ( person.firstName.length > 0 )
            comparedString = person.firstName;
        else if(person.name.length > 0)
        {
            if ( [person.name characterAtIndex:0] == '$' )
                comparedString = [person.name substringFromIndex:1];
            else
                comparedString = person.name;
        }
        else
            comparedString = [person.paypoints objectAtIndex:0];
        
        int desiredSection = (((int)toupper([comparedString characterAtIndex:0]))-64);
        
        if(desiredSection < 28 && desiredSection >= 0)
        {
            [[results objectAtIndex:desiredSection] addObject:person];
        }
        else
        {
            [[results objectAtIndex:27] addObject:person];
        }
    }
    
    return results;
}

- (void)dealloc
{
    [_window release];
    [mainAreaTabBarController release];
    [welcomeTabBarController release];
    
    [user release];
    [myProgHudInnerView release];
    [myProgHudOverlay release];
    [customAlert release];
    [[GANTracker sharedTracker] stopTracker];
    [super dealloc];
}


/*      Lets try our OWN progress dialogs...        */
- (void)showWithStatus:(NSString *)status withDetailedStatus:(NSString*)detailedStatus {
    if ( myProgHudOverlay.view.superview == nil ){
        myProgHudOverlay = [[myProgressHud alloc] init];
        myProgHudInnerView = [[ProgressHudInnnerViewController alloc] init];
        
        myProgHudOverlay.view.frame = CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height);
        myProgHudInnerView.view.frame = CGRectMake(self.window.frame.size.width/2-180/2, self.window.frame.size.height/2-180/2, 180, 180);
    }
    
    myProgHudInnerView.topLabel.text = status;
    myProgHudInnerView.detailLabel.text = detailedStatus;
    
    myProgHudInnerView.imgView.hidden = YES;
    myProgHudInnerView.activityIndicator.hidden = NO;
    [[myProgHudInnerView activityIndicator] startAnimating];
    
    
    if ( !myProgHudOverlay.view.superview ){
        myProgHudOverlay.view.alpha = 0.0;
        
        myProgHudInnerView.view.transform = CGAffineTransformScale(self.myProgHudInnerView.view.transform, 1.3, 1.3);
        myProgHudInnerView.view.alpha = 0.0;
        
        [self.window addSubview:myProgHudOverlay.view];
        [self.window addSubview:myProgHudInnerView.view];
        
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             myProgHudInnerView.view.transform = CGAffineTransformScale(self.myProgHudInnerView.view.transform, 1/1.3, 1/1.3);
                             myProgHudInnerView.view.alpha = 1.0;
                             self.myProgHudOverlay.view.alpha = 0.5;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)showSuccessWithStatus:(NSString *)status withDetailedStatus:(NSString*)detailedStatus 
{
    if ( myProgHudOverlay == nil ){
        myProgHudOverlay = [[myProgressHud alloc] init];
        myProgHudOverlay.view.frame = CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height);
        myProgHudInnerView = [[ProgressHudInnnerViewController alloc] init];
        myProgHudInnerView.view.frame = CGRectMake(self.window.frame.size.width/2-180/2, self.window.frame.size.height/2-180/2, 180, 180);
    }
    
    myProgHudInnerView.topLabel.text = status;
    myProgHudInnerView.detailLabel.text = detailedStatus;
    
    myProgHudInnerView.imgView.image = [UIImage imageNamed:@"loadingPassed62x62.png"];
    myProgHudInnerView.imgView.hidden = NO;
    
    [[myProgHudInnerView activityIndicator] stopAnimating];
    myProgHudInnerView.activityIndicator.hidden = YES;
    
    
    if ( !myProgHudOverlay.view.superview ){
        myProgHudOverlay.view.alpha = 0.0;
        
        myProgHudInnerView.view.transform = CGAffineTransformScale(self.myProgHudInnerView.view.transform, 1.3, 1.3);
        myProgHudInnerView.view.alpha = 0.0;
        
        [self.window addSubview:myProgHudOverlay.view];
        [self.window addSubview:myProgHudInnerView.view];
        
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             myProgHudInnerView.view.transform = CGAffineTransformScale(self.myProgHudInnerView.view.transform, 1/1.3, 1/1.3);
                             myProgHudInnerView.view.alpha = 1.0;
                             self.myProgHudOverlay.view.alpha = 0.5;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissProgressHUD) userInfo:nil repeats:NO];
}


- (void)showErrorWithStatus:(NSString *)status withDetailedStatus:(NSString*)detailedStatus 
{
    if ( myProgHudOverlay == nil ){
        myProgHudOverlay = [[myProgressHud alloc] init];
        myProgHudOverlay.view.frame = CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height);
        myProgHudInnerView = [[ProgressHudInnnerViewController alloc] init];
        myProgHudInnerView.view.frame = CGRectMake(self.window.frame.size.width/2-180/2, self.window.frame.size.height/2-180/2, 180, 180);
    }
    
    myProgHudInnerView.topLabel.text = status;
    myProgHudInnerView.detailLabel.text = detailedStatus;
    
    myProgHudInnerView.imgView.image = [UIImage imageNamed:@"loadingFailed62x62.png"];
    myProgHudInnerView.imgView.hidden = NO;
    
    [[myProgHudInnerView activityIndicator] stopAnimating];
    myProgHudInnerView.activityIndicator.hidden = YES;
    
    
    if ( !myProgHudOverlay.view.superview ){
        myProgHudOverlay.view.alpha = 0.0;
        
        myProgHudInnerView.view.transform = CGAffineTransformScale(self.myProgHudInnerView.view.transform, 1.3, 1.3);
        myProgHudInnerView.view.alpha = 0.0;
        
        [self.window addSubview:myProgHudOverlay.view];
        [self.window addSubview:myProgHudInnerView.view];
        
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             myProgHudInnerView.view.transform = CGAffineTransformScale(self.myProgHudInnerView.view.transform, 1/1.3, 1/1.3);
                             myProgHudInnerView.view.alpha = 1.0;
                             
                             self.myProgHudOverlay.view.alpha = 0.5;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissProgressHUD) userInfo:nil repeats:NO];
}

-(void)dismissProgressHUD
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         myProgHudInnerView.view.transform = CGAffineTransformScale(self.myProgHudInnerView.view.transform, 1.3, 1.3);
                         myProgHudInnerView.view.alpha = 0.0;
                         self.myProgHudOverlay.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         myProgHudInnerView.view.transform = CGAffineTransformScale(self.myProgHudInnerView.view.transform, 1/1.3, 1/1.3);
                         [myProgHudOverlay.view removeFromSuperview];
                         [myProgHudOverlay.view removeFromSuperview];
                         
                     }];
}

-(void) showTextFieldAlertView:(bool)status withTitle:(NSString*)headerText withSubtitle:(NSString*)subTitle withDetailedText:(NSString*)detailText withButtonText:(NSString*)buttonText withTextFieldPlaceholderText:(NSString*)placeholderText withDelegate:(id)delegate
{
    [self showAlertWithResult:status withTitle:headerText withSubtitle:subTitle withDetailText:detailText withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:buttonText withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"im useless" withRightButtonTitleColor:[UIColor whiteColor] withTextFieldPlaceholderText:placeholderText withDelegate:delegate];
}

-(void) showSimpleAlertView:(bool)status withTitle:(NSString*)headerText withSubtitle:(NSString*)subTitle withDetailedText:(NSString*)detailText withButtonText:(NSString*)buttonText withDelegate:(id)delegate
{
    [self dismissProgressHUD];
    [self showAlertWithResult:status withTitle:headerText withSubtitle:subTitle withDetailText:detailText withLeftButtonOption:1 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:buttonText withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:0 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:@"im useless" withRightButtonTitleColor:[UIColor whiteColor] withTextFieldPlaceholderText:@"" withDelegate:delegate];
}

-(void) showTwoButtonAlertView:(bool)status withTitle:(NSString*)headerText withSubtitle:(NSString*)subTitle withDetailedText:(NSString*)detailText withButton1Text:(NSString*)button1Text withButton2Text:(NSString*)button2Text withDelegate:(id<CustomAlertViewProtocol>) delegate
{
    [self showAlertWithResult:status withTitle:headerText withSubtitle:subTitle withDetailText:detailText withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGray240x78.png" withLeftButtonSelectedImageString:@"smallButtonGray240x78.png" withLeftButtonTitle:button1Text withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78.png" withRightButtonTitle:button2Text withRightButtonTitleColor:[UIColor whiteColor] withTextFieldPlaceholderText:@"" withDelegate:delegate];
}

-(void)showAlertWithResult:(bool)success withTitle:(NSString*)title withSubtitle:(NSString*)subtitle withDetailText:(NSString*)detailedText withLeftButtonOption:(int)leftButtonOption withLeftButtonImageString:(NSString*)leftButtonImageString withLeftButtonSelectedImageString:(NSString*)leftButtonSelectedImageString withLeftButtonTitle:(NSString*)leftButtonTitle withLeftButtonTitleColor:(UIColor*)leftButtonTextColor withRightButtonOption:(int)rightButtonOption withRightButtonImageString:(NSString*)rightButtonImageString withRightButtonSelectedImageString:(NSString*)rightButtonSelectedImageString withRightButtonTitle:(NSString*)rightButtonTitle withRightButtonTitleColor:(UIColor*)rightButtonTextColor withTextFieldPlaceholderText:(NSString*)placeholderText withDelegate:(id)alertDelegate
{
    if ( customAlert == nil ) {
        customAlert = [[CustomAlertViewController alloc] init];
        customAlert.view.frame = CGRectMake(self.window.frame.size.width/2-customAlert.view.frame.size.width/2, self.window.frame.size.height/2-customAlert.view.frame.size.height/2, customAlert.view.frame.size.width, customAlert.view.frame.size.height);
        
        customAlert.leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        customAlert.rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    
    /* RESET THE ALERT VIEW */
    customAlert.view.frame = CGRectMake(self.window.frame.size.width/2-customAlert.view.frame.size.width/2, self.window.frame.size.height/2-customAlert.view.frame.size.height/2, customAlert.view.frame.size.width, customAlert.view.frame.size.height);
    
    customAlert.leftButton.hidden = NO;
    customAlert.leftButton.titleLabel.text = @"Default";
    customAlert.rightButton.hidden = NO;
    customAlert.rightButton.titleLabel.text = @"Default";
    
    customAlert.resultImageView.image = [UIImage imageNamed:@"paidthx-icon.png"];
    customAlert.topTitleLabel.text = @"This is a title, okay?";
    customAlert.subTitleLabel.text = @"This is a subtitle, okay?";
    customAlert.detailedTextView.text = @"There's some text in this field.. nobody will ever see this... sooo.... whats up?";
    /* END RESET ALERT VIEW */
    
    // Set button clicked delegate.
    customAlert.alertViewDelegate = alertDelegate;
    
    if ( placeholderText && placeholderText.length > 0 )
    {
        customAlert.txtField.hidden = NO;
        customAlert.txtField.placeholder = placeholderText;
    } else {
        customAlert.txtField.hidden = YES;
    }
    
    // Customize the Alert View
    if ( success )
        customAlert.resultImageView.image = [UIImage imageNamed:@"loadingPassed62x62.png"];
    else
        customAlert.resultImageView.image = [UIImage imageNamed:@"loadingFailed62x62.png"];
    
    customAlert.topTitleLabel.text = title;
    customAlert.subTitleLabel.text = subtitle;
    customAlert.detailedTextView.text = detailedText;
    
    // LEFT BUTTON
    if ( leftButtonOption == 0 ){
        // Button Type 0 will be NO BUTTONS on alert view
        customAlert.leftButton.hidden = YES;
    } else if ( leftButtonOption == 1 ){
        // Button Option 1 will always be that it is the only button shown
        // meaning we will have to move it to the center of the view, alike normal
        // alert views.
        customAlert.leftButton.frame = CGRectMake(customAlert.view.frame.size.width/2-120/2, customAlert.view.frame.size
                                                  .height-59, 120, 39);
    } else if ( leftButtonOption == 2 ){
        // Button Option 2 will always be that it is in it's normal location
        // for two buttons on the alert view. Evenly split, 20 pixels from the bottom of the view, 20 pixels from the left (for left button)
        customAlert.leftButton.frame = CGRectMake(20, customAlert.view.frame.size
                                                  .height-59, 120, 39);
    }
    
    [customAlert.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
    [customAlert.leftButton setTitle:leftButtonTitle forState:UIControlStateHighlighted];
    
    [customAlert.leftButton setTitleColor:leftButtonTextColor forState:UIControlStateNormal];
    [customAlert.leftButton setTitleColor:leftButtonTextColor forState:UIControlStateHighlighted];
    
    [customAlert.leftButton setBackgroundImage:[UIImage imageNamed:leftButtonImageString ] forState:UIControlStateNormal];
    [customAlert.leftButton setBackgroundImage:[UIImage imageNamed:leftButtonSelectedImageString] forState:UIControlStateHighlighted];
    
    // RIGHT BUTTON
    
    if ( rightButtonOption == 0 ){
        // Button Type 0 will be NO BUTTONS on alert view
        customAlert.rightButton.hidden = YES;
    } else if ( rightButtonOption == 1 ){
        // Button Option 1 will always be that it is the only button shown
        // meaning we will have to move it to the center of the view, alike normal
        // alert views.
        customAlert.rightButton.frame = CGRectMake(customAlert.view.frame.size.width/2+120/2, customAlert.view.frame.size
                                                   .height-59, 120, 39);
    } else if ( rightButtonOption == 2 ){
        // Button Option 2 will always be that it is in it's normal location
        // for two buttons on the alert view. Evenly split, 20 pixels from the bottom of the view, 20 pixels from the left (for left button)
        customAlert.rightButton.frame = CGRectMake(160, customAlert.view.frame.size
                                                   .height-59, 120, 39);
    }
    
    [customAlert.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    [customAlert.rightButton setTitle:rightButtonTitle forState:UIControlStateHighlighted];
    [customAlert.rightButton setTitleColor:rightButtonTextColor forState:UIControlStateNormal];
    [customAlert.rightButton setTitleColor:rightButtonTextColor forState:UIControlStateHighlighted];
    
    [customAlert.rightButton setBackgroundImage:[UIImage imageNamed:rightButtonImageString ] forState:UIControlStateNormal];
    [customAlert.rightButton setBackgroundImage:[UIImage imageNamed:rightButtonSelectedImageString] forState:UIControlStateHighlighted];
    
    
    
    if ( !customAlert.view.superview ){
        myProgHudOverlay.view.alpha = 0.0;
        customAlert.view.transform = CGAffineTransformScale(self.customAlert.view.transform, 1/1.3, 1/1.3);
        customAlert.view.alpha = 0.0;
        
        [self.window addSubview:myProgHudOverlay.view];
        [self.window addSubview:customAlert.view];
        
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             customAlert.view.transform = CGAffineTransformScale(self.customAlert.view.transform, 1.3, 1.3);
                             customAlert.view.alpha = 1.0;
                             myProgHudOverlay.view.alpha = 0.5;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

-(void)dismissAlertView
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         customAlert.view.transform = CGAffineTransformScale(self.customAlert.view.transform, 1/1.3, 1/1.3);
                         
                         // Fade Out
                         customAlert.view.alpha = 0.0;
                         myProgHudOverlay.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [myProgHudOverlay.view removeFromSuperview];
                         [customAlert.view removeFromSuperview];
                         customAlert.view.transform = CGAffineTransformScale(self.customAlert.view.transform, 1.3, 1.3);
                     }];
}
#pragma mark - ApplicationSettings Delegate
-(void)getApplicationSettingsDidComplete:(Application*)application {
    myApplication = [application copy];
}

-(void)getApplicationSettingsDidFail:(NSString*)errorMessage withErrorCode:(int)errorCode
{
    NSLog( @"Failed to get application settings, error %@ code %d" , errorMessage, errorCode);
    
    //[self loadApplicationSettings];
}
#pragma mark - SecurityQuestions Delegate
-(void)getSecurityQuestionsDidComplete:(NSMutableArray*)questionArray {
    securityQuestions = questionArray;
}
-(void)getSecurityQuestionsDidFail:(NSString*)message withErrorCode:(int) errorCode {
    [self loadSecurityQuestions];
}

-(NSString*)getSelectedContactListImage
{
    if([selectedContactList isEqualToString: @"AllContacts"])
        return @"nav-selector-allcontacts-52x30.png";
    if([selectedContactList isEqualToString: @"PhoneContacts"])
        return @"nav-selector-phonecontacts-52x30.png";
    if([selectedContactList isEqualToString: @"FacebookContacts"])
        return @"nav-selector-fbcontacts-52x30.png";
    if([selectedContactList isEqualToString: @"NonProfits"])
        return @"nav-selector-cause-52x30.png";
    if([selectedContactList isEqualToString: @"Organizations"])
        return @"nav-selector-public-52x30.png";
    
    return @"nav-selector-allcontacts-52x30.png";
}

-(double)getUpperLimit {
    
    double upperLimit = 5000.0;
    
    NSLog(@"%@", [NSString stringWithFormat: @"%@", [[myApplication applicationSettings] objectForKey:@"UpperLimit"]]);
    @try {
        upperLimit = (double)[[[[myApplication applicationSettings] objectForKey:@"UpperLimit"] ConfigurationValue] doubleValue];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[NSString stringWithFormat:@"%@",exception]);
    }
    @finally {
    }
    
    return upperLimit;
}

-(void)linkedFacebookFriendsDidLoad:(id)friendsList
{
    [self facebookFriendsDidLoad:friendsList];
}
#pragma mark - Global Handlers
-(void)handleError: (NSString*)errorMessage withErrorCode: (int) errorCode withDefaultTitle: (NSString*) defaultTitle
{
    if(errorCode == 1001)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:  @"Account Locked"
                                                            message: errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        [alertView release];
        
        [self signOut];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: defaultTitle
                                                            message: errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
        [alertView release];
    }
}


/*      ----------------        ------------------
            Contact Loading and Sorting
 *      ----------------        ------------------ */

-(void)loadPhoneContacts
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    NSLog(@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]);
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 )
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if ( granted )
                                                     {
                                                         NSLog(@"iOS version > 6.0, granted access.");
                                                     } else {
                                                         NSLog(@"iOS version > 6.0, DENIED access.");
                                                     }
                                                 });
    }
    
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    
    Contact * contact;
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    phoneContactsSize = ABAddressBookGetPersonCount(addressBook);
    
    for (int i = 0; i < phoneContactsSize; i++)
    {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef firstNameRef = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        
        NSString* firstName = [NSString stringWithFormat: @"%@", (NSString*)firstNameRef];
        firstName = [firstName stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        CFStringRef lastNameRef = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        
        UIImage * tempImgData = nil;
        
        if ( ABPersonHasImageData(ref) ) {
            if ( &ABPersonCopyImageData != nil ){
                tempImgData = [UIImage imageWithData:(NSData *)ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail)];
            } else {
                tempImgData = [UIImage imageWithData:(NSData *)ABPersonCopyImageData(ref)];
            }
        }
        
        ABMultiValueRef multiPhones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        
        ABMultiValueRef multiEmails = ABRecordCopyValue(ref, kABPersonEmailProperty);
        
        NSString* lastName = [NSString stringWithFormat: @"%@", (NSString*)lastNameRef];
        lastName = [lastName stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        NSString *contactFirstLast = @"";
        
        if( [firstName length] > 0 || [lastName length] > 0 ){
            contactFirstLast = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        } else {
            continue; //Contact is an organization or non-labeled contact
        }
        
        contactFirstLast = [contactFirstLast stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
        
        contact = [[Contact alloc] init];
        contact.name = contactFirstLast;
        contact.firstName = (NSString*)firstName;
        contact.lastName = (NSString*)lastName;
        if ( tempImgData != nil ) {
            contact.imgData = tempImgData;
        }
        
        NSMutableArray* paypoints = [[NSMutableArray alloc] init];
        
        // Handles Multiple Phone Numbers for One Contact...
        if ( [(NSString*)firstName length] > 0 || [(NSString*)lastName length] > 0 ){
            for(CFIndex j=0;j<ABMultiValueGetCount(multiPhones);++j) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, j);
                NSString *phoneNumber = (NSString *) phoneNumberRef;
                
                NSString* formattedNumber = [phoneNumberFormatter stringToFormattedPhoneNumber:phoneNumber];
                
                if (![paypoints containsObject:formattedNumber])
                {
                    [paypoints addObject: formattedNumber];
                }
                
            }
            
            for (CFIndex k = 0; k < ABMultiValueGetCount(multiEmails); ++k)
            {
                CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multiEmails, k);
                NSString *emailAddress = (NSString*) emailRef;
                
                if (![paypoints containsObject:emailAddress] && [emailAddress rangeOfString:@"@facebook.com"].location == NSNotFound )
                {
                    [paypoints addObject:emailAddress];
                }
            }
        }
        
        contact.paypoints = paypoints;
        
        if ( [paypoints count] > 0 )
            [tempArray addObject:contact];
        
        [contact release];
    }
    
    NSMutableArray* tempPhoneContacts = [self sortContacts: tempArray];
    
    [phoneContacts removeAllObjects];
    
    for(int i = 0; i <[tempPhoneContacts count]; i++)
    {
        [phoneContacts addObject:[tempPhoneContacts objectAtIndex:i]];
    }
    
    [self mergeAllContacts: phoneContacts];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          contactsArray forKey:@"contacts"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshContactList" object:self userInfo:dict];
    
    NSLog(@"Contacts Ready.");
    [tempArray release];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

@end
