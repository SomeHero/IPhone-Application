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
#import "EnterVerificationCodeViewController.h"
#import "VerifyMobilePayPointProtocol.h"

@interface PhoneDetailViewController : UISetupUserBaseViewController
    <DeletePayPointDelegate, VerifyMobilePayPointProtocol>
{
    IBOutlet UILabel *txtPhoneNumber;
    IBOutlet UILabel *lblHeader;
    IBOutlet UILabel *txtStatus;
    IBOutlet UIView *ctrlHeader;
    IBOutlet UIView *ctrlButtonsView;
    
    IBOutlet UIView *ctrlHeaderPending;
    IBOutlet UIView *ctrlHeaderVerified;
    
    PayPoint* payPoint;
    PayPointService* payPointService;
    id<DeletePayPointDelegate> deletePayPointComplete;
}

@property(nonatomic, retain) PayPoint* payPoint;
@property(nonatomic, retain) id<DeletePayPointDelegate> deletePayPointComplete;

-(IBAction)btnRemovePayPoint;

@end
