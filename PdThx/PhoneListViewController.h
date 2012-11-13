//
//  PhoneListViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "AddPhoneViewController.h"
#import "PayPoint.h"
#import "PayPointService.h"
#import "GetPayPointProtocol.h"
#import "AddPayPointCompleteProtocol.h"
#import "PhoneDetailViewController.h"
#import "PhoneNumberFormatting.h"
#import "DeletePayPointDelegate.h"
#import "EnterVerificationCodeViewController.h"

@interface PhoneListViewController : UISetupUserBaseViewController<AddPayPointCompleteProtocol, DeletePayPointDelegate, UITableViewDataSource, UITableViewDelegate, GetPayPointProtocol, VerifyMobilePayPointProtocol, CustomAlertViewProtocol>
{
    IBOutlet UITableView* payPointTable;
    
    PayPoint* payPoint;
    PayPointService* payPointService;
    NSMutableArray* phones;
    
    bool newPayPointAdded;
    NSString* newPayPointId;
}

@property(nonatomic, retain) NSString* newPayPointId;

@end
