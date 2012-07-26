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

    IBOutlet UIWebView *videoView;
    IBOutlet UIButton *toMobileWeb;

}


- (IBAction)linkToMobileWeb:(id)sender;
@property (nonatomic, retain) UIView *viewPanel;
@property (retain, nonatomic) IBOutlet UIWebView *videoView;
@property (nonatomic, retain) SignedOutTabBarManager *tabBar;

@end
