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
#import "myProgressHud.h"
#import "ProgressHudInnnerViewController.h"
#import "CustomAlertViewController.h"
#import "CustomAlertViewProtocol.h"
#import "ActivatePhoneViewController.h"
#import "PersonalizeViewController.h"
#import "AddACHAccountViewController.h"
#import "SetupFlowViewController.h"
#import "EnablePaymentsViewController.h"
#import "Application.h"
#import "ApplicationService.h"
#import "ApplicationSettingsCompleteProtocol.h"
#import "Merchant.h"
#import "MerchantServices.h"

@class PdThxViewController;

@interface PdThxAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, ApplicationSettingsCompleteProtocol, FBSessionDelegate, FBRequestDelegate, UINavigationControllerDelegate> {
    Facebook * fBook;
    NSString * deviceToken;
    PhoneNumberFormatting *phoneNumberFormatter;
    NSArray * permissions;
    UIAlertView * notifAlert;
    IBOutlet UITabBarController *welcomeTabBarController;
    IBOutlet UITabBarController *newUserFlowTabController;
    FBRequest *friendRequest;
    FBRequest *infoRequest;
    User* user;
    NSInteger currentReminderTab;
    myProgressHud *myProgHudOverlay;
    ProgressHudInnnerViewController *myProgHudInnerView;
    CustomAlertViewController *customAlert;
    UINavigationController* setupFlowController;
    Application* myApplication;
    
    MerchantServices* merchantServices;
    NSString* selectedContactList;
    
    NSMutableArray *contactsArray;
    NSMutableArray* phoneContacts;
    NSMutableArray* faceBookContacts;
    NSMutableArray* nonProfits;
    NSMutableArray* organizations;
    
    NSString * fbAppId;
    
    UINavigationController * mainAreaTabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) Facebook * fBook;
@property (nonatomic, retain) NSString * deviceToken;@property (nonatomic, retain) PhoneNumberFormatting *phoneNumberFormatter;
@property (nonatomic, retain) NSArray * permissions;
@property (nonatomic, retain) UIAlertView * notifAlert;
@property (nonatomic, assign) bool areFacebookContactsLoaded;
@property (nonatomic, retain) UITabBarController *welcomeTabBarController;
@property (nonatomic, retain) UITabBarController *newUserFlowTabController;
@property (nonatomic, retain) FBRequest *friendRequest;
@property (nonatomic, retain) FBRequest *infoRequest;
@property(nonatomic, retain) User* user;
@property (nonatomic, retain) myProgressHud *myProgHudOverlay;
@property (nonatomic, retain) ProgressHudInnnerViewController *myProgHudInnerView;
@property (nonatomic, retain) CustomAlertViewController *customAlert;

@property (nonatomic, retain) UINavigationController* setupFlowController;

@property(nonatomic, retain) UINavigationController * mainAreaTabBarController;
@property (nonatomic, assign) int animationTimer;


@property(nonatomic, retain) Application* myApplication;


@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) NSMutableArray *phoneContacts;
@property (nonatomic, retain) NSMutableArray *faceBookContacts;
@property(nonatomic, retain) NSMutableArray* nonProfits;
@property(nonatomic, retain) NSMutableArray* organizations;

@property(nonatomic, retain) NSString * fbAppId;

@property(nonatomic, retain) NSString* selectedContactList;

-(void)signOut;
-(void)forgetMe;
-(void)switchToSendMoneyController;
-(void)switchToRequestMoneyController;
-(void)switchToPaystreamController;
-(void)loadAllContacts;

-(void)switchToMainAreaTabbedView;
-(void)backToWelcomeTabbedArea;
-(void)startUserSetupFlow;
-(void)endUserSetupFlow;

- (void)showWithStatus:(NSString *)status withDetailedStatus:(NSString*)detailedStatus;
- (void)showSuccessWithStatus:(NSString *)string withDetailedStatus:(NSString*)detailStatus;
- (void)showErrorWithStatus:(NSString *)string withDetailedStatus:(NSString*)detailStatus;

- (void)dismissProgressHUD;
- (void)dismissAlertView;

-(NSString*)getSelectedContactListImage;

-(void)showAlertWithResult:(bool)success withTitle:(NSString*)title withSubtitle:(NSString*)subtitle withDetailText:(NSString*)detailedText withLeftButtonOption:(int)leftButtonOption withLeftButtonImageString:(NSString*)leftButtonImageString withLeftButtonSelectedImageString:(NSString*)leftButtonSelectedImageString withLeftButtonTitle:(NSString*)leftButtonTitle withLeftButtonTitleColor:(UIColor*)leftButtonTextColor withRightButtonOption:(int)rightButtonOption withRightButtonImageString:(NSString*)rightButtonImageString withRightButtonSelectedImageString:(NSString*)rightButtonSelectedImageString withRightButtonTitle:(NSString*)rightButtonTitle withRightButtonTitleColor:(UIColor*)rightButtonTextColor withDelegate:(id)alertDelegate;

@end
