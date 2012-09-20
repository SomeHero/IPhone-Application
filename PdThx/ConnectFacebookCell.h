//
//  ConnectFacebookCell.h
//  PdThx
//
//  Created by Christopher Magee on 9/14/12.
//
//

#import <UIKit/UIKit.h>

@interface ConnectFacebookCell : UITableViewCell
{
    IBOutlet UIButton *connectFacebookCell;
}

@property (nonatomic, retain) UIButton *connectFacebookCell;

- (IBAction)linkFacebookPressed:(id)sender;

@end
