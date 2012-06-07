//
//  UAModalExampleView.h
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UATitledModalPanel.h"
#import "UAModalPanel.h"
#import "ALUnlockPatternView.h"

@protocol ConfirmSecurityPinCompleteDelegate;

@interface ConfirmSecurityPinDialog : UAModalPanel<ALUnlockPatternViewDelegate>{
	UIView			*v;
	IBOutlet UIView	*viewLoadedFromXib;
    IBOutlet UIView *viewSecurityPinPlaceholder;
    ALUnlockPatternView *_viewLock;
    id<ConfirmSecurityPinCompleteDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property(nonatomic, retain) IBOutlet UIView *viewSecurityPinPlaceholder;
@property(nonatomic,assign) id<ConfirmSecurityPinCompleteDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

@end

#pragma mark -
#pragma mark Protocol
@protocol ConfirmSecurityPinCompleteDelegate<NSObject>
/**
 *  Raised when the UAExampleModalPane         Reference of the ALUnlockPatternView instance which sends the event
 *  @param[in]      code                The code generated with the touch interaction with the grid
 */

-(void) confirmSecurityPinComplete:(ConfirmSecurityPinDialog*) modalPanel
               selectedCode:(NSString*) code;
@end
