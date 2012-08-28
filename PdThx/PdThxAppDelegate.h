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

@interface PdThxAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, ApplicationSettingsCompleteProtocol, FBSessionDelegate, FBRequestDelegate, UINavigationControllerDelegate, CustomAlertViewProtocol>
{
    
    Facebook * fBook;
    NSString * deviceToken;
    PhoneNumberFormatting *phoneNumberFormatter;
    NSArray * permissions;
    UIAlertView * notifAlert;
    UINavigationController *welcomeTabBarController;
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
    NSMutableArray *quickSendArray;
    
    NSMutableArray* phoneContacts;
    CFIndex phoneContactsSize;
    NSMutableArray* faceBookContacts;
    NSMutableArray* nonProfits;
    NSMutableArray* organizations;
    
    NSString * fbAppId;
    
    UINavigationController * mainAreaTabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) Facebook * fBook;
@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) PhoneNumberFormatting *phoneNumberFormatter;
@property (nonatomic, retain) NSArray * permissions;
@property (nonatomic, retain) UIAlertView * notifAlert;
@property (nonatomic, assign) bool areFacebookContactsLoaded;
@property (nonatomic, retain) UITabBarController *newUserFlowTabController;
@property (nonatomic, retain) FBRequest *friendRequest;
@property (nonatomic, retain) FBRequest *infoRequest;
@property(nonatomic, retain) User* user;
@property (nonatomic, retain) myProgressHud *myProgHudOverlay;
@property (nonatomic, retain) ProgressHudInnnerViewController *myProgHudInnerView;
@property (nonatomic, retain) CustomAlertViewController *customAlert;

@property (nonatomic, retain) UINavigationController* setupFlowController;

@property (nonatomic, retain) UINavigationController *welcomeTabBarController;
@property(nonatomic, retain) UINavigationController * mainAreaTabBarController;
@property (nonatomic, assign) int animationTimer;


@property(nonatomic, retain) Application* myApplication;


@property (nonatomic, retain) NSMutableArray *contactsArray;

@property (nonatomic, retain) NSMutableArray *quickSendArray;


@property (nonatomic, retain) NSMutableArray *phoneContacts;
@property (nonatomic, retain) NSMutableArray *faceBookContacts;
@property(nonatomic, retain) NSMutableArray* nonProfits;
@property(nonatomic, retain) NSMutableArray* organizations;

@property(nonatomic, retain) NSString * fbAppId;

@property(nonatomic, retain) NSString* selectedContactList;


/*      Static Tab Bar Setup        */
@property (assign) int currentMainAreaTabIndex;
@property(nonatomic, retain) UIViewController* LoggedInFirstViewController;
@property(nonatomic, retain) UIViewController* LoggedInSecondViewController;
@property(nonatomic, retain) UIViewController* LoggedInCenterViewController;
@property(nonatomic, retain) UIViewController* LoggedInFourthViewController;
@property(nonatomic, retain) UIViewController* LoggedInFifthViewController;

-(void)signOut;
-(void)forgetMe;
-(void)switchToSendMoneyController;
-(void)switchToRequestMoneyController;
-(void)switchToPaystreamController;
-(void)loadPhoneContacts;

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
-(double)getUpperLimit;

-(void) showSimpleAlertView:(bool)status withTitle:(NSString*)headerText withSubtitle:(NSString*)subTitle withDetailedText:(NSString*)detailText withButtonText:(NSString*)buttonText withDelegate:(id)delegate;

-(void) showTextFieldAlertView:(bool)status withTitle:(NSString*)headerText withSubtitle:(NSString*)subTitle withDetailedText:(NSString*)detailText withButtonText:(NSString*)buttonText withTextFieldPlaceholderText:(NSString*)placeholderText withDelegate:(id)delegate;

-(void) showTwoButtonAlertView:(bool)status withTitle:(NSString*)headerText withSubtitle:(NSString*)subTitle withDetailedText:(NSString*)detailText withButton1Text:(NSString*)button1Text withButton2Text:(NSString*)button2Text withDelegate:(id<CustomAlertViewProtocol>) delegate;

-(void)showAlertWithResult:(bool)success withTitle:(NSString*)title withSubtitle:(NSString*)subtitle withDetailText:(NSString*)detailedText withLeftButtonOption:(int)leftButtonOption withLeftButtonImageString:(NSString*)leftButtonImageString withLeftButtonSelectedImageString:(NSString*)leftButtonSelectedImageString withLeftButtonTitle:(NSString*)leftButtonTitle withLeftButtonTitleColor:(UIColor*)leftButtonTextColor withRightButtonOption:(int)rightButtonOption withRightButtonImageString:(NSString*)rightButtonImageString withRightButtonSelectedImageString:(NSString*)rightButtonSelectedImageString withRightButtonTitle:(NSString*)rightButtonTitle withRightButtonTitleColor:(UIColor*)rightButtonTextColor withTextFieldPlaceholderText:(NSString*)placeholderText withDelegate:(id)alertDelegate;



-(UIViewController*)switchMainAreaToTabIndex:(int)tabIndex;

@end
