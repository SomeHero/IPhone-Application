//
//  CreateAccountViewController.h
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupSecurityPin.h"
#import "ConfirmSecurityPinDialog.h"
#import "SetupACHAccountController.h"
#import "ASIHTTPRequest.h"


@interface CreateAccountViewController : UIBaseViewController<UIAlertViewDelegate, SecurityPinCompleteDelegate, ConfirmSecurityPinCompleteDelegate,
        ACHSetupCompleteProtocol, UITextFieldDelegate> {
    IBOutlet UIButton *btnCreateAccount;
    IBOutlet UITextField *txtEmailAddress;
    IBOutlet UITextField *txtMobileNumber;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    SetupSecurityPin *securityPinModal;
    ConfirmSecurityPinDialog *confirmSecurityPinModal;
    UIActivityIndicatorView* spinner;
    NSString* userName;
    NSString* mobileNumber;
    NSString* password;
    NSString* securityPin;
    IBOutlet UIView *viewPanel;
    id<ACHSetupCompleteProtocol> achSetupCompleteDelegate;
    ASIHTTPRequest *requestObj;
}
@property(nonatomic, retain) UIButton *btnCreateAccount;
@property(nonatomic, retain) UITextField *txtEmailAddress;
@property(nonatomic, retain) UITextField *txtMobileNumber;
@property(nonatomic, retain) UITextField *txtPassword;
@property(nonatomic, retain) UITextField *txtConfirmPassword;
@property(nonatomic, assign) UIView* viewPanel;
@property(retain) id achSetupCompleteDelegate;


-(IBAction) bgTouched:(id) sender;
-(IBAction) btnCreateAccountClicked:(id) sender;
-(BOOL) isValidEmailAddress:(NSString*) emailAddressToTest;
-(BOOL)isValidMobileNumber:(NSString *) mobileNumberToTest;
-(BOOL)isValidPassword:(NSString *) passwordToTest;
-(BOOL)doesPasswordMatch:(NSString *) passwordToTest passwordToMatch: (NSString *) confirmPassword;
-(void) showConfirmSecurityPin;
-(void) registerUser:(NSString *) userName withPassword:(NSString *) password withMobileNumber:(NSString *) mobileNumber withSecurityPin : (NSString *) securityPin;

@end
