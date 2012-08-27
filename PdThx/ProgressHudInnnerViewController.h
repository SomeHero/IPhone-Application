//
//  ProgressHudInnnerViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHudInnnerViewController : UIViewController
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *topLabel;
    IBOutlet UILabel *detailLabel;
    IBOutlet UIImageView *imgView;
    IBOutlet UIButton *dismissButton;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *topLabel;
@property (nonatomic, retain) UILabel *detailLabel;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UIButton *dismissButton;

- (IBAction)pressedDismiss:(id)sender;

@end
