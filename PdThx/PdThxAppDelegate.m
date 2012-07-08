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
#import "Facebook.h"
#import "Contact.h"
#import <AddressBook/AddressBook.h>
#import "PhoneNumberFormatting.h"
#import "ContactSelectViewController.h"
#import "UINavigationBar+CustomImage.h"
#import "GANTracker.h"
#import "myProgressHud.h"
#import "CustomAlertViewController.h"

@implementation PdThxAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController, welcomeTabBarController, newUserFlowTabController;
@synthesize fBook, deviceToken, phoneNumberFormatter, friendRequest, infoRequest,permissions, tempArray, contactsArray, notifAlert, areFacebookContactsLoaded;
@synthesize user, myProgHudOverlay, animationTimer, myProgHudInnerView, customAlert;
@synthesize myApplication;

-(void)switchToMainAreaTabbedView
{
    [self.welcomeTabBarController.view removeFromSuperview];
    //[self.newUserFlowTabController.view removeFromSuperview];
    
    [self.window addSubview:self.tabBarController.view];
    [self.tabBarController setSelectedIndex:0];
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
    [self.window bringSubviewToFront:self.tabBarController.view];
    
    // Keep Progress Bar & Alert Views on top
    if ( myProgHudOverlay.view.superview ){
        [self.window bringSubviewToFront:myProgHudOverlay.view];
        [self.window bringSubviewToFront:myProgHudInnerView.view];
    }
    if ( customAlert.view.superview ){
        [self.window bringSubviewToFront:myProgHudOverlay.view];
        [self.window bringSubviewToFront:customAlert.view];
    }
    
    [self startUserSetupFlow];
}

-(void)startUserSetupFlow
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    bool isNewUser = [prefs boolForKey: @"isNewUser"];
    
    /*          
     TODO: IF USER DOES NOT HAVE SECURITY PIN OR BANK ACCOUNT
     ASK THEM TO ADD IT NOW
     */
    if(currentReminderTab < 1 && (user.mobileNumber == (id)[NSNull null] || [user.mobileNumber length] == 0))
    {
        
        currentReminderTab = 1;  
        
        ActivatePhoneViewController* controller = [[ActivatePhoneViewController alloc] init];
        
        if(setupFlowController == nil) {
            setupFlowController = [[UINavigationController alloc] initWithRootViewController:controller];
            [self.tabBarController presentModalViewController:setupFlowController animated:YES];            
            
        }
        else {
            [setupFlowController pushViewController:controller animated:YES];
        }
       
    }
    else if( ( currentReminderTab < 2 && isNewUser) || (currentReminderTab < 2 && user.firstName == (id)[NSNull null]) || (currentReminderTab < 2 && user.lastName == (id)[NSNull null])) {

        currentReminderTab = 2;  
        
        PersonalizeViewController* controller = [[PersonalizeViewController alloc] init];
        
        if(setupFlowController == nil) {
                        setupFlowController = [[UINavigationController alloc] initWithRootViewController:controller];[self.tabBarController presentModalViewController:setupFlowController animated:YES];            
            
        }
        else {
            [setupFlowController pushViewController:controller animated:YES];
        }

    }
    else if (currentReminderTab < 3 && (user.preferredPaymentAccountId == (id)[NSNull null] || [user.preferredPaymentAccountId length] == 0)  && (user.outstandingPayments.count > 0))
    {
        currentReminderTab = 3;
        
        EnablePaymentsViewController* controller
        = [[EnablePaymentsViewController alloc] init];
        controller.message = [user.outstandingPayments objectAtIndex:0];
        
        if(setupFlowController == nil) {
            setupFlowController = [[UINavigationController alloc] initWithRootViewController:controller];[self.tabBarController presentModalViewController:setupFlowController animated:YES];            
            
        }
        else {
            [setupFlowController pushViewController:controller animated:YES];
        }
        //currentReminderTab = 3;
        //[self.newUserFlowTabController setSelectedIndex:3];
        //[self.window bringSubviewToFront:self.newUserFlowTabController.view];
        // Keep Progress Bar on top
        
        
        [controller release];
    }
    else if(currentReminderTab < 4 && (user.preferredPaymentAccountId == (id)[NSNull null] || [user.preferredPaymentAccountId length] == 0))
    {
        
        
        currentReminderTab = 4;  
        
        AddACHAccountViewController* controller = [[AddACHAccountViewController alloc] init];
        
        if(setupFlowController == nil) {
            setupFlowController = [[UINavigationController alloc] initWithRootViewController:controller];[self.tabBarController presentModalViewController:setupFlowController animated:YES];            
            
        }
        else {
            [setupFlowController pushViewController:controller animated:YES];
        }
        //currentReminderTab = 3;
        //[self.newUserFlowTabController setSelectedIndex:3];
        //[self.window bringSubviewToFront:self.newUserFlowTabController.view];
        // Keep Progress Bar on top

        
        [controller release];
        
    } 
    else {
        currentReminderTab = 5;
        
        if(setupFlowController != nil) {
            [[myProgHudInnerView activityIndicator] stopAnimating];
            
            [prefs setBool:false forKey:@"isNewUser"];
            
            [prefs synchronize];
            
            [self.tabBarController dismissModalViewControllerAnimated:YES];
            
            [setupFlowController release];
            setupFlowController = nil;
            
        }
    }
}
-(void)endUserSetupFlow
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    currentReminderTab = 5;
    
    if(setupFlowController != nil) {
        [[myProgHudInnerView activityIndicator] stopAnimating];
        
        [prefs setBool:false forKey:@"isNewUser"];
        
        [prefs synchronize];
        
        [self.tabBarController dismissModalViewControllerAnimated:YES];
        
        [setupFlowController release];
        setupFlowController = nil;
        
    }
}
-(void)backToWelcomeTabbedArea
{
    [self.tabBarController.view removeFromSuperview];
    
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
    [self.window addSubview:self.welcomeTabBarController.view];
    [self.welcomeTabBarController setSelectedIndex:1];
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    permissions = [[NSArray alloc] initWithObjects:@"email",@"read_friendlists", nil];
    [self.tabBarController setDelegate:self];
    
    Environment *myEnvironment = [Environment sharedInstance];
    
    ApplicationService* applicationService = [[ApplicationService alloc] init];
    [applicationService setApplicationSettingsDidComplete: self];
    [applicationService getApplicationSettings:myEnvironment.pdthxAPIKey];
    
    //NSString *rootUrl = [NSString stringWithString: myEnvironment.pdthxWebServicesBaseUrl];
    NSString *googleAnalyticsKey = [NSString stringWithString: myEnvironment.GoogleAnalyticsKey];
    
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_v1.png"]];
    
    [self.welcomeTabBarController setDelegate:self];
    [self.window addSubview:self.welcomeTabBarController.view];
    [self.welcomeTabBarController setSelectedIndex:0];
    [self.window bringSubviewToFront:welcomeTabBarController.view];
    
    
    // Make the device expect notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert )];
    
    fBook = [[Facebook alloc] initWithAppId:@"332189543469634" andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        fBook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        fBook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    // Create ContactsArray variable with 0-26 indeces (A-Z and Other)
    phoneNumberFormatter = [[PhoneNumberFormatting alloc] init];
    
    contactsArray = [[NSMutableArray alloc] init];
    tempArray = [[NSMutableArray alloc] init];
    
    areFacebookContactsLoaded = NO;
    currentReminderTab = 0;
    
    [self loadAllContacts];
    
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
    [fBook extendAccessTokenIfNeeded];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)signOut {
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
    if ( [fBook isSessionValid] )
        [fBook logout];
    
    areFacebookContactsLoaded = NO;
    currentReminderTab = 0;
    
    // Reload all Contacts (without Facebook permissions)
    [self loadAllContacts];
    
    [prefs synchronize];
    
    [self backToWelcomeTabbedArea];
}

-(void)forgetMe
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"userId"];
    [prefs removeObjectForKey:@"mobileNumber"];
    [prefs removeObjectForKey:@"paymentAccountId"];      
    [prefs removeObjectForKey:@"setupPassword"];
    [prefs removeObjectForKey:@"setupSecurityPin"];
    [prefs removeObjectForKey:@"deviceToken"];
    [prefs removeObjectForKey:@"FBAccessTokenKey"];
    [prefs removeObjectForKey:@"FBExpirationDateKey"];
    
    [prefs synchronize];
}

-(void)switchToSendMoneyController {
    [self.tabBarController setSelectedIndex:1];
}
-(void)switchToRequestMoneyController {
    [self.tabBarController setSelectedIndex:2];
}
-(void)switchToPaystreamController {
    [self.tabBarController setSelectedIndex:3];
}

/*
 -(UIImage*)findImageForContact:(Contact*)contact;
 {
 if ( [contactsArray indexOfObject:contact] )
 return ((Contact*)[contactsArray objectAtIndex:[contactsArray indexOfObject:contact]]).imgData;
 else
 return [UIImage imageWithContentsOfFile:@"avatar_unknown.jpg"];
 }
 */

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
            [self showAlertWithResult:true withTitle:@"New Payment Received" withSubtitle:@"Received payment of $X.XX" withDetailText:@"You just received a payment from ?. You can either dismiss this notification and continue with your current process, or press below to view more details." withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGreen240x78.png" withLeftButtonSelectedImageString:@"smallButtonGreen240x78_a.png" withLeftButtonTitle:@"Details" withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78_a.png" withRightButtonTitle:@"Dismiss" withRightButtonTitleColor:[UIColor darkGrayColor] withDelegate:self];
        } else if ( [userInfo objectForKey:@"nType"] == @"recPRQ" ) { // Payment Requested
            // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
            // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
            // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
            // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
            [self showAlertWithResult:true withTitle:@"New Payment Request" withSubtitle:@"Received payment request for $X.XX" withDetailText:@"You just received a payment request from ?. You can dismiss this and pay it later, or press below to see more details." withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGreen240x78.png" withLeftButtonSelectedImageString:@"smallButtonGreen240x78_a.png" withLeftButtonTitle:@"Details" withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78_a.png" withRightButtonTitle:@"Dismiss" withRightButtonTitleColor:[UIColor darkGrayColor] withDelegate:self];
        }
    } else {
        // Application Just Resumed from Background, so load the notification
        // details pane or the payment processing screen (based on notification)
        if ( [userInfo objectForKey:@"nType"] == @"recPCNF" ) { // Payment Received
            // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
            // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
            // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
            // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
            [self showAlertWithResult:true withTitle:@"New Payment Received" withSubtitle:@"Received payment of $X.XX" withDetailText:@"You just received a payment from ?. You can either dismiss this notification and continue with your current process, or press below to view more details." withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGreen240x78.png" withLeftButtonSelectedImageString:@"smallButtonGreen240x78_a.png" withLeftButtonTitle:@"Details" withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78_a.png" withRightButtonTitle:@"Dismiss" withRightButtonTitleColor:[UIColor darkGrayColor] withDelegate:self];
        } else if ( [userInfo objectForKey:@"nType"] == @"recPRQ" ) { // Payment Requested
            // FOR CUSTOMIZING ALERT VIEW FOR OTHER VIEWS:
            // ButtonOption = 0 -> Button hidden, will not show (other button would be option=1)
            // ButtonOption = 1 -> Only button on screen. It will move it to the middle.
            // ButtonOption = 2 -> One of two buttons on alertView, shows normal location.
            [self showAlertWithResult:true withTitle:@"New Payment Request" withSubtitle:@"Received payment request for $X.XX" withDetailText:@"You just received a payment request from ?. You can dismiss this and pay it later, or press below to see more details." withLeftButtonOption:2 withLeftButtonImageString:@"smallButtonGreen240x78.png" withLeftButtonSelectedImageString:@"smallButtonGreen240x78_a.png" withLeftButtonTitle:@"Details" withLeftButtonTitleColor:[UIColor whiteColor] withRightButtonOption:2 withRightButtonImageString:@"smallButtonGray240x78.png" withRightButtonSelectedImageString:@"smallButtonGray240x78_a.png" withRightButtonTitle:@"Dismiss" withRightButtonTitleColor:[UIColor darkGrayColor] withDelegate:self];
        }
        
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        NSString * jsonString = [writer stringWithObject:userInfo];
        [writer release];
        NSLog ( @"%@" , jsonString );
        
        // Load Paystream Detail View
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:([UIApplication sharedApplication].applicationIconBadgeNumber+1)];
    }
}




-(void)didSelectButtonWithIndex:(int)index
{
    [self dismissAlertView];
    if ( index == 0 ){
        NSLog(@"User wants more details for notification");
        
        
        // TODO: Load Paystream
    } else if ( index == 1 ){
        NSLog(@"User chose to dismiss iOS Push Notification.");
        // Dismiss iOS Push Notification
    } 
}

-(void)loadAllContacts
{
    [tempArray removeAllObjects];
    
    Contact * contact;
    
    if ( [fBook isSessionValid] ){
        friendRequest = [fBook requestWithGraphPath:@"me/friends" andDelegate:self];
    }
    
    // get the address book
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    int index = 0;
    for (int i = 1; i < nPeople; i++) {
        NSLog(@"%@", @"Started Next Person");
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        CFStringRef firstNameRef = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        
        NSString* firstName = [NSString stringWithFormat: @"%@", (NSString*)firstNameRef];
        firstName = [firstName stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        NSLog(@"%@", firstName);
        
        CFStringRef lastNameRef = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        CFStringRef emailAddr = ABRecordCopyValue(ref, kABPersonEmailProperty);
        
        UIImage * tempImgData = nil;
        
        if ( ABPersonHasImageData(ref) ) {
            if ( &ABPersonCopyImageData != nil ){
                tempImgData = [UIImage imageWithData:(NSData *)ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail)];
            } else {
                tempImgData = [UIImage imageWithData:(NSData *)ABPersonCopyImageData(ref)];
            }
        }
        
        ABMultiValueRef multiPhones = ABRecordCopyValue(ref,kABPersonPhoneProperty);
        
    
        
        NSString* lastName = [NSString stringWithFormat: @"%@", (NSString*)lastNameRef];
        lastName = [lastName stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        NSLog(@"%@", lastName);
        
        NSString* emailAddress = [NSString stringWithFormat:@"%@", (NSString*)emailAddr];
        emailAddress = [emailAddress stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        NSLog(@"%@", emailAddress);
        
        NSString *contactFirstLast = @"";
        
        if( [firstName length] > 0 || [lastName length] > 0 ){
            contactFirstLast = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        } else {
            contactFirstLast = @"Unlabeled Contact";
        }
        
        contactFirstLast = [contactFirstLast stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
        
        NSLog(@"%@", contactFirstLast);
        
        // Handles Multiple Phone Numbers for One Contact...
        if ( [(NSString*)firstName length] > 0 || [(NSString*)lastName length] > 0 ){
            for(CFIndex j=0;j<ABMultiValueGetCount(multiPhones);++j) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, j);
                NSString *phoneNumber = (NSString *) phoneNumberRef;
                
                contact = [[Contact alloc] init];
                contact.name = contactFirstLast;
                contact.firstName = (NSString*)firstName;
                contact.lastName = (NSString*)lastName;
                NSLog(@"Phone Number: %@", phoneNumber);
                contact.phoneNumber = [phoneNumberFormatter stringToFormattedPhoneNumber:phoneNumber];
                contact.recipientUri = [contact.phoneNumber copy];
                
                if ( tempImgData != nil ) {
                    NSLog(@"Loading image for %@", contactFirstLast);
                    contact.imgData = tempImgData;
                }
                
                
                [tempArray addObject:contact];
                
                index++;
                
                [contact release];
               
            }
        }
    }
    
    [self sortContacts];
}

-(void) request:(FBRequest *)request didLoad:(id)result
{
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
        friend.recipientUri = [NSString stringWithFormat: @"fb_%@", [dict objectForKey:@"id"]];
        [tempArray addObject:friend];
        [friend release];
    }
    
    areFacebookContactsLoaded = YES;
    
    [self sortContacts];
}

-(void)sortContacts
{
    if ( contactsArray == NULL ){
        contactsArray = [[NSMutableArray alloc] init];
    } else {
        [contactsArray removeAllObjects];
    }
    for ( int i = 0 ; i < 28 ; i ++ )
        [contactsArray addObject:[[NSMutableArray alloc] init]];
    
    tempArray = [[tempArray sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    NSString * comparedString;
    
    /*
     *      Now we need to take the sorted array and split it into sub
     *      arrays for each letter of the alphabet. This is done by:
     *      
     *      ASCII character A = 65. SubArray index = (int)toupper('?')-65
     */
    for (Contact*person in tempArray) {
        if ( person.firstName.length > 0 )
            comparedString = person.firstName;
        else if ( person.lastName.length > 0 )
            comparedString = person.lastName;
        else
            comparedString = person.phoneNumber;
        
        if((((int)toupper([comparedString characterAtIndex:0]))-64) < 28 && (((int)toupper([comparedString characterAtIndex:0]))-64 >= 0))
        {
            [[contactsArray objectAtIndex:((int)toupper([comparedString characterAtIndex:0]))-64] addObject:person];
        }
        else {
            [[contactsArray objectAtIndex:27] addObject:person];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshContactList" object:nil];
    
    NSLog(@"Contacts Ready.");
}

-(void) request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog ( @"Facebook Error occurred -> %@" , [error description] );
}

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [fBook handleOpenURL:url];
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [fBook handleOpenURL:url];
}


-(void)fbDidLogin
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[fBook accessToken] forKey:@"FBAccessTokenKey"];
    [prefs setObject:[fBook expirationDate] forKey:@"FBExpirationDateKey"];
    [prefs synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidLogout {
    // Do your facebook access token and expiration key deletion here.
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"FBAccessTokenKey"];
    [prefs removeObjectForKey:@"FBExpirationDateKey"];
    [prefs synchronize];
}

- (void)fbSessionInvalidated {
    
}
- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [welcomeTabBarController release];
    [fBook release];
    [newUserFlowTabController release];
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
                         
                         [myProgHudOverlay.view removeFromSuperview];
                         [myProgHudOverlay.view removeFromSuperview];
                         
                     }];
}

-(void)showAlertWithResult:(bool)success withTitle:(NSString*)title withSubtitle:(NSString*)subtitle withDetailText:(NSString*)detailedText withLeftButtonOption:(int)leftButtonOption withLeftButtonImageString:(NSString*)leftButtonImageString withLeftButtonSelectedImageString:(NSString*)leftButtonSelectedImageString withLeftButtonTitle:(NSString*)leftButtonTitle withLeftButtonTitleColor:(UIColor*)leftButtonTextColor withRightButtonOption:(int)rightButtonOption withRightButtonImageString:(NSString*)rightButtonImageString withRightButtonSelectedImageString:(NSString*)rightButtonSelectedImageString withRightButtonTitle:(NSString*)rightButtonTitle withRightButtonTitleColor:(UIColor*)rightButtonTextColor withDelegate:(id)alertDelegate
{
    if ( customAlert == nil ) {
        customAlert = [[CustomAlertViewController alloc] init];
        customAlert.view.frame = CGRectMake(self.window.frame.size.width/2-customAlert.view.frame.size.width/2, self.window.frame.size.height/2-customAlert.view.frame.size.height/2, customAlert.view.frame.size.width, customAlert.view.frame.size.height);
        
        customAlert.leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        customAlert.rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    /* RESET THE ALERT VIEW */
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
-(void)getApplicationSettingsDidComplete:(Application*)application {
    myApplication = [application copy];
}
-(void)getApplicationSettingsDidFail: (NSString*) errorMessage
{

}
@end
