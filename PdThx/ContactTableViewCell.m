//
//  ContactTableViewCell.m
//  PdThx
//
//  Created by James Rhodes on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell

@synthesize contactDetail, contactImage;
@synthesize imgData, contactNameField;
@synthesize contactNameLayer;
@synthesize btnInfo;
@synthesize merchantId;
@synthesize detailInfoButtonClicked;

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
-(IBAction)btnInfoClicked:(id)sender
{
    [detailInfoButtonClicked infoButtonClicked: ((UICustomDetailButton*)sender).contact];
}
- (void)dealloc 
{
    [contactImage release];
    [contactImage release];
    [contactDetail release];
    
    [contactNameField release];
    [btnInfo release];
    [merchantId release];
    
    [super dealloc];
}
@end
