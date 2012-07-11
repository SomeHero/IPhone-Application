//
//  UISendMoneyBaseViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
#import "AmountSelectViewController.h"

@interface UISendMoneyBaseViewController : UIBaseViewController<UIAlertViewDelegate, UITextFieldDelegate, SendMoneyCompleteProtocol, ContactSelectChosenProtocol, CLLocationManagerDelegate, AmountSelectChosenProtocol, TransactionConfirmationProtocol, UITextViewDelegate> {
    IBOutlet UIView *viewPanel;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextView *txtComments;
    
    IBOutlet UIButton *btnSendMoney;
    User* user;
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
    
    IBOutlet UIImageView *contactButtonBGImage;
    IBOutlet UIImageView *amountButtonBGImage;
    
    IBOutlet UITextField *characterCountLabel;
}


@property(nonatomic, retain) NSString* amount;
@property(nonatomic, retain) NSString* recipientUri;


/*              Button Actions              */
/*  --------------------------------------- */
- (IBAction)pressedChooseRecipientButton:(id)sender;
- (IBAction)pressedAmountButton:(id)sender;
-(IBAction) bgTouched:(id) sender;
-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;

@end