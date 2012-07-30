//
//  SelectRecipientCell.m
//  PdThx
//
//  Created by Edward Mitchell on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectRecipientCell.h"

@implementation SelectRecipientCell
@synthesize imgRecipient;
@synthesize contactName;
@synthesize contactDetail;

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
    [imgRecipient release];
    [contactName release];
    [contactDetail release];
    [super dealloc];
}
@end
