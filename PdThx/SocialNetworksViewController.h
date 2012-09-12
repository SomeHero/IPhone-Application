//
//  SocialNetworksViewController.h
//  PdThx
//
//  Created by Edward Mitchell on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"
#import "UserService.h"

#import "LinkWithFacebookProtocol.h"
#import "CustomAlertViewProtocol.h"


@interface SocialNetworksViewController : UISetupUserBaseViewController <FBRequestDelegate, LinkWithFacebookProtocol, UITableViewDataSource, UITableViewDelegate, CustomAlertViewProtocol>
{
    UserService *userService;
    IBOutlet UITableView* tableView;
    id FacebookResult;
}

@property (assign, nonatomic) int numFailedFB;
@property(nonatomic, retain) NSDictionary *profileOptions;
@property(nonatomic, retain) NSArray *sections;
@property (assign) id FacebookResult;

@end
