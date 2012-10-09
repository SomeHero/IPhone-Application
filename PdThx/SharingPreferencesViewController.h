//
//  SharingPreferencesViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "UserConfiguration.h"
#import "UserConfigurationService.h"
#import "UserConfigurationCompleteProtocol.h"

@interface SharingPreferencesViewController : UISetupUserBaseViewController<UserConfigurationCompleteProtocol, UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *notificationOptions;
    NSArray *sections;
    NSMutableArray* configurationKeys;
    UserConfigurationService* userConfigurationService;
    IBOutlet UITableView* tableUserSettings;
}
@property(nonatomic, retain) NSDictionary *notificationOptions;
@property(nonatomic, retain) NSArray *sections;


@end
