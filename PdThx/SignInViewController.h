//
//  SignInViewController.h
//  PdThx
//
//  Created by James Rhodes on 4/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"
#import "SignInCompleteProtocol.h"
#import "ACHSetupCompleteProtocol.h"

@interface SignInViewController : UIBaseViewController<ACHSetupCompleteProtocol, UITextFieldDelegate>{
    IBOutlet UITextField *txtEmailAddress;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIView *viewPanel;
    id<SignInCompleteProtocol> signInCompleteDelegate;
    id<ACHSetupCompleteProtocol> achSetupCompleteDelegate;
}
@property(nonatomic, retain) UITextField *txtEmailAddress;
@property(nonatomic, retain) UITextField *txtPassword;
@property(retain) id signInCompleteDelegate;
@property(retain) id achSetupCompleteDelegate;
@property(nonatomic, assign) UIView* viewPanel;

-(IBAction) bgTouched:(id) sender;
-(IBAction) btnSignInClicked:(id) sender;
-(IBAction) btnCreateAnAccountClicked:(id) sender;
-(BOOL)isValidUserName:(NSString *) userNameToTest;
-(BOOL)isValidPassword:(NSString *) passwordToTest;
-(void) signInUser:(NSString*) myUserName withPassword:(NSString *) myPassword;

@end
