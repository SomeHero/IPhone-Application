//
//  EnterVerificationCodeViewController.h
//  PdThx
//
//  Created by Justin Cheng on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "PayPoint.h"
#import "PayPointService.h"
#import "GetPayPointProtocol.h"
#import "AddPayPointCompleteProtocol.h"
#import "UIModalBaseViewController.h"

@interface EnterVerificationCodeViewController :UIModalBaseViewController<VerifyMobilePayPointProtocol>{
    NSMutableArray* phones;
    IBOutlet UILabel *txtPhoneNumber;
    IBOutlet UITextField *txtVerificationCode;

    PayPoint* payPoint;
    PayPointService* payPointService;
    
    id<VerifyMobilePayPointProtocol> verifyMobilePayPointDelegate;
    
}

@property(retain, nonatomic) PayPoint* payPoint;
@property(retain) id verifyMobilePayPointDelegate;


-(IBAction)btnSubmit;

@end
