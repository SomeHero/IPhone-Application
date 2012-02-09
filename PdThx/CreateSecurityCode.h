//
//  CreateSecurityCode.h
//  PdThx
//
//  Created by James Rhodes on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALUnlockPatternView.h"

@interface CreateSecurityCode : UIViewController<ALUnlockPatternViewDelegate> {
    ALUnlockPatternView *_viewLock;  
    NSString *recipientMobileNumber;
    NSString *amount;
    NSString *comment;
}
@property(nonatomic, retain) NSString* recipientMobileNumber;
@property(nonatomic, retain) NSString* amount;
@property(nonatomic, retain) NSString* comment;

-(void) setSecurityPin:(NSString *) securityPin forUser:(NSString *) userId;

@end
