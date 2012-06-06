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
    IBOutlet UIButton *transactionImageButton;
    IBOutlet UILabel *transactionStatus;
    IBOutlet UILabel *transactionRecipient;
    IBOutlet UILabel *transactionAmount;
    IBOutlet UILabel *transactionDate;
    IBOutlet UIImageView *transactionStatusImage;
    IBOutlet UILabel *lblComments;
    IBOutlet UILabel *lblTransactionDirection;
}

@property (nonatomic, retain) UIButton *transactionImageButton;
@property (nonatomic, retain) UILabel *transactionStatus;
@property (nonatomic, retain) UILabel *transactionType;
@property (nonatomic, retain) UILabel *transactionRecipient;
@property (nonatomic, retain) UILabel *transactionAmount;
@property (nonatomic, retain) UILabel *transactionDate;
@property (nonatomic, retain) UILabel *lblComments;
@property (nonatomic, retain) UILabel *lblTransactionDirection;

@end