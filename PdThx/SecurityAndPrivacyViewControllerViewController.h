//
//  SecurityAndPrivacyViewControllerViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "ChangePasswordViewController.h"
#import "ForgotPinCodeViewController.h"
#import "SecurityQuestionChallengeViewController.h"
#import "SecurityQuestionChallengeProtocol.h"
#import "GenericSecurityPinSwipeController.h"
#import "ValidationHelper.h"
#import "UserService.h"
#import "User.h"

@interface SecurityAndPrivacyViewControllerViewController : UISetupUserBaseViewController 
<UITableViewDataSource, UIAlertViewDelegate,UITableViewDelegate, SecurityQuestionChallengeProtocol, CustomSecurityPinSwipeProtocol, UserSecurityPinCompleteProtocol>
{
    NSDictionary *profileOptions;
    NSArray *sections;
    UIActivityIndicatorView* spinner;
    UserService*userService;
}

@property(nonatomic,retain) User * currentUser;
@property(nonatomic, retain) NSDictionary *profileOptions;
@property(nonatomic, retain) NSArray *sections;

@property(nonatomic,retain) NSString*savedPinSwipe;
@property(nonatomic,retain) NSString*anotherSavedPinSwipe;

@property(nonatomic, retain) ValidationHelper * validationHelper;
@property(nonatomic, retain) UserService*userService;


@end
