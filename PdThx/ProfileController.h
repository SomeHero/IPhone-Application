//
//  ProfileController.h
//  Fanatical
//
//  Created by James Rhodes on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupSecurityPin.h"
#import "ConfirmSecurityPinDialog.h"
#import "ChangeSecurityPinController.h"
#import "UIBaseViewController.h"
#import "UserService.h"
#import "UISetupUserBaseViewController.h"

@interface ProfileController : UISetupUserBaseViewController   
<UITableViewDataSource, UIAlertViewDelegate,UITableViewDelegate, SecurityPinCompleteDelegate, ConfirmSecurityPinCompleteDelegate> {
    NSDictionary *profileOptions;
    NSArray *sections;
    SetupSecurityPin *securityPinModal;
    ConfirmSecurityPinDialog *confirmSecurityPinModal;
    NSString* oldSecurityPin;
    NSString* newSecurityPin;
    UIActivityIndicatorView* spinner;
    UserService* userService;
    User* user;
}
@property(nonatomic, retain) NSDictionary *profileOptions;
@property(nonatomic, retain) NSArray *sections;

@end
