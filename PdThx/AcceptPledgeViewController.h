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
#import "SetupACHAccountController.h"
#import "SignInCompleteProtocol.h"
#import "UIBaseViewController.h"
#import "RequestMoneyService.h"
#import "User.h"
#import "Contact.h"
#import "ContactSelectChosenProtocol.h"
#import "CoreLocation/CoreLocation.h"
#import "AmountSelectChosenProtocol.h"
#import "CustomSecurityPinSwipeProtocol.h"
#import "TransactionConfirmationViewController.h"
#import "AddACHAccountViewController.h"
#import "CustomAlertViewProtocol.h"
#import "DonationContactSelectViewController.h"
#import "CauseSelectDidCompleteProtocol.h"
#import "PaystreamService.h"
#import "PayStreamViewController.h"
#import "SendMoneyController.h"
#import "RequestMoneyController.h"
#import "DoGoodViewController.h"

@interface AcceptPledgeViewController : UIBaseViewController<UIAlertViewDelegate, UITextFieldDelegate, CauseSelectDidCompleteProtocol, ContactSelectChosenProtocol, CLLocationManagerDelegate, AmountSelectChosenProtocol, UIImagePickerControllerDelegate, UITextViewDelegate, CustomAlertViewProtocol, UINavigationControllerDelegate> 
{
    
    IBOutlet UIView *viewPanel;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextView *txtComments;
    
    IBOutlet UIButton *btnSendRequest;
    
    User* user;
    NSString* causeId;
    NSString* recipientUri;
    NSString* amount;
    NSString* comments;
    
    NSMutableArray *autoCompleteArray;
    NSMutableArray *allResults;
    
    RequestMoneyService* requestMoneyService;
    PaystreamService* paystreamService;
    
    IBOutlet UIButton* chooseCauseButton;
    IBOutlet UIButton *chooseRecipientButton;
    IBOutlet UIButton *chooseAmountButton;
    
    IBOutlet UILabel* causeHeader;
    IBOutlet UILabel* causeDetail;
    IBOutlet UIButton *causeImageButton;
    
    IBOutlet UILabel *contactHead;
    IBOutlet UILabel *contactDetail;
    IBOutlet UIButton *recipientImageButton;
    
    Contact *cause;
    Contact *recipient;
    
    CLLocationManager* lm;
    double latitude;
    double longitude;
    
    IBOutlet UIButton *contactImage;
    IBOutlet UIImageView* causeButtonBGImage;
    IBOutlet UIImageView *contactButtonBGImage;
    IBOutlet UIImageView *amountButtonBGImage;
    
    IBOutlet UIButton *attachPictureButton;
    IBOutlet UITextField *characterCountLabel;
}

@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UITextField *txtAmount;
@property(nonatomic, retain) UITextView *txtComments;
@property(nonatomic, retain) UIButton *btnSendRequest;
@property(nonatomic, retain) UIButton *chooseCauseButton;
@property(nonatomic, retain) UIButton *chooseRecipientButton;
@property(nonatomic, retain) UIButton *chooseAmountButton;
@property(nonatomic, retain) NSString* amount;
@property(nonatomic, retain) UILabel *contactHead;
@property(nonatomic, retain) UILabel *contactDetail;
@property(nonatomic, retain) UIButton *recipientImageButton;
@property(nonatomic, retain) NSString *causeId;
@property(nonatomic, retain) NSString* recipientUri;
@property(nonatomic, retain) CLLocationManager *lm;
@property(nonatomic, retain) UITextField *characterCountLabel;

@property(nonatomic, retain) UIImageView *contactButtonBGImage;
@property(nonatomic, retain) UIImageView *amountButtonBGImage;
@property(nonatomic, retain) UIButton *contactImage;

@property (retain, nonatomic) IBOutlet UITextField *dummyPlaceholder;
@property(nonatomic, retain) UIButton *attachPictureButton;
/*              Button Actions              */
/*  --------------------------------------- */
-(IBAction)pressedChooseCauseButton:(id)sender;
- (IBAction)pressedChooseRecipientButton:(id)sender;
- (IBAction)pressedAmountButton:(id)sender;
- (IBAction)pressedAttachPictureButton:(id)sender;

-(IBAction) bgTouched:(id) sender;
-(IBAction) btnSendRequestClicked:(id) sender;

-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;

@end