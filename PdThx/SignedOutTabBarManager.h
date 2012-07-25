//
//  TabBarManager.h
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Webpreneur LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SignedOutTabBar;

@protocol SignedOutTabBarDelegate
- (void)tabBarClicked:(NSUInteger)buttonIndex;
@end

@interface SignedOutTabBarManager : NSObject {
    NSObject <SignedOutTabBarDelegate> *delegate;
}
@property (nonatomic, retain) SignedOutTabBar *tabBar;
@property (nonatomic, retain) UIView *topView;

- (id)initWithViewController:(UIViewController *)theVc topView:(UIView *)top delegate:(NSObject <SignedOutTabBarDelegate>*)theDelegate selectedIndex:(NSInteger)index;
- (void)configureTabBar:(UIViewController *)vc selectedIndex:(NSInteger)index;

//All methods for loading up the proper view controllers

- (void)loadFirstTab:(id)selector;
- (void)loadSecondTab:(id)selector;
- (void)loadThirdTab:(id)selector;
- (void)loadFourthTab:(id)selector;

@end
