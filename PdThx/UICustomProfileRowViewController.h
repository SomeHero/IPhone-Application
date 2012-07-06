//
//  UICustomProfileRowViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomProfileRowViewController : UITableViewCell
{
    IBOutlet UILabel* lblAttributeName;
    IBOutlet UITextField* txtAttributeValue;
}
@property(nonatomic, retain) UILabel* lblAttributeName;
@property(nonatomic, retain) UITextField* txtAttributeValue;

@end
