//
//  HBCustomTabBar.h
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Holler Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PaidThxCustomTabBar : UIView {

    UIButton * middleButton;
}

@property (nonatomic, retain) IBOutlet UIButton *middleButton;
@property (retain, nonatomic) IBOutlet UIButton *firstButton;
@property (retain, nonatomic) IBOutlet UIButton *secondButton;
@property (retain, nonatomic) IBOutlet UIButton *thirdButton;
@property (retain, nonatomic) IBOutlet UIButton *fourthButton;

@end
