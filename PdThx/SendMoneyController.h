//
//  SendMoneyController.h
//  PdThx
//
//  Created by James Rhodes on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISendMoneyBaseViewController.h"
#import "HBTabBarManager.h"

@interface SendMoneyController : UISendMoneyBaseViewController <HBTabBarDelegate> {
}


@property (nonatomic, retain) HBTabBarManager *tabBar;

@end
