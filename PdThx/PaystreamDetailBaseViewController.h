//
//  PaystreamDetailBaseViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaystreamMessage.h"
#import "PaystreamService.h"
#import "PullableView.h"
#import "CancelPaymentProtocol.h"
#import "CancelPaymentRequestProtocol.h"
#import "AcceptPaymentRequestProtocol.h"
#import "RejectPaymentRequestProtocol.h"
#import "CustomSecurityPinSwipeController.h"
#import "User.h"
#import "PdThxAppDelegate.h"
#import "OHAttributedLabel.h"

@interface PaystreamDetailBaseViewController : UIViewController<AcceptPaymentRequestProtocol, CancelPaymentProtocol>
{
    PaystreamMessage* messageDetail;
    PaystreamService* paystreamServices;
    IBOutlet UINavigationBar* navBar;
    IBOutlet UIButton* btnSender;
    IBOutlet UIButton* btnRecipient;
    IBOutlet UILabel* txtSender;
    
    IBOutlet OHAttributedLabel* txtActionAmount;
    
    IBOutlet UILabel* txtRecipient;
    IBOutlet UILabel* lblCurrentStatusHeader;
    IBOutlet UIButton* btnCurrentStatus;
    IBOutlet UILabel* lblWhatsNextStatusHeader;
    IBOutlet UILabel* lblSentDate;
    IBOutlet UIView* quoteView;
    IBOutlet UIView* actionView;
    
    IBOutlet OHAttributedLabel *expressDeliveryChargeLabel;
    IBOutlet UIButton *expressDeliveryButton;
    IBOutlet OHAttributedLabel *expressDeliveryText;
    IBOutlet UILabel *expressSubtext;
    
    bool isExpressed;
    double expressDeliveryCharge;
    
    User* user;
    UIViewController* parent;

    NSString* pendingAction;
}

@property(nonatomic, retain) OHAttributedLabel *expressDeliveryChargeLabel;
@property(nonatomic, retain) UIButton *expressDeliveryButton;
@property(nonatomic, retain) OHAttributedLabel *expressDeliveryText;
@property(nonatomic, retain) UILabel *expressSubtext;

@property (assign) bool isExpressed;
@property (assign) double expressDeliveryCharge;

@property(nonatomic, retain) PaystreamMessage* messageDetail;
@property(nonatomic, retain) UINavigationBar* navBar;
@property(nonatomic, retain) UIButton* btnSender;
@property(nonatomic, retain) UIButton* btnRecipient;
@property(nonatomic, retain) UILabel* txtSender;

@property(nonatomic, retain) OHAttributedLabel* txtActionAmount;

@property(nonatomic, retain) UILabel* txtRecipient;
@property(nonatomic, retain) UILabel* lblCurrentStatusHeader;
@property(nonatomic, retain) UILabel* lblWhatsNextStatusHeader;
@property(nonatomic, retain) UIButton* btnCurrentStatus;
@property(nonatomic, retain) UILabel* lblSentDate;
@property(nonatomic, retain) UIView* quoteView;
@property(nonatomic, retain) UIView* actionView;
@property (retain, nonatomic) IBOutlet UIImageView *actionViewDivider;

@property(nonatomic, retain) PullableView* pullableView;
@property(nonatomic, retain) UIViewController* parent;

- (UIView*)makeBubbleWithWidth:(CGFloat)w font:(UIFont*)f text:(NSString*)s background:(NSString*)fn caps:(CGSize)caps padding:(CGFloat*)padTRBL;

@end
