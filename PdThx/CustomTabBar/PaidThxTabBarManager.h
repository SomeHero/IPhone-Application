//
//  TabBarManager.h
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Webpreneur LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PaidThxCustomTabBar;

@protocol PaidThxTabBarDelegate
- (void)tabBarClicked:(NSUInteger)buttonIndex;
@end

@interface PaidThxTabBarManager : NSObject {
    NSObject <PaidThxTabBarDelegate> *delegate;
}

@property (nonatomic, retain) PaidThxCustomTabBar *tabBar;
@property (nonatomic, retain) UIView *topView;

- (id)initWithViewController:(UIViewController *)theVc topView:(UIView *)top delegate:(NSObject <PaidThxTabBarDelegate>*)theDelegate selectedIndex:(NSInteger)index;

- (void)configureTabBar:(UIViewController *)vc selectedIndex:(NSInteger)index;

//All methods for loading up the proper view controllers
- (void)loadActivities:(id)selector;
- (void)loadGroups:(id)selector;
- (void)loadCreateHoller:(id)selector;

@end
