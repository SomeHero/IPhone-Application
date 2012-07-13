//
//  OrganizationDetailViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIModalBaseViewController.h"
#import "DetailInfoButtonClicked.h"
#import "UIModalBaseViewController.h"

@interface OrganizationDetailViewController : UIModalBaseViewController
{
    id<DetailInfoButtonClicked> detailInfoButtonClicked;
}

@property(nonatomic, retain) id detailInfoButtonClicked;

@end
