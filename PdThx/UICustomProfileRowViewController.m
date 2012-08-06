//
//  UICustomProfileRowViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UICustomProfileRowViewController.h"

@implementation UICustomProfileRowViewController

@synthesize lblAttributeName;
@synthesize txtAttributeValue;
@synthesize userAttributeId;

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
    [lblAttributeName release];
    [txtAttributeValue release];
    [userAttributeId release];
    
    [super dealloc];
}

@end
