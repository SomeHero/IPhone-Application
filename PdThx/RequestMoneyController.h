//
//  RequestMoneyController.h
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBTabBarManager.h"
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

@interface RequestMoneyController : UIBaseViewController<HBTabBarDelegate, UIAlertViewDelegate, UITextFieldDelegate, ContactSelectChosenProtocol, CLLocationManagerDelegate, AmountSelectChosenProtocol, UIImagePickerControllerDelegate, UITextViewDelegate, CustomAlertViewProtocol> 
{
    
    IBOutlet UIView *viewPanel;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextView *txtComments;
    
    IBOutlet UIButton *btnSendRequest;
    
    User* user;
    NSString* recipientUri;
    NSString* amount;
    NSString* comments;
    
    NSMutableArray *autoCompleteArray;
    NSMutableArray *allResults;
    
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
    
    IBOutlet UIImageView *contactButtonBGImage;
    IBOutlet UIImageView *amountButtonBGImage;
    
    IBOutlet UIButton *attachPictureButton;
    IBOutlet UITextField *characterCountLabel;
    
    
}
@property (nonatomic, retain) HBTabBarManager *tabBar;
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
@property(nonatomic, retain) UITextField *characterCountLabel;

@property(nonatomic, retain) UIImageView *contactButtonBGImage;
@property(nonatomic, retain) UIImageView *amountButtonBGImage;

@property(nonatomic, retain) UIButton *attachPictureButton;
/*              Button Actions              */
/*  --------------------------------------- */
- (IBAction)pressedChooseRecipientButton:(id)sender;
- (IBAction)pressedAmountButton:(id)sender;
- (IBAction)pressedAttachPictureButton:(id)sender;

-(IBAction) bgTouched:(id) sender;
-(IBAction) btnSendRequestClicked:(id) sender;

-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;

@end