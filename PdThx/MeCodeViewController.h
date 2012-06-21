//
//  MeCodeViewController.h
//  PdThx
//
//  Created by Justin Cheng on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeCodeService.h"
@interface MeCodeViewController : UIViewController<UITextFieldDelegate, MeCodeCreateCompleteProtocol>
{
    IBOutlet UITextField *MeCodeField;
    IBOutlet UIButton *CheckAvailibilityButton;
    IBOutlet UITextField *CreateDateField;
    IBOutlet UITextField *IsApprovedStatus;
    IBOutlet UIButton *SubmitButton;
    MeCodeService *meCodeService;
}
@property (nonatomic, retain) UITextField *MeCodeField;
@property (nonatomic, retain) UIButton *CheckAvailibilityButton;
@property(nonatomic, retain) UITextField *CreateDateField;
@property(nonatomic, retain)
UITextField *IsApprovedStatus;
@property(nonatomic, retain) UIButton *Submitbutton;
- (IBAction)SubmitButtonAction:(id)sender;
- (IBAction)CheckAvailibilityButtonAction:(id)sender;
- (IBAction)meCodeChange:(id)sender;

@end
