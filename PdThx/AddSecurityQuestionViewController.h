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
#import "GenericModalReturnProtocol.h"
#import "SecurityQuestionSelectOptionViewController.h"

@interface AddSecurityQuestionViewController : UISetupUserBaseViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate ,GenericModalReturnProtocol>
{
    IBOutlet UILabel *questionLabel;
    IBOutlet UITextField *answerField;
    IBOutlet UIButton *submitButton;
    IBOutlet UIButton *chooseQuestionButton;
    
    id<SecurityQuestionInputProtocol> securityQuestionEnteredDelegate;
    
    int questionId;
    NSString *questionAnswer;
    GetSecurityQuestionsService* securityQuestionService;
    NSMutableArray *securityQuestions;
}

@property (nonatomic, retain) UILabel *questionLabel;
@property (nonatomic, retain) UIButton *chooseQuestionButton;

@property (nonatomic, retain) UITextField *answerField;
@property (nonatomic, assign) int questionId;
@property (nonatomic, retain) NSString *questionAnswer;

@property (nonatomic, retain) UIButton *submitButton;

@property (nonatomic, retain) SecurityQuestionSelectOptionViewController* optionSelector;

@property (retain) id<SecurityQuestionInputProtocol> securityQuestionEnteredDelegate;

@property(nonatomic, retain) NSString* navigationTitle;
@property(nonatomic, retain) NSString* headerText;

- (IBAction)doSubmit:(id)sender;

- (IBAction)chooseQuestion:(id)sender;


@end
