//
//  SetupNavigationView.m
//  PdThx
//
//  Created by James Rhodes on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SetupNavigationView.h"

@implementation SetupNavigationView

-(void) loadViewsFromBundle {
	NSString *class_name = NSStringFromClass([self class]);
	NSLog(@"Loading bundle: %@", class_name);
	UIView *mainSubView = [[[NSBundle mainBundle] loadNibNamed:class_name owner:self options:nil] lastObject];
	[self addSubview:mainSubView];
}

-(id) initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if(self) {
		[self loadViewsFromBundle];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self loadViewsFromBundle];
        // Initialization code.
        [lblJoin setTextColor:[UIColor colorWithRed:118/256.0 green:119/256.0 blue:122/256.0 alpha:1]];
        [lblActivate setTextColor:[UIColor colorWithRed:118/256.0 green:119/256.0 blue:122/256.0 alpha:1]];
        [lblPersonalize setTextColor:[UIColor colorWithRed:118/256.0 green:119/256.0 blue:122/256.0 alpha:1]];
        [lblEnable setTextColor:[UIColor colorWithRed:118/256.0 green:119/256.0 blue:122/256.0 alpha:1]];
        
    }
    return self;
}

-(void) setActiveState: (NSString*)activeState withJoinComplete: (BOOL) joinComplete whereActivateComplete: (BOOL) activateComplete wherePersonalizeComplete: (BOOL) personalizeComplete whereEnableComplete: (BOOL) enableComplete
{
    if(!joinComplete) {
        [btnJoinCheck setHidden:YES];
        if([activeState isEqualToString: @"Join"])
        {
            [lblJoin setTextColor: [UIColor colorWithRed:61/256.0 green:147/256.0 blue:76/256.0 alpha:1]];
        }
    }
    if(!activateComplete)
    {
        [btnActivateCheck setHidden:YES];
        if([activeState isEqualToString: @"Activate"])
        {
            [lblActivate setTextColor: [UIColor colorWithRed:61/256.0 green:147/256.0 blue:76/256.0 alpha:1]];
        }
    }
    if(!personalizeComplete)
    {
        [btnPersonalizeCheck setHidden:YES];
        if([activeState isEqualToString: @"Personalize"])
        {
            [lblPersonalize setTextColor: [UIColor colorWithRed:61/256.0 green:147/256.0 blue:76/256.0 alpha:1]];
        }
    }
    if([activeState isEqualToString: @"Enable"])
    {
        [lblEnable setTextColor: [UIColor colorWithRed:61/256.0 green:147/256.0 blue:76/256.0 alpha:1]];
    }
}


@end
