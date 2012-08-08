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
#import "SetContactAndAmountProtocol.h"
#import "UICustomSetContactAndAmountButton.h"
#import "SetContactProtocol.h"
#import "UICustomSetContactButton.h"

@interface OrganizationDetailViewController : UIModalBaseViewController
{
    Contact* contact;
    IBOutlet UILabel* merchantName;
    IBOutlet UIButton* merchantImage;
    IBOutlet UILabel* merchantTagLine;
    IBOutlet UITextView* merchantDescription;
    IBOutlet UICustomSetContactAndAmountButton* btnSuggestedAmounted;
    IBOutlet UICustomSetContactButton* btnOtherAmount;
    
    NSString* merchantId;
    MerchantServices* merchantServices;
    
    id<SetContactAndAmountProtocol> didSetContactAndAmount;
    id<SetContactProtocol> didSetContact;
    id<DetailInfoButtonClicked> detailInfoButtonClicked;
}

@property(assign) id didSetContactAndAmount;
@property(assign) id detailInfoButtonClicked;
@property(assign) id didSetContact;

@property(nonatomic, retain) Contact* contact;

@end
