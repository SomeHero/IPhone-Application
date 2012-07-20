//
//  CustomAlertViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertViewProtocol.h"


@interface CustomAlertViewController : UIViewController
{
    IBOutlet UIImageView *resultImageView;
    
    IBOutlet UILabel *topTitleLabel;
    IBOutlet UILabel *subTitleLabel;
    IBOutlet UITextView *detailedTextView;
    
    IBOutlet UIButton *leftButton;
    IBOutlet UIButton *rightButton;
    id<CustomAlertViewProtocol> alertViewDelegate;
}

@property (nonatomic,retain) UILabel *topTitleLabel;
@property (nonatomic,retain) UILabel *subTitleLabel;
@property (nonatomic,retain) UIImageView *resultImageView;
@property (nonatomic,retain) UITextView *detailedTextView;
@property (nonatomic,retain) UIButton *leftButton;
@property (nonatomic,retain) UIButton *rightButton;
@property (assign) id<CustomAlertViewProtocol> alertViewDelegate;



- (IBAction)pressedLeftButton:(id)sender;
- (IBAction)pressedRightButton:(id)sender;



@end
