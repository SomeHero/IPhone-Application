//
//  CustomSecurityPinSwipeController.h
//  PdThx
//
//  Created by James Rhodes on 6/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALUnlockPatternView.h"
#import "CustomSecurityPinSwipeProtocol.h"

@interface CustomSecurityPinSwipeController : UIViewController<ALUnlockPatternViewDelegate>
{    
    IBOutlet UIView* viewPinLock;
    IBOutlet UINavigationItem *navigationItem;
    IBOutlet UILabel* lblHeader;
    id<CustomSecurityPinSwipeProtocol> securityPinSwipeDelegate;
    NSString* navigationTitle;
    NSString* headerText;
    NSInteger tag;
    NSString* securityPin;
    bool didCancel;
    IBOutlet UIButton *contactImageButton;
    IBOutlet UINavigationBar *navigationBar;
}


@property(nonatomic, retain) UIView* viewPinLock;
@property(nonatomic, retain) UINavigationItem* navigationItem;
@property(nonatomic, retain) UINavigationBar* navigationBar;

@property(nonatomic, retain) UILabel* lblHeader;
@property(nonatomic, retain) UIButton *contactImageButton;

@property(nonatomic, retain) id securityPinSwipeDelegate;
@property(nonatomic, retain) NSString* navigationTitle;
@property(nonatomic, retain) NSString* headerText;
@property(nonatomic) NSInteger tag;

@end
