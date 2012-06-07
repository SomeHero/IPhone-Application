//
//  MECodeSetupViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MECodeSetupViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *meCodeField;
    IBOutlet UITextField *createDateField;
    IBOutlet UITextField *approvedField;
    
    IBOutlet UIButton *checkAvailButton;
    IBOutlet UIButton *submitButton;
}

@property (nonatomic,retain) UITextField *meCodeField;
@property (nonatomic,retain) UITextField *createDateField;
@property (nonatomic,retain) UITextField *approvedField;
@property (nonatomic,retain) UIButton *checkAvailButton;
@property (nonatomic,retain) UIButton *submitButton;

- (IBAction)clickedCheckAvailButton:(id)sender;

- (IBAction)clickedSubmitButton:(id)sender;
- (IBAction)meCodeChanged:(id)sender;

@end