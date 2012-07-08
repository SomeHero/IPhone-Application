//
//  NotificationConfigurationViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "UserConfiguration.h"
#import "UserConfigurationService.h"

@interface NotificationConfigurationViewController : UISetupUserBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *notificationOptions;
    NSArray *sections;
    NSMutableArray* configurationKeys;
}
@property(nonatomic, retain) NSDictionary *notificationOptions;
@property(nonatomic, retain) NSArray *sections;

@end
