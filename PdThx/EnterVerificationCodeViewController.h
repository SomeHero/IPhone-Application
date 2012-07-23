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
@interface EnterVerificationCodeViewController :UISetupUserBaseViewController<AddPayPointCompleteProtocol, UITableViewDataSource, UITableViewDelegate, GetPayPointProtocol>{
       NSMutableArray* phones;
    IBOutlet UILabel *txtPhoneNumber;
    IBOutlet UITextField *verificatoinCode;
    NSString* phoneNumber;

}
@property (retain, nonatomic) NSString* phoneNumber;
-(IBAction)btnSubmit;
@end
