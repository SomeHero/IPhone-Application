//
//  RequestMoneyController.h
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALUnlockPatternView.h"
#import "ASIHTTPRequest.h"
#import "UAModalPanel.h"
#import "ConfirmPaymentDialogController.h"
#import "SetupACHAccountController.h"
#import "SignInCompleteProtocol.h"
#import "ACHSetupCompleteProtocol.h"
#import "UIBaseViewController.h"

@interface RequestMoneyController : UIBaseViewController<UIAlertViewDelegate,  UITableViewDelegate, UITextFieldDelegate, SignInCompleteProtocol, ACHSetupCompleteProtocol, SecurityPinCompleteDelegate, UITableViewDataSource> {
    UITableView *autoCompleteTableView;
    IBOutlet UIView *viewPanel;
    IBOutlet UITextField *txtRecipientUri;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextField *txtComments;
    IBOutlet UIButton *btnSendRequest;
    ConfirmPaymentDialogController *securityPinModalPanel;
    NSString* recipient;
    NSString* amount;
    NSString* comments;
}
@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITextField *txtRecipientUri;
@property(nonatomic, retain) UITextField *txtAmount;
@property(nonatomic, retain) UITextField *txtComments;
@property(nonatomic, retain) UIButton *btnSendRequest;

-(IBAction) bgTouched:(id) sender;
-(IBAction) btnSendRequestClicked:(id) sender;

@end
