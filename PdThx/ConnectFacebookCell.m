//
//  ConnectFacebookCell.m
//  PdThx
//
//  Created by Christopher Magee on 9/14/12.
//
//

#import "ConnectFacebookCell.h"

@implementation ConnectFacebookCell

@synthesize connectFacebookCell;

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
    [connectFacebookCell release];
    [super dealloc];
}
- (IBAction)linkFacebookPressed:(id)sender
{
    NSLog(@"Link with Facebook Called");
}

@end
