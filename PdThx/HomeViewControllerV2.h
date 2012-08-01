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

@interface HomeViewControllerV2 : UIBaseViewController< UserInformationCompleteProtocol, HBTabBarDelegate, QuickSendButtonProtocol>
{
    IBOutlet UIView *viewPanel;
    IBOutlet UIButton *btnSendPhone;
    IBOutlet UIButton *btnSendFacebook;
    IBOutlet UIButton *btnSendNonprofit;
    IBOutlet UIButton *btnProfile;
    IBOutlet UIButton *btnPaystream;
    IBOutlet UIButton *btnUserImage;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel* lblPayPoints;
    IBOutlet UILabel* lblScore;
    
    UserService *userService;
    IBOutlet QuickSendView *quickSendView;
}

@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UIButton *btnSendPhone;
@property(nonatomic, retain) UIButton *btnSendFacebook;
@property(nonatomic, retain) UIButton *btnSendNonprofit;

@property(nonatomic, retain) UILabel *lblUserName;
@property(nonatomic, retain) QuickSendView *quickSendView;

@property (nonatomic, retain) HBTabBarManager *tabBar;

@property (assign) int quickSendOpened;

- (IBAction)swipeUpQuickSend:(id)sender;
- (IBAction)swipeDownQuickSend:(id)sender;


-(IBAction) btnProfileClicked:(id) sender;
-(IBAction) btnIncreaseScoreClicked: (id) sender;



@end