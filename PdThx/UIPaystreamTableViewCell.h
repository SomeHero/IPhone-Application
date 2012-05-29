//
//  UIPaystreamTableViewCellCell.h
//  PdThx
//
//  Created by James Rhodes on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPaystreamTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *transactionImage;
    IBOutlet UILabel *transactionStatus;
    IBOutlet UILabel *transactionRecipient;
    IBOutlet UILabel *transactionAmount;
    IBOutlet UILabel *transactionDate;
    IBOutlet UIImageView *transactionStatusImage;
}

@property (nonatomic, retain) UIImageView *transactionImage;
@property (nonatomic, retain) UILabel *transactionStatus;
@property (nonatomic, retain) UILabel *transactionType;
@property (nonatomic, retain) UILabel *transactionRecipient;
@property (nonatomic, retain) UILabel *transactionAmount;
@property (nonatomic, retain) UILabel *transactionDate;

@end