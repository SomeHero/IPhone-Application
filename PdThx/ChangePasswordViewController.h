//
//  ChangePasswordViewController.h
//  PdThx
//
//  Created by Edward Mitchell on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIModalBaseViewController.h"
#import "UserService.h"

@interface ChangePasswordViewController : UIModalBaseViewController <UITextFieldDelegate, ChangePasswordCompleteProtocol>
{    
    UserService* userService;
    IBOutlet UITextField *txtOldPassword;
    IBOutlet UITextField *txtNewPassword;
    IBOutlet UITextField *txtConfirmPassword;
}
@property (retain, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (retain, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (retain, nonatomic) IBOutlet UITextField * txtConfirmPassword;


@end