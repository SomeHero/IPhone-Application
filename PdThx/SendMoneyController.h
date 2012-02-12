//
//  SendMoneyController.h
//  PdThx
//
//  Created by James Rhodes on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALUnlockPatternView.h"
#import "SNPopupView.h"
#import "ASIHTTPRequest.h"

@interface SendMoneyController : UIViewController<ALUnlockPatternViewDelegate, UIAlertViewDelegate, SNPopupViewModalDelegate, UITableViewDelegate, UITextFieldDelegate> {
    SNPopupView		*popup;
    UITableView *autoCompleteTableView;
    ALUnlockPatternView *_viewLock;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txtRecipientUri;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextField *txtComments;
    UIButton *button;
    BOOL _showConfirmation;
    int _amountCharCount;
    NSMutableArray *autoCompleteArray; 
    NSMutableArray *allResults;
}
@property(nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic, retain) UITextField *txtRecipientUri;
@property(nonatomic, retain) UITextField *txtAmount;
@property(nonatomic, retain) UITextField *txtComments;

-(IBAction) bgTouched:(id) sender;
-(BOOL) showConfirmation;
-(void) setShowConfirmation:(BOOL)showConfirmation;
-(void) registerUser:(NSString*) userName withMobileNumber:(NSString *) mobileNumber withSecurityPin : (NSString *) securityPin;
-(void) sendMoney:(NSString*) amount toRecipient:(NSString *) recipientUri fromMobileNumber:(NSString *) fromMobileNumber withComment:(NSString *) comments withSecurityPin:(NSString *) securityPin
       fromUserId: (NSString *) userId fromAccount:(NSString *) fromAccount;
-(void) receiveUserRegisterRequest: (ASIHTTPRequest*) request;
- (void) showAlertView:(NSString *)title withMessage: (NSString *) message;
-(void) signOutClicked;
-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;
@end
