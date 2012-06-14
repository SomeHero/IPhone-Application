//
//  UAModalExampleView.h
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "UATitledModalPanel.h"
#import "ALUnlockPatternView.h"

@protocol SecurityPinCompleteDelegate;

@interface SetupSecurityPin : UAModalPanel<ALUnlockPatternViewDelegate>{
	UIView			*v;
	IBOutlet UIView	*viewLoadedFromXib;
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblHeading;
    IBOutlet UIView *viewSecurityPinPlaceholder;
    ALUnlockPatternView *_viewLock;
    id<SecurityPinCompleteDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property(nonatomic, retain) IBOutlet UIView *viewSecurityPinPlaceholder;
@property(nonatomic,assign) id<SecurityPinCompleteDelegate> delegate;
@property(nonatomic, assign) IBOutlet UILabel *lblTitle;
@property(nonatomic, assign) IBOutlet UILabel *lblHeading;

- (id)initWithFrame:(CGRect)frame;

@end

#pragma mark -
#pragma mark Protocol
@protocol SecurityPinCompleteDelegate<NSObject>
/**
 *  Raised when the UAExampleModalPane         Reference of the ALUnlockPatternView instance which sends the event
 *  @param[in]      code                The code generated with the touch interaction with the grid
 */

-(void) securityPinComplete:(SetupSecurityPin*) modalPanel
               selectedCode:(NSString*) code;
@end
