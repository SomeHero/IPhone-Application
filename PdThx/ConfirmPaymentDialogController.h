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

@interface ConfirmPaymentDialogController : UAModalPanel<ALUnlockPatternViewDelegate>{
	UIView			*v;
	IBOutlet UIView	*viewLoadedFromXib;
    IBOutlet UIButton *btnCancelPayment;
    IBOutlet UIView *viewSecurityPinPlaceholder;
    IBOutlet UILabel *dialogTitle;
    IBOutlet UILabel *dialogHeading;
    ALUnlockPatternView *_viewLock;
    id<SecurityPinCompleteDelegate> _delegate;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property(nonatomic, retain) IBOutlet UIButton *btnCancelPayment;
@property(nonatomic, retain) IBOutlet UIView *viewSecurityPinPlaceholder;
@property(nonatomic, retain) IBOutlet UILabel *dialogTitle;
@property(nonatomic, retain) IBOutlet UILabel *dialogHeading;
@property(nonatomic,assign) id<SecurityPinCompleteDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
-(IBAction) btnCancelClicked:(id) sender;

@end

#pragma mark -
#pragma mark Protocol
@protocol SecurityPinCompleteDelegate<NSObject>
/**
 *  Raised when the UAExampleModalPane         Reference of the ALUnlockPatternView instance which sends the event
 *  @param[in]      code                The code generated with the touch interaction with the grid
 */

-(void) securityPinComplete:(ConfirmPaymentDialogController*) modalPanel
     selectedCode:(NSString*) code;
@end
