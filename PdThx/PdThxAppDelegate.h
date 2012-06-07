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

@class PdThxViewController;

@interface PdThxAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, FBSessionDelegate,FBRequestDelegate> {
    Facebook * fBook;
    NSString * deviceToken;
    NSMutableArray *contactsArray;
    PhoneNumberFormatting *phoneNumberFormatter;
    NSMutableArray *tempArray;
    NSArray * permissions;
    UIAlertView * notifAlert;
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

-(void)signOut;
-(void)forgetMe;
-(void)switchToSendMoneyController;
-(void)switchToRequestMoneyController;
-(void)backToHomeView;
-(void)loadAllContacts;

@end
