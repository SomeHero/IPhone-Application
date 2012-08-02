//
//  VerifyPhoneNumberViewController.h
//  PdThx
//
//  Created by Justin Cheng on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "AddPhoneViewController.h"
#import "PayPoint.h"
#import "PayPointService.h"
#import "GetPayPointProtocol.h"
#import "AddPayPointCompleteProtocol.h"

@interface VerifyPhoneNumberViewController :UISetupUserBaseViewController
{
    IBOutlet UILabel *txtPhoneNumber;
    PayPoint* payPoint;
    PayPointService* payPointService;
}
-(IBAction)btnVerify;
-(IBAction)btnResendCodes;

@property (retain, nonatomic) PayPoint* payPoint;

@end
	