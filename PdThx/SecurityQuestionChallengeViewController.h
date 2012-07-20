//
//  SecurityQuestionChallengeViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UIModalBaseViewController.h"
#import "SecurityQuestionService.h"
#import "SecurityQuestionAnsweredProtocol.h"
#import "UserService.h"
#import "PdThxAppDelegate.h"
#import "SignInViewController.h"
#import "SecurityQuestionChallengeProtocol.h"

@interface SecurityQuestionChallengeViewController : UIModalBaseViewController<SecurityQuestionAnsweredProtocol>
{
    IBOutlet UITextView* lblSecurityQuestion;
    IBOutlet UITextField* txtSecurityQuestionAnswer;
    IBOutlet UIButton *btnUnlockAccount;
    SecurityQuestionService* securityQuestionService;
    UserService* userService;
    id<SecurityQuestionChallengeProtocol> securityQuestionChallengeDelegate;
}

@property(nonatomic, retain) User* currUser;
@property(retain) id<SecurityQuestionChallengeProtocol> securityQuestionChallengeDelegate;
@property(nonatomic, retain) IBOutlet UIButton* btnUnlockAccount;

-(IBAction)btnSubmitClicked:(id)sender;

@end
