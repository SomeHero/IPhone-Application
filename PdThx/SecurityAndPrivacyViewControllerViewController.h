//
//  SecurityAndPrivacyViewControllerViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeSecurityPinController.h"
#import "UIBaseViewController.h"
#import "ChangeSecurityPinController.h"
#import "ChangePasswordViewController.h"

@interface SecurityAndPrivacyViewControllerViewController : UISetupUserBaseViewController   
<UITableViewDataSource, UIAlertViewDelegate,UITableViewDelegate> {
    NSDictionary *profileOptions;
    NSArray *sections;
    UIActivityIndicatorView* spinner;
}
@property(nonatomic, retain) NSDictionary *profileOptions;
@property(nonatomic, retain) NSArray *sections;


@end
