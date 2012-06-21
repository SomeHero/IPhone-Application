//
//  PdThxAppDelegate.h
//  PdThx
//
//  Created by James Rhodes on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "PhoneNumberFormatting.h"
#import "User.h"
#import "GANTracker.h"
#import "Environment.h"
@class PdThxViewController;

@interface PdThxAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, FBSessionDelegate,FBRequestDelegate> {
    Facebook * fBook;
    NSString * deviceToken;
    NSMutableArray *contactsArray;
    PhoneNumberFormatting *phoneNumberFormatter;
    NSMutableArray *tempArray;
    NSArray * permissions;
    UIAlertView * notifAlert;
    IBOutlet UITabBarController *welcomeTabBarController;
    IBOutlet UITabBarController *newUserFlowTabController;
    FBRequest *friendRequest;
    FBRequest *infoRequest;
    User* user;
    NSInteger currentReminderTab;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) Facebook * fBook;
@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) PhoneNumberFormatting *phoneNumberFormatter;
@property (nonatomic, retain) NSMutableArray *tempArray;
@property (nonatomic, retain) NSArray * permissions;
@property (nonatomic, retain) UIAlertView * notifAlert;
@property (nonatomic, assign) bool areFacebookContactsLoaded;
@property (nonatomic, retain) UITabBarController *welcomeTabBarController;
@property (nonatomic, retain) UITabBarController *newUserFlowTabController;
@property (nonatomic, retain) FBRequest *friendRequest;
@property (nonatomic, retain) FBRequest *infoRequest;
@property(nonatomic, retain) User* user;

-(void)signOut;
-(void)forgetMe;
-(void)switchToSendMoneyController;
-(void)switchToRequestMoneyController;
-(void)switchToPaystreamController;
-(void)backToHomeView;
-(void)loadAllContacts;

-(void)switchToMainAreaTabbedView;
-(void)backToWelcomeTabbedArea;
-(void)startUserSetupFlow;

@end
