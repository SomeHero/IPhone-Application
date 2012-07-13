//
//  ChangeSecurityPinController.h
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIModalBaseViewController.h"
#import "CustomSecurityPinSwipeController.h"
#import "UserService.h"
#import "PdThxAppDelegate.h"
#import "User.h"

@interface ChangeSecurityPinController :UIModalBaseViewController<ALUnlockPatternViewDelegate> {
    
    IBOutlet UIView* viewPinLock;
    id<CustomSecurityPinSwipeProtocol> securityPinSwipeDelegate;
    NSInteger tag;
    bool didCancel;
    CustomSecurityPinSwipeController *controller;
    UserService* userService;
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
