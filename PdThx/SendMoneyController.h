//
//  SendMoneyController.h
//  PdThx
//
//  Created by James Rhodes on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALUnlockPatternView.h"
#import "ASIHTTPRequest.h"
#import "ConfirmPaymentDialogController.h"
#import "SignInCompleteProtocol.h"
#import "ACHSetupCompleteProtocol.h"
#import "UIBaseViewController.h"
#import "Environment.h"
#import "SendMoneyService.h"
#import "SendMoneyCompleteProtocol.h"

@interface SendMoneyController : UIBaseViewController<UIAlertViewDelegate,  UITableViewDelegate, UITextFieldDelegate, SendMoneyCompleteProtocol, SignInCompleteProtocol, ACHSetupCompleteProtocol, SecurityPinCompleteDelegate, UITableViewDataSource> {
    UITableView *autoCompleteTableView;
    IBOutlet UIView *viewPanel;
    IBOutlet UITextField *txtRecipientUri;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextField *txtComments;
    IBOutlet UIButton *btnSendMoney;
    ConfirmPaymentDialogController *securityPinModalPanel;
    NSString* recipientUri;
    NSString* amount;
    NSString* comments;
    SendMoneyService* sendMoneyService;
}
@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITextField *txtRecipientUri;
@property(nonatomic, retain) UITextField *txtAmount;
@property(nonatomic, retain) UITextField *txtComments;
@property(nonatomic, retain) UIButton *btnSendMoney;
@property(nonatomic, retain) NSString* amount;


-(IBAction) bgTouched:(id) sender;
-(IBAction) btnSendMoneyClicked:(id) sender;
-(void)showModalPanel;
-(void) sendMoneyService:(NSString *)theAmount toRecipient:(NSString *)theRecipient fromMobileNumber:(NSString *)fromMobileNumber withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
       fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount;
-(void) signOutClicked;
-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;
@end
