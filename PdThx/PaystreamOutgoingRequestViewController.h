//
//  PaystreamOutgoingRequestViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaystreamDetailBaseViewController.h"
#import "CancelPaymentRequestProtocol.h"
#import "CancelPaymentProtocol.h"

@interface PaystreamOutgoingRequestViewController : PaystreamDetailBaseViewController<CancelPaymentRequestProtocol> {
    IBOutlet UIButton* btnCancel;
    
}

@property(nonatomic, retain) UIButton* btnCancel;

-(IBAction) btnCancelClicked:(id) sender;

@end
