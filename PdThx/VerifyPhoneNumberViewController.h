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
@interface VerifyPhoneNumberViewController :UISetupUserBaseViewController<AddPayPointCompleteProtocol, UITableViewDataSource, UITableViewDelegate, GetPayPointProtocol>{

    IBOutlet UILabel *txtPhoneNumber;
    NSMutableArray* phones;
    NSString* phoneNumber;
}
-(IBAction)btnVerify;
-(IBAction)btnResendCodes;

@property (retain, nonatomic) NSString* phoneNumber;
@end
	