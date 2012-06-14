//
//  PaystreamOutgoingPaymentViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaystreamBaseViewController.h"
#import "CancelPaymentRequestProtocol.h"
#import "CancelPaymentProtocol.h"

@interface PaystreamOutgoingPaymentViewController : PaystreamBaseViewController< CancelPaymentProtocol> {
    IBOutlet UIButton* btnCancel;
}

@property(nonatomic, retain) UIButton* btnCancel;

-(IBAction) btnCancelClicked:(id) sender;

@end
