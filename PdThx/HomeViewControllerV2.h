//
//  HomeViewControllerV2.h
//  PdThx
//
//  Created by James Rhodes on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupACHAccountController.h"
#import "SignInCompleteProtocol.h"
#import "UIBaseViewController.h"
#import "UserService.h"
#import "IncreaseProfileViewController.h"
#import "EditProfileViewController.h"
#import "HBTabBarManager.h"
#import "QuickSendView.h"
#import "QuickSendButtonProtocol.h"


#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface HomeViewControllerV2 : UIBaseViewController<UserInformationCompleteProtocol, HBTabBarDelegate, QuickSendButtonProtocol, UIGestureRecognizerDelegate>
{
    IBOutlet UIView *viewPanel;
    
    IBOutlet UIButton *btnProfile;
    IBOutlet UIButton *btnUserImage;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel* lblPayPoints;
    
    IBOutlet UILabel *incomingNotificationLabel;
    IBOutlet UILabel *outgoingNotificationLabel;
    
    UISwipeGestureRecognizer *swipeUpQuicksend;
    UISwipeGestureRecognizer *swipeDownQuicksend;
    
    UserService *userService;
    
    NSMutableArray *quickSendContacts;
    
    IBOutlet QuickSendView *quickSendView;
    
    IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
}

@property(nonatomic, retain) UIView *viewPanel;

@property(nonatomic, retain) UIActivityIndicatorView *loadingActivityIndicator;

@property(nonatomic, retain) NSMutableArray *quickSendContacts;

@property (nonatomic, retain) UILabel *lblDailyLimit;
@property (nonatomic, retain) UILabel *lblRemainingLimit;

@property(nonatomic, retain) UILabel *lblUserName;


@property (retain, nonatomic) QuickSendView *quickSendView;

@property (nonatomic, retain) HBTabBarManager *tabBar;

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpQuicksend;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownQuicksend;

@property (nonatomic, retain) UILabel *incomingNotificationLabel;
@property (nonatomic, retain) UILabel *outgoingNotificationLabel;

@property (assign) int quickSendOpened;

-(IBAction) btnProfileClicked:(id) sender;
-(IBAction) btnIncreaseScoreClicked: (id) sender;



@end