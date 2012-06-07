//
//  PaystreamIncomingRequestViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaystreamBaseViewController.h"

@interface PaystreamIncomingRequestViewController : PaystreamBaseViewController {
    IBOutlet UIButton* btnAccept;
    IBOutlet UIButton* btnCancel;
}

@property(nonatomic, retain) UIButton* btnAccept;
@property(nonatomic, retain) UIButton* btnCancel;

-(IBAction) btnAcceptClicked:(id) sender;

@end
