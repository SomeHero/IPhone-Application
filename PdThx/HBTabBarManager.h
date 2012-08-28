//
//  TabBarManager.h
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Webpreneur LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HBCustomTabBar;

@protocol HBTabBarDelegate
- (void)tabBarClicked:(NSUInteger)buttonIndex;
@end

@interface HBTabBarManager : NSObject {
    NSObject <HBTabBarDelegate> *delegate;
}
@property (nonatomic, retain) HBCustomTabBar *tabBar;
@property (nonatomic, retain) UIView *topView;

@property (nonatomic, retain) UIViewController * firstViewController;
@property (nonatomic, retain) UIViewController * secondViewController;
@property (nonatomic, retain) UIViewController * centerViewController;
@property (nonatomic, retain) UIViewController * fourthViewController;
@property (nonatomic, retain) UIViewController * fifthViewController;

- (id)initWithViewController:(UIViewController *)theVc topView:(UIView *)top delegate:(NSObject <HBTabBarDelegate>*)theDelegate selectedIndex:(NSInteger)index;



- (void)configureTabBar:(UIViewController *)vc selectedIndex:(NSInteger)index;
//All methods for loading up the proper view controllers

-(void)setTabBarNotificationCount:(NSInteger)notifications;

- (void)loadFirstTab:(id)selector;
- (void)loadSecondTab:(id)selector;
- (void)loadCenterTab:(id)selector;
- (void)loadFourthTab:(id)selector;
- (void)loadFifthTab:(id)selector;

@end
