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
#import "RequestMoneyService.h"
#import "User.h"
#import "Contact.h"
#import "ContactSelectChosenProtocol.h"
#import "CoreLocation/CoreLocation.h"
#import "AmountSelectChosenProtocol.h"
#import "CustomSecurityPinSwipeProtocol.h"
#import "TransactionConfirmationViewController.h"

@interface RequestMoneyController : UIBaseViewController<UIAlertViewDelegate, UITextFieldDelegate, ContactSelectChosenProtocol, CLLocationManagerDelegate, AmountSelectChosenProtocol> {

    IBOutlet UIView *viewPanel;
        IBOutlet UITextField *txtAmount;
        IBOutlet UITextView *txtComments;
        
    IBOutlet UIButton *btnSendRequest;
        
    User* user;
    NSString* recipientUri;
    NSString* amount;
    NSString* comments;
        
    RequestMoneyService* requestMoneyService;
        
    IBOutlet UIButton *chooseRecipientButton;
    IBOutlet UIButton *chooseAmountButton;
        
    IBOutlet UILabel *contactHead;
    IBOutlet UILabel *contactDetail;
    IBOutlet UIButton *recipientImageButton;
        
    Contact *recipient;
    CLLocationManager* lm;
    double latitude;
    double longitude;
        
}

@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITextField *txtAmount;
@property(nonatomic, retain) UITextView *txtComments;
@property(nonatomic, retain) UIButton *btnSendRequest;
@property(nonatomic, retain) UIButton *chooseRecipientButton;
@property(nonatomic, retain) UIButton *chooseAmountButton;
@property(nonatomic, retain) NSString* amount;
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
-(IBAction) btnSendRequestClicked:(id) sender;

-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;

@end
