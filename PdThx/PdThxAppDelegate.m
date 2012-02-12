//
//  PdThxAppDelegate.m
//  PdThx
//
//  Created by James Rhodes on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PdThxAppDelegate.h"

#import "WelcomeController.h"
#import "SignupViewController.h"
#import "VerificationMobileDevice.h"
#import "SendMoneyController.h"
#import "SendMoneyRequest.h"

@implementation PdThxAppDelegate

@synthesize window=_window;
@synthesize welcomeController = _welcomeController;
@synthesize tabBarController=_tabBarController;
@synthesize registerNavigationController = _registerNavigationController;
@synthesize setupPasswordController = _setupPasswordController;
@synthesize signInViewController = _signInViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //[prefs removeObjectForKey:@"userId"];
    //[prefs removeObjectForKey:@"mobileNumber"];
    //[prefs removeObjectForKey:@"paymentAccountId"];      
    //[prefs removeObjectForKey:@"setupPassword"];
    //[prefs removeObjectForKey:@"setupSecurityPin"];
    
    NSString* mobileNumber = [prefs stringForKey:@"mobileNumber"];;
    NSString* userId = [prefs stringForKey:@"userId"];
    
    if([mobileNumber length] == 0) {
        [self.window addSubview:self.welcomeController.view];
    } else if([userId length] == 0) {
        [self.window addSubview:self.signInViewController.view];
    } else {
        [self switchToMainController];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)switchToMainController {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];

    [self.window removeFromSuperview];
    
    [self.window addSubview:self.tabBarController.view];

    [self.window makeKeyAndVisible];
    UINavigationController   *navController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    SendMoneyController* controller = [[navController viewControllers] objectAtIndex:0];
    
    [UIView commitAnimations];
    
}
-(void)switchToConfirmation {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
    
    [self.window removeFromSuperview];
    
    [self.window addSubview:self.tabBarController.view];
    
    [self.window makeKeyAndVisible];
    UINavigationController   *navController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    SendMoneyController* controller =     [[navController viewControllers] objectAtIndex:0];
    
    [controller setRecipientUri: [[SendMoneyRequest sendMoneyRequest] recipientUri]];
    [controller setAmount: [[SendMoneyRequest sendMoneyRequest] amount]];
    [controller setComments:[[SendMoneyRequest sendMoneyRequest] comments]];
    [controller setShowConfirmation: YES];
    
    [controller viewDidAppear:YES];
    
    [UIView commitAnimations];
}
- (void)switchToSetPasswordController {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
    
    [self.window removeFromSuperview];
    
    [self.setupPasswordController viewDidAppear:YES];
    [self.window addSubview:self.setupPasswordController.view];
    
    [self.window makeKeyAndVisible];
    [UIView commitAnimations];
}
-(void)switchToWelcomeController {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
    
    [self.window removeFromSuperview];
    
    [self.welcomeController viewDidAppear:YES];
    [self.window addSubview:self.welcomeController.view];
    
    [self.window makeKeyAndVisible];
    [UIView commitAnimations];
}
-(void)switchToSignInController {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
    
    [self.window removeFromSuperview];
    
    [self.signInViewController viewDidAppear:YES];
    [self.window addSubview:self.signInViewController.view];

    [self.window makeKeyAndVisible];
    [UIView commitAnimations];
}
-(void)switchToRegisterController {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
    
    [self.window removeFromSuperview];
    
    [self.window addSubview:self.registerNavigationController.view];
    
    [self.window makeKeyAndVisible];
    [UIView commitAnimations];
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
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
-(void)setRecipientUri: (NSString*) recipientUri {
    _recipientUri = recipientUri;
}
-(void)setAmount: (NSString*) amount {
    _amount = amount;
}
-(void)setComments: (NSString*) comments {
    _comments = comments;
}
-(void)signOut {
    NSLog(@"You Logged Out");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"userId"];
    //[prefs removeObjectForKey:@"mobileNumber"];
    [prefs removeObjectForKey:@"paymentAccountId"];
    [prefs removeObjectForKey:@"setupPassword"];
    [prefs removeObjectForKey:@"setupSecurityPin"];
    
    [prefs synchronize];
    
    [[SendMoneyRequest sendMoneyRequest] reset];
    
    [self.signInViewController viewDidAppear:YES];
    
    [self switchToSignInController];
}
-(void)forgetMe
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"userId"];
    [prefs removeObjectForKey:@"mobileNumber"];
    [prefs removeObjectForKey:@"paymentAccountId"];      
    [prefs removeObjectForKey:@"setupPassword"];
    [prefs removeObjectForKey:@"setupSecurityPin"];
    
    [prefs synchronize];
    
    [[SendMoneyRequest sendMoneyRequest] reset];
    
    [self switchToWelcomeController];
}
- (void)dealloc
{
    [_window release];
    [_welcomeController release];
    [_signInViewController release];
    [_tabBarController release];
    [_registerNavigationController release];
    [_setupPasswordController release];
    [_signInViewController release];
    
    [[SendMoneyRequest sendMoneyRequest] release];
    
    [super dealloc];
}
@end
