//
//  MeCodeSetupViewController.h
//  PdThx
//
//  Created by Justin Cheng on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeCodeService.h"
#import "UIBaseViewController.h"
@interface MeCodeSetupViewController : UIBaseViewController <UITextFieldDelegate, MeCodeCreateCompleteProtocol>
{
    IBOutlet UITextField *MeCodeField;
    IBOutlet UIButton *SubmitButton;
    MeCodeService *meCodeService;
}
@property (nonatomic, retain) UITextField *MeCodeField;
@property (nonatomic, retain) UIButton *SubmitButton;
@property (nonatomic, retain) MeCodeService *meCodeService;

- (IBAction)SubmitButtonAction:(id)sender;
- (IBAction)meCodeChange:(id)sender;

@end
