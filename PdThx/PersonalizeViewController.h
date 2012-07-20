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
#import "PersonalizeUserCompleteProtocol.h"
#import "UserService.h"
#import "ChooseMemberImageProtocol.h"
#import "SetupNavigationView.h"

#import <QuartzCore/QuartzCore.h>

@interface PersonalizeViewController : UISetupUserBaseViewController<PersonalizeUserCompleteProtocol, ChooseMemberImageProtocol, UITextFieldDelegate>
{
    IBOutlet UIView *navBar;
    IBOutlet UIButton *userImageButton;
    IBOutlet UITextField *firstNameField;
    IBOutlet UITextField *lastNameField;
    IBOutlet UIButton *saveContinueButton;
    IBOutlet UIView* viewPanel;
    ASIHTTPRequest *requestObj;
    UserService* userService;
}

@property (nonatomic, retain) UIButton *userImageButton;
@property (nonatomic, retain) UITextField *firstNameField;
@property (nonatomic, retain) UITextField *lastNameField;
@property (nonatomic, retain) UIButton *saveContinueButton;

- (IBAction)pressedSaveContinue:(id)sender;
-(IBAction) bgTouched:(id) sender;
-(IBAction) chooseImageClicked:(id) sender;

@end