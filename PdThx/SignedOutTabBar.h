//
//  HBCustomTabBar.h
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Holler Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignedOutTabBar : UIView {
    IBOutlet UIImageView *firstTabImage;
    IBOutlet UIImageView *secondTabImage;
    IBOutlet UIImageView *thirdTabImage;
    IBOutlet UIImageView *fourthTabImage;
    
    IBOutlet UIButton *firstTabButton;
    IBOutlet UIButton *secondTabButton;
    IBOutlet UIButton *thirdTabButton;
    IBOutlet UIButton *fourthTabButton;
    
    IBOutlet UILabel *firstTabLabel;
    IBOutlet UILabel *secondTabLabel;
    IBOutlet UILabel *thirdTabLabel;
    IBOutlet UILabel *fourthTabLabel;
    
    
    IBOutlet UIImageView *firstTabSelectedOverlay;
    IBOutlet UIImageView *secondTabSelectedOverlay;
    IBOutlet UIImageView *thirdTabSelectedOverlay;
    IBOutlet UIImageView *fourthTabSelectedOverlay;
}

@property (nonatomic, retain) UIImageView *firstTabImage;
@property (nonatomic, retain) UIImageView *secondTabImage;
@property (nonatomic, retain) UIImageView *thirdTabImage;
@property (nonatomic, retain) UIImageView *fourthTabImage;

@property (nonatomic, retain) UIButton *firstTabButton;
@property (nonatomic, retain) UIButton *secondTabButton;
@property (nonatomic, retain) UIButton *thirdTabButton;
@property (nonatomic, retain) UIButton *fourthTabButton;


@property (nonatomic, retain) UILabel *firstTabLabel;
@property (nonatomic, retain) UILabel *secondTabLabel;
@property (nonatomic, retain) UILabel *thirdTabLabel;
@property (nonatomic, retain) UILabel *fourthTabLabel;

@property (nonatomic, retain) UIImageView *firstTabSelectedOverlay;
@property (nonatomic, retain) UIImageView *secondTabSelectedOverlay;
@property (nonatomic, retain) UIImageView *thirdTabSelectedOverlay;
@property (nonatomic, retain) UIImageView *fourthTabSelectedOverlay;

-(id)initForNonNavigationBar;

@end
