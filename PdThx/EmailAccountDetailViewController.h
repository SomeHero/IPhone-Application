//
//  EmailAccountDetailViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPoint.h"
#import "PayPointService.h"
#import "PdThxAppDelegate.h"
#import "DeletePayPointDelegate.h"
#import "ResendVerificationLinkProtocol.h"

@interface EmailAccountDetailViewController : UISetupUserBaseViewController<DeletePayPointDelegate, ResendVerificationLinkProtocol, CustomAlertViewProtocol>
{
    PayPoint* payPoint;
    PayPointService* payPointService;
    id<DeletePayPointDelegate> deletePayPointComplete;
    id<ResendVerificationLinkProtocol> resendVerificationLinkDelegate;
    
    IBOutlet UILabel *txtEmailAddress;
    IBOutlet UILabel *txtStatus;
    IBOutlet UIView *ctrlHeader;
    IBOutlet UIView *ctrlButtonsView;
    
    IBOutlet UIView *ctrlHeaderPending;
    IBOutlet UIView *ctrlHeaderVerified;
}

@property(nonatomic, retain) PayPoint* payPoint;
@property(nonatomic, retain) id<DeletePayPointDelegate> deletePayPointComplete;
@property(nonatomic, retain) id<ResendVerificationLinkProtocol> resendVerifciationLinkDelegate;

@end
