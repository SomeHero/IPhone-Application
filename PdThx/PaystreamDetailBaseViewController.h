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
#import "ConfirmPaymentDialogController.h"

@interface PaystreamDetailBaseViewController : UIViewController<SecurityPinCompleteDelegate, AcceptPaymentRequestProtocol, CancelPaymentProtocol> {
    IBOutlet UIView *detailSubView;
    PaystreamMessage* messageDetail;
    PaystreamService* paystreamServices;
    IBOutlet UINavigationBar* navBar;
    IBOutlet UIButton* btnSender;
    IBOutlet UIButton* btnRecipient;
    IBOutlet UILabel* txtSender;
    IBOutlet UILabel* txtAction;
    IBOutlet UILabel* txtRecipient;
    IBOutlet UILabel* lblCurrentStatusHeader;
    IBOutlet UIButton* btnCurrentStatus;
    IBOutlet UILabel* lblWhatsNextStatusHeader;
    IBOutlet UILabel* lblSentDate;
    IBOutlet UIView* quoteView;
    IBOutlet UIView* actionView;
    UIButton* btnCancelPayment;
    UIButton* btnSendReminder;
    UIButton* btnCancelRequest;
    UIButton* btnAcceptRequest;
    UIButton* btnRejectRequest;
    PullableView* pullableView;
    UIViewController* parent;
    ConfirmPaymentDialogController *securityPinModalPanel;
}

@property (nonatomic, retain) UIView *detailSubview;

@property(nonatomic, retain) PaystreamMessage* messageDetail;
@property(nonatomic, retain) UINavigationBar* navBar;
@property(nonatomic, retain) UIButton* btnSender;
@property(nonatomic, retain) UIButton* btnRecipient;
@property(nonatomic, retain) UILabel* txtSender;
@property(nonatomic, retain) UILabel* txtAction;
@property(nonatomic, retain) UILabel* txtRecipient;
@property(nonatomic, retain) UILabel* lblCurrentStatusHeader;
@property(nonatomic, retain) UILabel* lblWhatsNextStatusHeader;
@property(nonatomic, retain) UIButton* btnCurrentStatus;
@property(nonatomic, retain) UILabel* lblSentDate;
@property(nonatomic, retain) UIView* quoteView;
@property(nonatomic, retain) UIView* actionView;
@property(nonatomic, retain) PullableView* pullableView;
@property(nonatomic, retain) UIViewController* parent;

- (UIView*)makeBubbleWithWidth:(CGFloat)w font:(UIFont*)f text:(NSString*)s background:(NSString*)fn caps:(CGSize)caps padding:(CGFloat*)padTRBL;
- (IBAction)showModalPanel;
@end
