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
#import "ContactSelectViewController.h"

@interface SendMoneyController : UIBaseViewController<UIAlertViewDelegate, UITextFieldDelegate, SendMoneyCompleteProtocol, SignInCompleteProtocol, ACHSetupCompleteProtocol, SecurityPinCompleteDelegate, ContactSelectChosenProtocol> {
    IBOutlet UIView *viewPanel;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextField *txtComments;
    IBOutlet UIButton *btnSendMoney;
    ConfirmPaymentDialogController *securityPinModalPanel;
    NSString* amount;
    NSString* comments;
    NSString* recipientUri;
    SendMoneyService* sendMoneyService;
    IBOutlet UIButton *chooseRecipientButton;
    IBOutlet UILabel *contactHead;
    IBOutlet UILabel *contactDetail;
    IBOutlet UIButton *recipientImageButton;
    Contact *recipient;
}

@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITextField *txtAmount;
@property(nonatomic, retain) UITextField *txtComments;
@property(nonatomic, retain) UIButton *btnSendMoney;
@property(nonatomic, retain) NSString* amount;
@property(nonatomic, retain) UIButton *chooseRecipientButton;
@property(nonatomic, retain) UILabel *contactHead;
@property(nonatomic, retain) UILabel *contactDetail;
@property(nonatomic, retain) UIButton *recipientImageButton;
@property(nonatomic, retain) NSString* recipientUri;


- (IBAction)pressedChooseRecipientButton:(id)sender;


-(IBAction) bgTouched:(id) sender;
-(IBAction) btnSendMoneyClicked:(id) sender;
-(void)showModalPanel;
-(void) sendMoneyService:(NSString *)theAmount toRecipient:(NSString *)theRecipient fromMobileNumber:(NSString *)fromMobileNumber withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
       fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount;
-(void) signOutClicked;
-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;
@end
