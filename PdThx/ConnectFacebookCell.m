//
//  ConnectFacebookCell.m
//  PdThx
//
//  Created by Christopher Magee on 9/14/12.
//
//

#import "ConnectFacebookCell.h"
#import "FacebookSignIn.h"
#import "ContactSelectViewController.h"

@implementation ConnectFacebookCell

@synthesize connectFacebookCell;
@synthesize parentTableView;

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
    [connectFacebookCell release];
    [super dealloc];
}

- (IBAction)linkFacebookPressed:(id)sender
{
    FacebookSignIn*fbHelper = [[FacebookSignIn alloc] init];
    [fbHelper linkNewFacebookAccount:self];
    
    [((ContactSelectViewController*)parentTableView).txtSearchBox resignFirstResponder];
    
    [self becomeFirstResponder];
}

-(void)facebookAccountLinkFailed
{
    
}

-(void)facebookAccountLinkSuccess
{
}

@end
