//
//  DoGoodViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"
#import "SendDonationViewController.h"
#import "AcceptPledgeViewController.h"

@interface DoGoodViewController : UIBaseViewController
{
    IBOutlet UIView *viewPanel;
    
}

-(IBAction)btnDonateClicked:(id)sender;
-(IBAction)btnAcceptPledgeClicked:(id)sender;

@end
