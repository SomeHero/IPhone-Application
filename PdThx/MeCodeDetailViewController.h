//
//  MeCodeDetailViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "PayPoint.h"
#import "PayPointService.h"
#import "PhoneNumberFormatting.h"
#import "PdThxAppDelegate.h"
#import "DeletePayPointDelegate.h"
#import "MeCodeDetailViewController.h"

@interface MeCodeDetailViewController : UISetupUserBaseViewController
<DeletePayPointDelegate>
{
    IBOutlet UILabel *txtMeCode;
    PayPoint* payPoint;
    PayPointService* payPointService;
    id<DeletePayPointDelegate> deletePayPointComplete;
}

@property(nonatomic, retain) PayPoint* payPoint;
@property(nonatomic, retain) id<DeletePayPointDelegate> deletePayPointComplete;

-(IBAction)btnRemovePayPoint;

@end
