//
//  AddSecurityQuestionViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "SecurityQuestionInputProtocol.h"
#import "GetSecurityQuestionsService.h"
#import "GetSecurityQuestionsProtocol.h"

@interface AddSecurityQuestionViewController : UISetupUserBaseViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, GetSecurityQuestionsProtocol>
{
    IBOutlet UITextField *answerField;
    IBOutlet UIButton *submitButton;
    IBOutlet UIPickerView *questionPicker;
    id<SecurityQuestionInputProtocol> securityQuestionEnteredDelegate;
    int questionId;
    NSString *questionAnswer;
    GetSecurityQuestionsService* securityQuestionService;
    NSMutableArray *securityQuestions;
}

@property (nonatomic, retain) UITextField *answerField;
@property (nonatomic, assign) int questionId;
@property (nonatomic, retain) NSString *questionAnswer;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIPickerView *questionPicker;
@property (retain) id<SecurityQuestionInputProtocol> securityQuestionEnteredDelegate;
@property(nonatomic, retain) NSString* navigationTitle;
@property(nonatomic, retain) NSString* headerText;

- (IBAction)doSubmit:(id)sender;
-(IBAction) bgTouched:(id) sender;

@end
