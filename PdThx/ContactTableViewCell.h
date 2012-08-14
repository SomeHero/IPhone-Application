//
//  ContactTableViewCell.h
//  PdThx
//
//  Created by James Rhodes on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DetailInfoButtonClicked.h"
#import "UICustomDetailButton.h"

@interface ContactTableViewCell : UITableViewCell
{
    IBOutlet UIButton *contactImage;
    IBOutlet UILabel *contactNameField;
    CATextLayer* contactNameLayer;
    IBOutlet UILabel *contactDetail;
    IBOutlet UICustomDetailButton* btnInfo;
    NSString* merchantId;
    
    id<DetailInfoButtonClicked> detailInfoButtonClicked;
}
@property(nonatomic, retain) id detailInfoButtonClicked;

@property (nonatomic, retain) UIButton *contactImage;
@property (nonatomic, retain) UILabel *contactNameField;
@property (nonatomic, retain) UILabel *contactDetail;
@property (nonatomic, retain) UIImage *imgData;
@property (nonatomic, retain) CATextLayer *contactNameLayer;
@property(nonatomic, retain) UICustomDetailButton* btnInfo;
@property(nonatomic, retain) NSString* merchantId;

-(IBAction)btnInfoClicked:(id)sender;

@end
