//
//  SecurityPinSwipeController.h
//  PdThx
//
//  Created by James Rhodes on 6/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAModalPanel.h"
#import "ALUnlockPatternView.h"

@interface SecurityPinSwipeController : UAModalPanel<ALUnlockPatternViewDelegate> {
    
	IBOutlet UIView	*viewLoadedFromXib;
    ALUnlockPatternView* _viewLock;
    //id<ConfirmSecurityPinCompleteDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;

- (id)initWithFrame:(CGRect)frame;

@end
