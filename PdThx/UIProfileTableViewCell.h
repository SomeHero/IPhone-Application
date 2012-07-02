//
//  UIProfileTableViewCell.h
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIProfileTableViewCell : UITableViewCell
{
    IBOutlet UILabel* lblHeading;
    IBOutlet UILabel* lblDescription;
    IBOutlet UIImageView* ctrlImage;
}
@end
