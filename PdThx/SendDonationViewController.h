//
//  SendDonationViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISendMoneyBaseViewController.h"
#import "DonationContactSelectViewController.h"

@interface SendDonationViewController : UISendMoneyBaseViewController
{
    NSMutableArray* contactsArray;
}

-(IBAction) btnDonateClicked:(id)sender;

@end
