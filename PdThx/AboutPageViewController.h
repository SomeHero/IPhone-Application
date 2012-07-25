//
//  AboutPageViewController.h
//  PdThx
//
//  Created by Justin Cheng on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignedOutTabBarManager.h"

@interface AboutPageViewController : UIViewController <SignedOutTabBarDelegate>
{
    IBOutlet UIView *viewPanel;
    
}

@property (nonatomic, retain) UIView *viewPanel;
@property (nonatomic, retain) SignedOutTabBarManager *tabBar;

@end
