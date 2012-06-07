//
//  ContactTableViewCell.h
//  PdThx
//
//  Created by James Rhodes on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
{
    IBOutlet UIButton *contactImage;
    IBOutlet UILabel *contactName;
    IBOutlet UILabel *contactDetail;
}

@property (nonatomic, retain) UIButton *contactImage;
@property (nonatomic, retain) UILabel *contactName;
@property (nonatomic, retain) UILabel *contactDetail;
@property (nonatomic, retain) UIImage *imgData;

@end
