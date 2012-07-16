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

@interface EditProfileViewController : UISetupUserBaseViewController<UITableViewDataSource, UIAlertViewDelegate,UITableViewDelegate>
{
    IBOutlet UITableView* profileTable;
    NSMutableArray* profileSections;
}

@end
