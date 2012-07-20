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
@interface VerifyEmailViewController :UISetupUserBaseViewController<AddPayPointCompleteProtocol, UITableViewDataSource, UITableViewDelegate, GetPayPointProtocol>{
    IBOutlet UILabel *txtEmailAddress;
    NSMutableArray * emailAddresses;
    NSString * emailAddress;
}
-(IBAction)btnVerify;
-(IBAction)btnResendCodes;

@property (retain, nonatomic) NSString *emailAddress;

@end
