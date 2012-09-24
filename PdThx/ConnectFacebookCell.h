//
//  ConnectFacebookCell.h
//  PdThx
//
//  Created by Christopher Magee on 9/14/12.
//
//

#import <UIKit/UIKit.h>
#import "FacebookLinkProtocol.h"

@interface ConnectFacebookCell : UITableViewCell <FacebookLinkProtocol>
{
    IBOutlet UIButton *connectFacebookCell;
}

@property (nonatomic, retain) UIButton *connectFacebookCell;

- (IBAction)linkFacebookPressed:(id)sender;

@end
