//
//  PaystreamOutgoingPaymentViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaystreamDetailBaseViewController.h"
#import "CancelPaymentRequestProtocol.h"
#import "CancelPaymentProtocol.h"
#import "PullableView.h"

@interface PaystreamOutgoingPaymentViewController : PaystreamDetailBaseViewController <PullableViewDelegate> {
    IBOutlet UIButton* btnCancel;
}

@property(nonatomic, retain) UIButton* btnCancel;

-(IBAction) btnCancelClicked:(id) sender;
-(IBAction) btnSenderReminder:(id) sender;

@end
