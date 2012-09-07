//
//  ProfileController.h
//  Fanatical
//
//  Created by James Rhodes on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
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
#import "SharingPreferencesViewController.h"
#import "HelpViewController.h"
#import "TOSViewController.h"
#import "ZendeskDropboxSampleViewController.h"
#import "LinkWithFacebookProtocol.h"
#import "TwitterRushViewController.h"

@interface ProfileController : UISetupUserBaseViewController   
<UITableViewDataSource, UIAlertViewDelegate,UITableViewDelegate, MFMailComposeViewControllerDelegate,LinkWithFacebookProtocol, FBRequestDelegate> {
    NSDictionary *profileOptions;
    NSArray *sections;
    NSString* oldSecurityPin;
    NSString* newSecurityPin;
    UIActivityIndicatorView* spinner;
    UserService* userService;
    IBOutlet UITableView* tableView;
}
@property(nonatomic, retain) NSDictionary *profileOptions;
@property(nonatomic, retain) NSArray *sections;

@end
