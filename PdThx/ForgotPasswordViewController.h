//
//  ForgotPasswordViewController.h
//  PdThx
//
//  Created by Edward Mitchell on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIModalBaseViewController.h"
#import "UserService.h"

@interface ForgotPasswordViewController : UIModalBaseViewController <UITextFieldDelegate, ForgotPasswordCompleteProtocol>
{
    IBOutlet UIButton* btnSubmitForgotPassword;
    IBOutlet UITextField* txtEmailAddress;
    UserService *userService;
}

@property (retain, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (retain, nonatomic) IBOutlet UIButton *btnSubmitForgotPassword;
@end
