//
//  UIPaystreamNoItemsFoundCell.m
//  PdThx
//
//  Created by Christopher Magee on 10/4/12.
//
//

#import "UIPaystreamNoItemsFoundCell.h"

@implementation UIPaystreamNoItemsFoundCell

@synthesize environmentName;

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
    [environmentName release];
    [super dealloc];
}
@end
