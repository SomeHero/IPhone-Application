//
//  AddSecurityQuestionViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecurityQuestionInputProtocol.h"

@interface AddSecurityQuestionViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIButton *chooseQuestionButton;
    IBOutlet UITextField *answerField;
    
    IBOutlet UIButton *submitButton;
    IBOutlet UIPickerView *questionPicker;
    id<SecurityQuestionInputProtocol> securityQuestionEnteredDelegate;
    int questionId;
    NSString *questionAnswer;
}

@property (nonatomic, retain) UIButton *chooseQuestionButton;
@property (nonatomic, retain) UITextField *answerField;
@property (nonatomic, assign) int questionId;
@property (nonatomic, retain) NSString *questionAnswer;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIPickerView *questionPicker;
@property (retain) id<SecurityQuestionInputProtocol> securityQuestionEnteredDelegate;


- (IBAction)showQuestionPicker:(id)sender;
- (IBAction)doSubmit:(id)sender;

@end
