//
//  RequestMoneyController.h
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALUnlockPatternView.h"
#import "SNPopupView.h"
#import "ASIHTTPRequest.h"

@interface RequestMoneyController : UIViewController<ALUnlockPatternViewDelegate, UIAlertViewDelegate, SNPopupViewModalDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    SNPopupView		*popup;
    UITableView *autoCompleteTableView;
    ALUnlockPatternView *_viewLock;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txtRecipientUri;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextField *txtComments;
    BOOL _showConfirmation;
    UIButton *button;
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
-(void) setRecipientUri:(NSString*) theRecipientUri;
-(void) setAmount:(NSString*) theAmount;
-(void) setComments:(NSString*) theComments;
-(void) registerUser:(NSString*) userName withMobileNumber:(NSString *) mobileNumber withSecurityPin : (NSString *) securityPin;
-(void) sendMoney:(NSString*) amount toRecipient:(NSString *) recipientUri fromMobileNumber:(NSString *) fromMobileNumber withComment:(NSString *) comments withSecurityPin:(NSString *) securityPin
       fromUserId: (NSString *) userId fromAccount:(NSString *) fromAccount;
-(void) receiveUserRegisterRequest: (ASIHTTPRequest*) request;
- (void) showAlertView:(NSString *)title withMessage: (NSString *) message;
-(void) signOutClicked;
-(BOOL) isValidRecipientUri:(NSString*) recipientUriToTest;
-(BOOL) isValidAmount:(NSString *) amountToTest;

@end
