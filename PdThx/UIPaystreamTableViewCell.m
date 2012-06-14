//
//  UIPaystreamTableViewCellCell.m
//  PdThx
//
//  Created by James Rhodes on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIPaystreamTableViewCell.h"

@implementation UIPaystreamTableViewCell

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@synthesize transactionAmount, transactionDate,transactionRecipient, transactionStatus,transactionType, transactionImageButton;
@synthesize lblComments;
@synthesize lblTransactionDirection;
@synthesize overlayView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [transactionImageButton release];
    [transactionStatus release];
    [transactionType release];
    [transactionRecipient release];
    [transactionAmount release];
    [transactionDate release];
    [transactionStatusImage release];
    [lblComments release];
    [lblTransactionDirection release];
    [overlayView release];
    
    [super dealloc];
}
@end
