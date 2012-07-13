//
//  RequestMoneyController.h
//  PdThx
//
//  Created by James Rhodes on 1/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRequestMoneyViewController.h"
#import "HBTabBarManager.h"

@interface RequestMoneyController : UIRequestMoneyViewController <HBTabBarDelegate> {
}


@property (nonatomic, retain) HBTabBarManager *tabBar;

@end
