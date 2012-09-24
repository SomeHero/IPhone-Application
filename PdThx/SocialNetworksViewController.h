//
//  SocialNetworksViewController.h
//  PdThx
//
//  Created by Edward Mitchell on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"
#import "UserService.h"

#import "CustomAlertViewProtocol.h"

#import "FacebookLinkProtocol.h"
#import "FacebookUnlinkProtocol.h"


@interface SocialNetworksViewController : UISetupUserBaseViewController <UITableViewDataSource, UITableViewDelegate, CustomAlertViewProtocol, FacebookLinkProtocol, FacebookUnlinkProtocol>
{
    UserService *userService;
    IBOutlet UITableView* tableView;
    id FacebookResult;
}

@property (nonatomic, retain) PdThxAppDelegate*appDelegate;
@property (assign, nonatomic) int numFailedFB;
@property(nonatomic, retain) NSDictionary *profileOptions;
@property(nonatomic, retain) NSArray *sections;
@property (assign) id FacebookResult;

@end
