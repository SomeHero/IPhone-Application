//
//  ChangeSecurityPinController.h
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "CustomSecurityPinSwipeController.h"
#import "UserService.h"
#import "PdThxAppDelegate.h"
#import "User.h"

@interface ChangeSecurityPinController :UISetupUserBaseViewController<ALUnlockPatternViewDelegate> {
    
    IBOutlet UIView* viewPinLock;
    IBOutlet UILabel* lblHeader;
    id<CustomSecurityPinSwipeProtocol> securityPinSwipeDelegate;
    NSString* navigationTitle;
    NSString* headerText;
    NSInteger tag;
    bool didCancel;
    CustomSecurityPinSwipeController *controller;
    UserService* userService;
    User* user;
    NSString* oldSecurityPin;
    NSString* newSecurityPin;
}

@property(nonatomic, retain) UIView* viewPinLock;
@property(nonatomic, retain) UILabel* lblHeader;
@property(nonatomic, retain) id securityPinSwipeDelegate;
@property(nonatomic, retain) NSString* navigationTitle;
@property(nonatomic, retain) NSString* headerText;
@property(nonatomic) NSInteger tag;

@end
