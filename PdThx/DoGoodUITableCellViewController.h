//
//  DoGoodUITableCellViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationDetailViewController.h"

@interface DoGoodUITableCellViewController : UITableViewCell
{
    IBOutlet UIButton *contactImage;
    IBOutlet UIButton* btnInfo;
    IBOutlet UILabel *contactName;
    IBOutlet UILabel *contactDetail;
    IBOutlet UIView *overLayView;
    id<DetailInfoButtonClicked> detailInfoButtonClicked;
}

@property(nonatomic, retain) id detailInfoButtonClicked;

@property (nonatomic, retain) UIButton *contactImage;
@property (nonatomic, retain) UILabel *contactName;
@property (nonatomic, retain) UILabel *contactDetail;
@property (nonatomic, retain) UIImage *imgData;

-(IBAction)btnInfoClicked:(id)sender;

@end
