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
#import "Contact.h"
#import "ContactSelectChosenProtocol.h"
#import "CoreLocation/CoreLocation.h"

@interface RequestMoneyController : UIBaseViewController<UIAlertViewDelegate,  UITableViewDelegate, UITextFieldDelegate, SignInCompleteProtocol, ACHSetupCompleteProtocol, SecurityPinCompleteDelegate, UITableViewDataSource, ContactSelectChosenProtocol, 
    CLLocationManagerDelegate> {
    UITableView *autoCompleteTableView;
    IBOutlet UIView *viewPanel;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextField *txtComments;
    IBOutlet UIButton *btnSendRequest;
    ConfirmPaymentDialogController *securityPinModalPanel;
    NSString* recipientUri;
    NSString* amount;
    NSString* comments;
    RequestMoneyService* requestMoneyService;
    IBOutlet UIButton *chooseRecipientButton;
    IBOutlet UILabel *contactHead;
    IBOutlet UILabel *contactDetail;
    IBOutlet UIButton *recipientImageButton;
    Contact *recipient;
    CLLocationManager *lm;
    CLLocation *location;
}

@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITextField *txtAmount;
@property(nonatomic, retain) UITextField *txtComments;
@property(nonatomic, retain) UIButton *btnSendRequest;
@property(nonatomic, retain) UIButton *chooseRecipientButton;
@property(nonatomic, retain) UILabel *contactHead;
@property(nonatomic, retain) UILabel *contactDetail;
@property(nonatomic, retain) UIButton *recipientImageButton;
@property(nonatomic, retain) NSString* recipientUri;
@property(nonatomic, retain) CLLocation *location;
@property(nonatomic, retain) CLLocationManager *lm;


-(IBAction) bgTouched:(id) sender;
-(IBAction) btnSendRequestClicked:(id) sender;
- (IBAction)pressedChooseRecipientButton:(id)sender;

@end
