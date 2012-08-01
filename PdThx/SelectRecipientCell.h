//
//  SelectRecipientCell.h
//  PdThx
//
//  Created by Edward Mitchell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectRecipientCell : UITableViewCell
{
    IBOutlet UIButton *imgRecipient;
    IBOutlet UILabel *contactName;
    IBOutlet UILabel *contactDetail;
}
@property (retain, nonatomic) UIButton *imgRecipient;
@property (retain, nonatomic) UILabel *contactName;
@property (retain, nonatomic) UILabel *contactDetail;

@end
