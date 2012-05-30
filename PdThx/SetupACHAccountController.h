//
//  SetupACHAccountController.h
//  PdThx
//
//  Created by James Rhodes on 4/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACHSetupCompleteProtocol.h"
#import "UIBaseViewController.h"
#import "UserSetupACHAccount.h"
#import "UserSetupACHAccountComplete.h"

@interface SetupACHAccountController : UIBaseViewController<UITextFieldDelegate> {
    IBOutlet UITextField* txtNameOnAccount;
    IBOutlet UITextField* txtRoutingNumber;
    IBOutlet UITextField* txtAccountNumber;
    IBOutlet UITextField* txtConfirmAccountNumber;
    IBOutlet UIButton* btnSetupACHAccount;
    UserSetupACHAccount* userSetupACHAccountService;
    UIAlertView * skipBankAlert;
    IBOutlet UIBarButtonItem *skipButton;
}

@property(nonatomic, retain) UITextField* txtNameOnAccount;
@property(nonatomic, retain) UITextField* txtRoutingNumber;
@property(nonatomic, retain) UITextField* txtAccountNumber;
@property(nonatomic, retain) UITextField* txtConfirmAccountNumber;
@property(retain) id<UserSetupACHAccountComplete> userSetupACHAccountComplete;
@property (retain) id<ACHSetupCompleteProtocol> achSetupCompleteDelegate;

@property(nonatomic,retain) UIAlertView* skipBankAlert;

-(IBAction) bgTouched:(id) sender;

-(IBAction) btnSetupACHAccountClicked:(id) sender;
-(void) setupACHAccount:(NSString *) accountNumber forUser:(NSString *) userId withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType;


- (IBAction)doSkip:(id)sender;

-(BOOL)isValidNameOnAccount:(NSString *) nameToTest;
-(BOOL)isValidRoutingNumber:(NSString *) routingNumberToTest;
-(BOOL)isValidAccountNumber:(NSString *) accountNumberToTest;
-(BOOL)doesAccountNumberMatch:(NSString *) accountNumberToTest doesMatch:(NSString *) confirmationNumber;

@end
