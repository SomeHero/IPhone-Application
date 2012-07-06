//
//  MeCodeListViewControllerViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import "AddMeCodeViewController.h"
#import "PayPoint.h"
#import "PayPointService.h"
#import "GetPayPointProtocol.h"
#import "User.h"

@interface MeCodeListViewController : UISetupUserBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView* payPointTable;
    
    NSMutableArray* meCodes;
}

@end
