//
//  ProfileController.h
//  Fanatical
//
//  Created by James Rhodes on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeSecurityPinController.h"
#import "UIBaseViewController.h"
#import "UserService.h"
#import "UISetupUserBaseViewController.h"
#import "MeCodeListViewController.h"
#import "MeCodeSetupViewController.h"
#import "PhoneListViewController.h"
#import "EmailAccountListViewController.h"
#import "NotificationConfigurationViewController.h"
#import "SecurityAndPrivacyViewControllerViewController.h"
#import "EditProfileViewController.h"
#import "UIProfileTableViewCell.h"

@interface ProfileController : UISetupUserBaseViewController   
<UITableViewDataSource, UIAlertViewDelegate,UITableViewDelegate> {
    NSDictionary *profileOptions;
    NSArray *sections;
    NSString* oldSecurityPin;
    NSString* newSecurityPin;
    UIActivityIndicatorView* spinner;
    UserService* userService;
}
@property(nonatomic, retain) NSDictionary *profileOptions;
@property(nonatomic, retain) NSArray *sections;

@end
