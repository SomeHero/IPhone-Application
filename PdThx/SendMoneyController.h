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
#import "SignInCompleteProtocol.h"
#import "UIBaseViewController.h"
#import "Environment.h"
#import "SendMoneyService.h"
#import "SendMoneyCompleteProtocol.h"
#import "ContactSelectViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AmountSelectChosenProtocol.h"
#import "CustomSecurityPinSwipeController.h"
#import "TransactionConfirmationViewController.h"
#import "TransactionConfirmationProtocol.h"
#import "CustomSecurityPinSwipeProtocol.h"
#import "AddACHAccountViewController.h"
#import "HBTabBarManager.h"
#import "DetermineRecipientCompleteProtocol.h"

@interface SendMoneyController : UIBaseViewController<HBTabBarDelegate, UIAlertViewDelegate, UITextFieldDelegate, SendMoneyCompleteProtocol, ContactSelectChosenProtocol, CLLocationManagerDelegate, AmountSelectChosenProtocol, TransactionConfirmationProtocol, UITextViewDelegate, DetermineRecipientCompleteProtocol> {
    IBOutlet UIView *viewPanel;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextView *txtComments;
    
    IBOutlet UIButton *btnSendMoney;
    User* user;
    NSString* amount;
    NSString* comments;
    NSString* recipientUri;
    
    NSMutableArray *autoCompleteArray;
    NSMutableArray *allResults;
    
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
    
    IBOutlet UIImageView *contactButtonBGImage;
    IBOutlet UIImageView *amountButtonBGImage;
    
    IBOutlet UITextField *characterCountLabel;
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

@property(nonatomic, retain) UIImageView *contactButtonBGImage;
@property(nonatomic, retain) UIImageView *amountButtonBGImage;

@property(nonatomic, retain) UITextField *characterCountLabel;
@property (nonatomic, retain) HBTabBarManager *tabBar;

@property (retain, nonatomic) IBOutlet UITextField *dummyCommentPlaceholder;


/*              Button Actions              */
/*  --------------------------------------- */
- (IBAction)pressedChooseRecipientButton:(id)sender;
- (IBAction)pressedAmountButton:(id)sender;


-(IBAction) bgTouched:(id) sender;
-(IBAction) btnSendMoneyClicked:(id) sender;
-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;

@end
