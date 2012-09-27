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
#import "OHAttributedLabel.h"

@interface CustomSecurityPinSwipeController : UIViewController<ALUnlockPatternViewDelegate>
{    
    IBOutlet UIView* viewPinLock;
    IBOutlet UINavigationItem *navigationItem;

    id<CustomSecurityPinSwipeProtocol> securityPinSwipeDelegate;
    NSString* navigationTitle;
    
    IBOutlet OHAttributedLabel* toLabel;
    IBOutlet OHAttributedLabel* amountLabel;
    IBOutlet OHAttributedLabel* deliveryLabel;
    
    NSString* recipientName;
    double amount;
    
    NSString* deliveryType;
    double deliveryCharge;
    
    IBOutlet UIImageView *expressIcon;
    
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

@property(nonatomic, retain) UIImageView *expressIcon;

@property(nonatomic, retain) OHAttributedLabel* toLabel;
@property(nonatomic, retain) OHAttributedLabel* amountLabel;
@property(nonatomic, retain) OHAttributedLabel* deliveryLabel;

@property(nonatomic, retain) NSString* recipientName;
@property(assign) double amount;

@property(nonatomic, retain) NSString* deliveryType;
@property(assign) double deliveryCharge;


@property(nonatomic) NSInteger tag;

@end
