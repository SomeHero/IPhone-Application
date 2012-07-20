//
//  DoGoodUITableCellViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DoGoodUITableCellViewController.h"

@interface DoGoodUITableCellViewController ()

@end

@implementation DoGoodUITableCellViewController

@synthesize contactName, contactDetail, contactImage;
@synthesize imgData;
@synthesize detailInfoButtonClicked;
@synthesize merchantId;


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

- (void)dealloc 
{
    [contactImage release];
    [contactImage release];
    [contactDetail release];
    [contactName release];
    
    [super dealloc];
}

-(IBAction)btnInfoClicked:(id)sender
{
    UIButton* buttonClicked = (UIButton*)sender;
    
    [detailInfoButtonClicked infoButtonClicked: merchantId];
    
}

@end
