//
//  HBCustomTabBar.h
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Holler Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HBCustomTabBar : UIView {
    IBOutlet UIImageView *firstTabImage;
    IBOutlet UIImageView *secondTabImage;
    IBOutlet UIImageView *centerTabImage;
    IBOutlet UIImageView *fourthTabImage;
    IBOutlet UIImageView *fifthTabImage;
    
    IBOutlet UIButton *firstTabButton;
    IBOutlet UIButton *secondTabButton;
    IBOutlet UIButton *centerTabButton;
    IBOutlet UIButton *fourthTabButton;
    IBOutlet UIButton *fifthTabButton;
}

@property (nonatomic, retain) UIImageView *firstTabImage;
@property (nonatomic, retain) UIImageView *secondTabImage;
@property (nonatomic, retain) UIImageView *centerTabImage;
@property (nonatomic, retain) UIImageView *fourthTabImage;
@property (nonatomic, retain) UIImageView *fifthTabImage;

@property (nonatomic, retain) UIButton *firstTabButton;
@property (nonatomic, retain) UIButton *secondTabButton;
@property (nonatomic, retain) UIButton *centerTabButton;
@property (nonatomic, retain) UIButton *fourthTabButton;
@property (nonatomic, retain) UIButton *fifthTabButton;

@end
