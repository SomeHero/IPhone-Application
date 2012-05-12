//
//  UITransactionTableViewCell.h
//  PdThx
//
//  Created by James Rhodes on 4/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITransactionTableViewCell : UITableViewCell {
    UILabel *lblRecipientUri;
    UILabel *lblTransactionDate;
    UIImageView *imgTransactionType;
    UILabel *lblAmount;
    UIImageView *imgTransactionStatus;
}
@property(nonatomic,retain)UILabel *lblRecipientUri;
@property(nonatomic,retain)UILabel *lblTransactionDate;
@property(nonatomic,retain)UIImageView *imgTransactionType;
@property(nonatomic, retain) UILabel *lblAmount;
@property(nonatomic, retain) UIImageView *imgTransactionStatus;

@end
