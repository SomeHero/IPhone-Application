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

@implementation PdThxAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController, welcomeTabBarController, newUserFlowTabController;
@synthesize fBook, deviceToken, phoneNumberFormatter, friendRequest, infoRequest,permissions, tempArray, contactsArray, notifAlert, areFacebookContactsLoaded;
@synthesize user, myProgHud;


-(void)switchToMainAreaTabbedView
{
    [self.welcomeTabBarController.view removeFromSuperview];
    [self.newUserFlowTabController.view removeFromSuperview];
    
    [self.window addSubview:self.tabBarController.view];
    [self.tabBarController setSelectedIndex:0];
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
    [self.window bringSubviewToFront:self.tabBarController.view];
    
    // Keep Progress Bar on top
    if ( myProgHud.view.superview )
        [self.window bringSubviewToFront:myProgHud.view];
}

-(void)startUserSetupFlow
{
    [self.welcomeTabBarController.view removeFromSuperview];
    [self.tabBarController.view removeFromSuperview];
    [self.window addSubview:self.newUserFlowTabController.view];
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    bool isNewUser = [prefs boolForKey: @"isNewUser"];
    /*          
     TODO: IF USER DOES NOT HAVE SECURITY PIN OR BANK ACCOUNT
     ASK THEM TO ADD IT NOW
     */
    if(currentReminderTab < 1 && (user.mobileNumber == (id)[NSNull null] || [user.mobileNumber length] == 0))
    {
        currentReminderTab = 1;
        [self.newUserFlowTabController setSelectedIndex:1];
        [self.window bringSubviewToFront:self.newUserFlowTabController.view];
        // Keep Progress Bar on top
        if ( myProgHud.view.superview )
            [self.window bringSubviewToFront:myProgHud.view];
    }
    else if( ( currentReminderTab < 2 && isNewUser) || (currentReminderTab < 2 && user.firstName == (id)[NSNull null]) ) {
        // No bank account, prompt user to add one now.
        currentReminderTab = 2;
        [prefs setValue:NO forKey:@"isNewUser"];
        
        [self.newUserFlowTabController setSelectedIndex:2];
        [self.window bringSubviewToFront:self.newUserFlowTabController.view];
        // Keep Progress Bar on top
        if ( myProgHud.view.superview )
            [self.window bringSubviewToFront:myProgHud.view];
    }
    else if(currentReminderTab < 3 && (user.preferredPaymentAccountId == (id)[NSNull null] || [user.preferredPaymentAccountId length] == 0))
    {
        currentReminderTab = 3;
        [self.newUserFlowTabController setSelectedIndex:3];
        [self.window bringSubviewToFront:self.newUserFlowTabController.view];
        // Keep Progress Bar on top
        if ( myProgHud.view.superview )
            [self.window bringSubviewToFront:myProgHud.view];
        
    }
    else {
        currentReminderTab = 0;
        [self switchToMainAreaTabbedView];
    }

    

}

-(void)backToWelcomeTabbedArea
{
    [self.tabBarController.view removeFromSuperview];
    
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
    [self.window addSubview:self.welcomeTabBarController.view];
    [self.welcomeTabBarController setSelectedIndex:1];
    [self.window bringSubviewToFront:self.welcomeTabBarController.view];
    // Keep Progress Bar on top
    if ( myProgHud.view.superview )
        [self.window bringSubviewToFront:myProgHud.view];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    permissions = [[NSArray alloc] initWithObjects:@"email",@"read_friendlists", nil];
    [self.tabBarController setDelegate:self];

    Environment *myEnvironment = [Environment sharedInstance];
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
    [prefs removeObjectForKey:@"paymentAccountId"];
    
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
            notifAlert = [[UIAlertView alloc] initWithTitle:@"Payment Received" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Details", nil];
            //notifAlert.alertViewStyle = UIAlertViewStyleDefault;
            [notifAlert show];
        } else if ( [userInfo objectForKey:@"nType"] == @"recPRQ" ) { // Payment Requested
            notifAlert = [[UIAlertView alloc] initWithTitle:@"Payment Requested" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Details", nil];
            //notifAlert.alertViewStyle = UIAlertViewStyleDefault;
            [notifAlert show];
        } // Other Cases Not Handled.. May be something wrong..
    } else {
        // Application Just Resumed from Background, so load the notification
        // details pane or the payment processing screen (based on notification)
        notifAlert = [[UIAlertView alloc] initWithTitle:@"Payment Requested" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Details", nil];
        //notifAlert.alertViewStyle = UIAlertViewStyleDefault;
        [notifAlert show];
        
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        NSString * jsonString = [writer stringWithObject:userInfo];
        [writer release];
        NSLog ( @"%@" , jsonString );
        
        // Load Paystream Detail View
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:([UIApplication sharedApplication].applicationIconBadgeNumber+1)];
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
    if ( request == friendRequest )
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
        comparedString = ( person.lastName.length == 0 ? person.firstName : person.lastName );
        
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
    
}

- (void)fbDidLogout {
    // Do your facebook access token and expiration key deletion here.
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
    [[GANTracker sharedTracker] stopTracker];
    [super dealloc];
}


/*      Lets try our OWN progress dialogs...        */
- (void)showWithStatus:(NSString *)status withDetailedStatus:(NSString*)detailedStatus {
    if ( myProgHud == nil ){
        myProgHud = [[myProgressHud alloc] init];
        myProgHud.view.frame = CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height);
    }
    
    myProgHud.topLabel.text = status;
    myProgHud.detailLabel.text = detailedStatus;
    
    myProgHud.imgView.hidden = YES;
    myProgHud.activityIndicator.hidden = NO;
    [[myProgHud activityIndicator] startAnimating];
    
    if ( !myProgHud.view.superview ){
        myProgHud.fadedLayer.alpha = 0.0;
        myProgHud.layerToAnimate.alpha = 0.3;
        [self.window addSubview:myProgHud.view];
        [UIView animateWithDuration:0.2 animations:^{
            myProgHud.fadedLayer.alpha = 0.5;
            myProgHud.layerToAnimate.alpha = 1.0;
        }];
    }
}

- (void)showSuccessWithStatus:(NSString *)status withDetailedStatus:(NSString*)detailedStatus 
{
    if ( myProgHud == nil ){
        myProgHud = [[myProgressHud alloc] init];
        myProgHud.view.frame = CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height);
    }
    
    myProgHud.topLabel.text = status;
    myProgHud.detailLabel.text = detailedStatus;
    
    myProgHud.imgView.image = [UIImage imageNamed:@"loadingPassed62x62.png"];
    myProgHud.imgView.hidden = NO;
    
    [[myProgHud activityIndicator] stopAnimating];
    myProgHud.activityIndicator.hidden = YES;
    
    
    if ( !myProgHud.view.superview ){
        myProgHud.fadedLayer.alpha = 0.0;
        myProgHud.layerToAnimate.alpha = 0.0;
        [self.window addSubview:myProgHud.view];
        [UIView animateWithDuration:0.4 animations:^{
            myProgHud.fadedLayer.alpha = 0.5;
            myProgHud.layerToAnimate.alpha = 1.0;
        }];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissProgressHUD) userInfo:nil repeats:NO];
}


- (void)showErrorWithStatus:(NSString *)status withDetailedStatus:(NSString*)detailedStatus
{
    if ( myProgHud == nil ){
        myProgHud = [[myProgressHud alloc] init];
        myProgHud.view.frame = CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height);
    }
    
    myProgHud.topLabel.text = status;
    myProgHud.detailLabel.text = detailedStatus;
    
    myProgHud.imgView.image = [UIImage imageNamed:@"loadingFailed62x62.png"];
    myProgHud.imgView.hidden = NO;
    
    [[myProgHud activityIndicator] stopAnimating];
    myProgHud.activityIndicator.hidden = YES;
    
    
    if ( !myProgHud.view.superview ){
        myProgHud.fadedLayer.alpha = 0.0;
        myProgHud.layerToAnimate.alpha = 0.3;
        [self.window addSubview:myProgHud.view];
        [UIView animateWithDuration:0.2 animations:^{
            myProgHud.fadedLayer.alpha = 0.5;
            myProgHud.layerToAnimate.alpha = 1.0;
        }];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissProgressHUD) userInfo:nil repeats:NO];
}


-(void)dismissProgressHUD
{
    if ( myProgHud != nil && myProgHud.view.superview ) {
        [myProgHud.view removeFromSuperview];
    }
}


@end
