//
//  EditProfileViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "UICustomProfileRowViewController.h"
#import "UICustomProfileHeaderViewController.h"
#import "PdThxAppDelegate.h"
#import "Application.h"
#import "ProfileSection.h"
#import "ChoosePictureViewController.h"
#import "UserAttribute.h"
#import "UserAttributeService.h"
#import "UIProfileTextField.h"
#import "UIProfileTextView.h"
#import "SelectModalViewController.h"
#import "ModalSelectProtocol.h"
#import "UIProfileOptionSelectButton.h"

@interface EditProfileViewController : UISetupUserBaseViewController<UITextFieldDelegate, UITableViewDataSource, UIAlertViewDelegate,UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, ModalSelectProtocol>
{
    IBOutlet UITableView* profileTable;
    NSMutableArray* profileSections;
    
    NSMutableArray* attributeValues;
    SelectModalViewController* selectModalViewController;
    NSString* optionSelectAttributeId;
    
    UserAttributeService* userAttributeService;
}

@end
