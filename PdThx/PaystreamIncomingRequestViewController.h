//
//  PaystreamIncomingRequestViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaystreamBaseViewController.h"
#import "ConfirmPaymentDialogController.h"
#import "AcceptPaymentRequestProtocol.h"
#import "RejectPaymentRequestProtocol.h"
#import "CancelPaymentRequestProtocol.h"
#import "CancelPaymentProtocol.h"

@interface PaystreamIncomingRequestViewController : PaystreamBaseViewController<SecurityPinCompleteDelegate, AcceptPaymentRequestProtocol, RejectPaymentRequestProtocol> {
    IBOutlet UIButton* btnAccept;
    IBOutlet UIButton* btnCancel;
    ConfirmPaymentDialogController *securityPinModalPanel;
}

@property(nonatomic, retain) UIButton* btnAccept;
@property(nonatomic, retain) UIButton* btnCancel;

-(IBAction) btnAcceptClicked:(id) sender;
-(IBAction) btnRejectClicked:(id) sender;

@end