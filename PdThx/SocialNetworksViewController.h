//
//  SocialNetworksViewController.h
//  PdThx
//
//  Created by Edward Mitchell on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"
#import "UserService.h"
#import "Facebook.h"
#import "LinkWithFacebookProtocol.h"


@interface SocialNetworksViewController : UISetupUserBaseViewController <FBRequestDelegate, LinkWithFacebookProtocol, UITableViewDataSource, UITableViewDelegate>
{
    UserService *userService;
    IBOutlet UITableView* tableView;
}

@property (assign, nonatomic) int numFailedFB;
@property(nonatomic, retain) NSDictionary *profileOptions;
@property(nonatomic, retain) NSArray *sections;

@end
