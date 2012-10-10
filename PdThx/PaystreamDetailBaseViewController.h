//
//  PaystreamDetailBaseViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
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

@interface PaystreamDetailBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,AcceptPaymentRequestProtocol, CancelPaymentProtocol, ACHSetupCompleteProtocol, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
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
    IBOutlet UITableViewCell *statusCell;
    IBOutlet UIButton *currentStatusButton;
    
    IBOutlet UIView *actionButtonsHeader;
    
    // Action Buttons
    IBOutlet UITableViewCell *rejectRequestCell;
    IBOutlet UIButton *rejectButton;
    
    IBOutlet UITableViewCell *sendReminderCell;
    IBOutlet UIButton *remindButton;
    
    IBOutlet UITableViewCell *acceptPayCell;
    IBOutlet UIButton *acceptButton;
    
    // Express Delivery Section Header and Cell
    IBOutlet UIView *deliverySectionHeader;
    IBOutlet UITableViewCell *deliveryStatusCell;
    IBOutlet UIButton *deliveryMethodButton;
    
    IBOutlet UITableViewCell *expressDeliveryCell;
    IBOutlet OHAttributedLabel *expressDeliveryChargeLabel;
    IBOutlet UIButton *expressDeliveryButton;
    IBOutlet OHAttributedLabel *expressDeliveryText;
    
    NSMutableArray* sections;
    NSMutableDictionary* actionTableData;
}

@property (nonatomic, retain) PaystreamMessage* messageDetail;
@property (nonatomic, retain) PaystreamService* paystreamServices;
@property (nonatomic, retain) UINavigationBar* navBar;
@property (nonatomic, retain) UIButton* btnSender;
@property (nonatomic, retain) UIButton* btnRecipient;
@property (nonatomic, retain) UILabel* txtSender;

@property (nonatomic, retain) OHAttributedLabel* txtActionAmount;

@property (nonatomic, retain) UILabel* txtRecipient;
@property (nonatomic, retain) UILabel* lblSentDate;
@property (nonatomic, retain) UIView* quoteView;
@property (nonatomic, retain) UITableView* detailTableView;

@property (nonatomic, retain) User* user;
@property (nonatomic, retain) UIViewController* parent;

@property (nonatomic, retain)NSString* pendingAction;

// Table Subviews and information
@property (nonatomic, retain) UITableViewCell *statusCell;
@property (nonatomic, retain) UIButton *currentStatusButton;
@property (nonatomic, retain) UIButton *deliveryMethodButton;

// Action Buttons
@property (nonatomic, retain) UITableViewCell *rejectRequestCell;
@property (nonatomic, retain) UIButton *rejectButton;

@property (nonatomic, retain) UITableViewCell *sendReminderCell;
@property (nonatomic, retain) UIButton *remindButton;

@property (nonatomic, retain) UITableViewCell *acceptPayCell;
@property (nonatomic, retain) UIButton *acceptButton;

// Express Delivery Section Header and Cell
@property (nonatomic, retain) UIView *deliverySectionHeader;
@property (nonatomic, retain) UITableViewCell *deliveryStatusCell;

@property (nonatomic, retain) UITableViewCell *expressDeliveryCell;
@property (nonatomic, retain) OHAttributedLabel *expressDeliveryChargeLabel;
@property (nonatomic, retain) UIButton *expressDeliveryButton;
@property (nonatomic, retain) OHAttributedLabel *expressDeliveryText;

@property (nonatomic, retain) NSMutableArray* sections;
@property (nonatomic, retain) NSMutableDictionary* actionTableData;

@property (nonatomic, retain) UIView *actionButtonsHeader;

- (UIView*)makeBubbleWithWidth:(CGFloat)w font:(UIFont*)f text:(NSString*)s background:(NSString*)fn caps:(CGSize)caps padding:(CGFloat*)padTRBL;

@end
