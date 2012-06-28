//
//  myProgressHud.h
//  PdThx
//
//  Created by James Rhodes on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myProgressHud : UIViewController
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *topLabel;
    IBOutlet UILabel *detailLabel;
    IBOutlet UIImageView *imgView;
    IBOutlet UIView *fadedLayer;
    IBOutlet UIView *layerToAnimate;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *topLabel;
@property (nonatomic, retain) UILabel *detailLabel;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UIView *fadedLayer;
@property (nonatomic, retain) UIView *layerToAnimate;


- (void)showWithStatus:(NSString *)status;

- (void)showSuccessWithStatus:(NSString *)string;

- (void)showErrorWithStatus:(NSString *)string;


@end