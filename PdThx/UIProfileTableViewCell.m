//
//  UIProfileTableViewCell.m
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIProfileTableViewCell.h"


@implementation UIProfileTableViewCell

@synthesize lblHeading;
@synthesize lblDescription;
@synthesize ctrlImage;

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
    [lblHeading release];
    [lblDescription release];
    [ctrlImage release];
    
    [super dealloc];
}

@end
