//
//  VerifyEmailViewController.h
//  PdThx
//
//  Created by Justin Cheng on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "AddPhoneViewController.h"
#import "PayPoint.h"
#import "PayPointService.h"
#import "GetPayPointProtocol.h"
#import "AddPayPointCompleteProtocol.h"
#import "PayPointService.h"

@interface VerifyEmailViewController :UISetupUserBaseViewController{
    
    IBOutlet UILabel *txtEmailAddress;
    PayPoint* payPoint;
    PayPointService* payPointService;
}

-(IBAction)btnResendCodes;

@property (retain, nonatomic) PayPoint* payPoint;

@end
