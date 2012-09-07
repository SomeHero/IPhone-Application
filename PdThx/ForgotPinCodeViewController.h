//
//  ForgotPinCodeViewController.h
//  PdThx
//
//  Created by Edward Mitchell on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"

@interface ForgotPinCodeViewController : UIModalBaseViewController <ALUnlockPatternViewDelegate>
{
    IBOutlet UIView* viewPinLock;
    id<CustomSecurityPinSwipeProtocol> securityPinSwipeDelegate;
    NSInteger tag;
    bool didCancel;
    GenericSecurityPinSwipeController *controller;
    UserService* userService;
    NSString* newSecurityPin;
}

@property(nonatomic, retain) id securityPinSwipeDelegate;
@property(nonatomic) NSInteger tag;
@property (retain, nonatomic) IBOutlet UIView *viewPinLock;

@end
