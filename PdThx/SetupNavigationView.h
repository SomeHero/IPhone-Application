//
//  SetupNavigationView.h
//  PdThx
//
//  Created by James Rhodes on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupNavigationView : UIView
{
    IBOutlet UIButton* btnJoinCheck;
    IBOutlet UIButton* btnActivateCheck;
    IBOutlet UIButton* btnPersonalizeCheck;
    IBOutlet UILabel* lblJoin;
    IBOutlet UILabel* lblActivate;
    IBOutlet UILabel* lblPersonalize;
    IBOutlet UILabel* lblEnable;
}

-(void) setActiveState: (NSString*)activeState withJoinComplete: (BOOL) joinComplete whereActivateComplete: (BOOL) activateComplete wherePersonalizeComplete: (BOOL) personalizeComplete whereEnableComplete: (BOOL) enableComplete;
@end
