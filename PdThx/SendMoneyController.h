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
#import <CoreLocation/CoreLocation.h>
	

@interface SendMoneyController : UIBaseViewController<UIAlertViewDelegate, UITextFieldDelegate, SendMoneyCompleteProtocol, SignInCompleteProtocol, ACHSetupCompleteProtocol, SecurityPinCompleteDelegate, ContactSelectChosenProtocol, CLLocationManagerDelegate> {
    IBOutlet UIView *viewPanel;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextView *txtComments;
    
    IBOutlet UIButton *btnSendMoney;
    ConfirmPaymentDialogController *securityPinModalPanel;
    NSString* amount;
    NSString* comments;
    NSString* recipientUri;
    SendMoneyService* sendMoneyService;
    
    // Buttons
    IBOutlet UIButton *chooseRecipientButton;
    IBOutlet UIButton *chooseAmountButton;
    
    
    IBOutlet UILabel *contactHead;
    IBOutlet UILabel *contactDetail;
    IBOutlet UIButton *recipientImageButton;
    Contact *recipient;
    CLLocationManager *lm;
    double latitude;
    double longitude;
}


@property (retain, nonatomic) IBOutlet UIButton *whiteBoxView;
@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITextField *txtAmount;
@property(nonatomic, retain) UITextView *txtComments;
@property(nonatomic, retain) UIButton *btnSendMoney;
@property(nonatomic, retain) UIButton *chooseAmountButton;
@property(nonatomic, retain) NSString* amount;
@property(nonatomic, retain) UIButton *chooseRecipientButton;
@property(nonatomic, retain) UILabel *contactHead;
@property(nonatomic, retain) UILabel *contactDetail;
@property(nonatomic, retain) UIButton *recipientImageButton;
@property(nonatomic, retain) NSString* recipientUri;
@property(nonatomic, retain) CLLocationManager *lm;


/*              Button Actions              */
/*  --------------------------------------- */
- (IBAction)pressedChooseRecipientButton:(id)sender;
- (IBAction)pressedAmountButton:(id)sender;


-(IBAction) bgTouched:(id) sender;
-(IBAction) btnSendMoneyClicked:(id) sender;
-(void)showModalPanel;
-(void) sendMoneyService:(NSString *)theAmount toRecipient:(NSString *)theRecipient fromMobileNumber:(NSString *)fromMobileNumber withComment:(NSString *)theComments withSecurityPin:(NSString *)securityPin
fromUserId: (NSString *)userId withFromAccount:(NSString *)fromAccount;
-(void) signOutClicked;
-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;
@end
