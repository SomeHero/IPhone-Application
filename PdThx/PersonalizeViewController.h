//
//  PersonalizeViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "ASIHTTPRequest.h"

@interface PersonalizeViewController : UISetupUserBaseViewController
{
    IBOutlet UIButton *userImageButton;
    IBOutlet UITextField *firstNameField;
    IBOutlet UITextField *lastNameField;
    ASIHTTPRequest *requestObj;
    IBOutlet UIButton *saveContinueButton;
    
}

@property (nonatomic, retain) UIButton *userImageButton;
@property (nonatomic, retain) UITextField *firstNameField;
@property (nonatomic, retain) UITextField *lastNameField;
@property (nonatomic, retain) UIButton *saveContinueButton;


- (IBAction)pressedSaveContinue:(id)sender;

@end