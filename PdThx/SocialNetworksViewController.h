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


@interface SocialNetworksViewController : UIModalBaseViewController <FBRequestDelegate, LinkWithFacebookProtocol>
{
    UserService *userService;
}

@property (assign, nonatomic) int numFailedFB;

@end
