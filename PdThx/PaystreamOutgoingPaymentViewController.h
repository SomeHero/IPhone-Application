//
//  PaystreamOutgoingPaymentViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaystreamBaseViewController.h"

@interface PaystreamOutgoingPaymentViewController : PaystreamBaseViewController {
    IBOutlet UIButton* btnCancel;
}

@property(nonatomic, retain) UIButton* btnCancel;

@end
