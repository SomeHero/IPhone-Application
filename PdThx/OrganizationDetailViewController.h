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
#import "NonProfitDetail.h"
#import "MerchantServices.h"

@interface OrganizationDetailViewController : UIModalBaseViewController
{
    IBOutlet UILabel* merchantName;
    IBOutlet UIButton* merchantImage;
    IBOutlet UILabel* merchantTagLine;
    IBOutlet UITextView* merchantDescription;
    IBOutlet UIButton* btnSuggestedAmounted;
    IBOutlet UIButton* btnOtherAmount;
    
    NSString* merchantId;
    MerchantServices* merchantServices;
    
    id<DetailInfoButtonClicked> detailInfoButtonClicked;
}

@property(nonatomic, retain) id detailInfoButtonClicked;
@property(nonatomic, retain) NSString* merchantId;

@end
