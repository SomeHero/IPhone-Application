//
//  PhoneDetailViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "PayPoint.h"
#import "PayPointService.h"
#import "PhoneNumberFormatting.h"
#import "PdThxAppDelegate.h"
#import "DeletePayPointDelegate.h"

@interface PhoneDetailViewController : UISetupUserBaseViewController
    <DeletePayPointDelegate>
{
    IBOutlet UILabel *txtPhoneNumber;
    PayPoint* payPoint;
    PayPointService* payPointService;
    id<DeletePayPointDelegate> deletePayPointComplete;
}

@property(nonatomic, retain) PayPoint* payPoint;
@property(nonatomic, retain) id<DeletePayPointDelegate> deletePayPointComplete;

-(IBAction)btnRemovePayPoint;

@end
