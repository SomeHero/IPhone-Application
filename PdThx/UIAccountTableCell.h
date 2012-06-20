//
//  UIAccountTableCell.h
//  PdThx
//
//  Created by James Rhodes on 6/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAccountTableCell : UITableViewCell {
    IBOutlet UILabel* lblAccountInformation;
    IBOutlet UIButton* btnBankIcon;
}

@property(nonatomic,retain) UILabel* lblAccountInformation;
@property(nonatomic, retain) UIButton* btnBankIcon;
@end
