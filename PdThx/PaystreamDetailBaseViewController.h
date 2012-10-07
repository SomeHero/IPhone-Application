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
#import "AddACHOptionsViewController.h"

@interface PaystreamDetailBaseViewController : UIViewController<AcceptPaymentRequestProtocol, CancelPaymentProtocol, ACHSetupCompleteProtocol>
{
    PaystreamMessage* messageDetail;
    PaystreamService* paystreamServices;
    IBOutlet UINavigationBar* navBar;
    IBOutlet UIButton* btnSender;
    IBOutlet UIButton* btnRecipient;
    IBOutlet UILabel* txtSender;
    
    IBOutlet OHAttributedLabel* txtActionAmount;
    
    IBOutlet UILabel* txtRecipient;
    IBOutlet UILabel* lblSentDate;
    IBOutlet UIView* quoteView;
    IBOutlet UITableView* detailTableView;
    
    User* user;
    UIViewController* parent;

    NSString* pendingAction;
    
    // Table Subviews and information
    IBOutlet UIView *statusSectionHeader;
    
    IBOutlet UIButton* btnCurrentStatus;

    
    IBOutlet UIView *deliverySectionHeader;
    IBOutlet OHAttributedLabel *expressDeliveryChargeLabel;
    IBOutlet UIButton *expressDeliveryButton;
    IBOutlet OHAttributedLabel *expressDeliveryText;
    
    // ActionTable View Setup
    
    
    // Action Buttons
    IBOutlet UITableViewCell *rejectRequestCell;
    IBOutlet UIButton *rejectButton;
    
    IBOutlet UITableViewCell *sendReminderCell;
    IBOutlet UIButton *remindButton;
    
    IBOutlet UITableViewCell *acceptPayCell;
    IBOutlet UIButton *acceptButton;
}

@property(nonatomic, retain) PaystreamMessage* messageDetail;

@property(nonatomic, retain) UINavigationBar* navBar;
@property(nonatomic, retain) UIButton* btnSender;
@property(nonatomic, retain) UIButton* btnRecipient;
@property(nonatomic, retain) UILabel* txtSender;

@property(nonatomic, retain) OHAttributedLabel* txtActionAmount;

@property(nonatomic, retain) UILabel* txtRecipient;
@property(nonatomic, retain) UIButton* btnCurrentStatus;
@property(nonatomic, retain) UILabel* lblSentDate;
@property(nonatomic, retain) UIView* quoteView;

@property(nonatomic, retain) UIViewController* parent;

@property (nonatomic, retain) UITableView* detailTableView;

@property (nonatomic, retain) UIView *deliverySectionHeader;
@property (nonatomic, retain) OHAttributedLabel *expressDeliveryChargeLabel;
@property (nonatomic, retain) UIButton *expressDeliveryButton;
@property (nonatomic, retain) OHAttributedLabel *expressDeliveryText;


// Action Buttons
@property (nonatomic, retain) UITableViewCell *rejectRequestCell;
@property (nonatomic, retain) UIButton *rejectButton;

@property (nonatomic, retain) UITableViewCell *sendReminderCell;
@property (nonatomic, retain) UIButton *remindButton;

@property (nonatomic, retain) UITableViewCell *acceptPayCell;
@property (nonatomic, retain) UIButton *acceptButton;



@property (nonatomic, retain) UIView *statusSectionHeader;


- (UIView*)makeBubbleWithWidth:(CGFloat)w font:(UIFont*)f text:(NSString*)s background:(NSString*)fn caps:(CGSize)caps padding:(CGFloat*)padTRBL;

@end
