//
//  WelcomeScreenViewController.h
//  PdThx
//
//  Created by Justin Cheng on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignedOutTabBarManager.h"

@interface WelcomeScreenViewController : UIViewController <SignedOutTabBarDelegate>
{
    IBOutlet UIView *viewPanel;
    
    IBOutlet UIButton *firstTimeUserButton;
    IBOutlet UIButton *currentUserButton;
}

@property (nonatomic, retain) UIView *viewPanel;
@property (nonatomic, retain) UIButton *firstTimeUserButton;
@property (nonatomic, retain) UIButton *currentUserButton;

@property (nonatomic, retain) SignedOutTabBarManager *tabBar;


- (IBAction)firstTimeUserButtonPressed:(id)sender;
- (IBAction)currentUserButtonPressed:(id)sender;

@end
