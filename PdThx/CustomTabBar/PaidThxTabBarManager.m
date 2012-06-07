//
//  TabBarManager.m
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Holler Inc. All rights reserved.
//

#import "PaidThxTabBarManager.h"
#import "PaidThxCustomTabBar.h"

#define K_CUSTOM_TAB_HEIGHT 62

@implementation PaidThxTabBarManager
@synthesize tabBar, topView;

- (id)initWithViewController:(UIViewController *)theVc topView:(UIView *)top delegate:(NSObject <PaidThxTabBarDelegate>*)theDelegate selectedIndex:(NSInteger)index
{
    self = [super init];
    if( self )
    {
        delegate = theDelegate;
        self.topView = top;
        self.tabBar = [[[PaidThxCustomTabBar alloc]init]autorelease];
        
        [self configureTabBar:theVc selectedIndex:index];
    }
    return self;
}

- (void)configureTabBar:(UIViewController *)vc selectedIndex:(NSInteger)index
{
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"PaidThxCustomTabBar" owner:self options:nil];
    for( id currentObject in topLevelObjects )
    {
        if([currentObject isKindOfClass:[PaidThxCustomTabBar class]]){
            PaidThxCustomTabBar *bar = (PaidThxCustomTabBar *)currentObject;
            [tabBar release];
            [bar retain];
            tabBar = bar;
            tabBar.frame = CGRectMake(0, topView.frame.size.height-15, topView.frame.size.width, K_CUSTOM_TAB_HEIGHT);
            
            [vc.view insertSubview:tabBar aboveSubview:topView];
            break;
        }
    }
    if( index == 0 ) // Home button (firstButton)
    {
        [tabBar.firstButton.imageView setImage:[UIImage imageNamed:@"tabBarGroupsSelected.png"]];
        [tabBar.firstButton setBackgroundImage:[UIImage imageNamed:@"tabBarGroupsSelected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [tabBar.firstButton.imageView setImage:[UIImage imageNamed:@"tabBarGroups.png"]];
        [tabBar.firstButton setBackgroundImage:[UIImage imageNamed:@"tabBarGroups.png"] forState:UIControlStateNormal];
    }
    if( index == 1 )
    {
        [tabBar.secondButton.imageView setImage:[UIImage imageNamed:@"tabBarGroupsSelected.png"]];
        [tabBar.secondButton setBackgroundImage:[UIImage imageNamed:@"tabBarGroupsSelected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [tabBar.secondButton.imageView setImage:[UIImage imageNamed:@"tabBarGroups.png"]];
        [tabBar.secondButton setBackgroundImage:[UIImage imageNamed:@"tabBarGroups.png"] forState:UIControlStateNormal];
    }   
    if( index == 3 )
    {
        [tabBar.secondButton.imageView setImage:[UIImage imageNamed:@"tabBarGroupsSelected.png"]];
        [tabBar.secondButton setBackgroundImage:[UIImage imageNamed:@"tabBarGroupsSelected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [tabBar.thirdButton.imageView setImage:[UIImage imageNamed:@"tabBarGroups.png"]];
        [tabBar.thirdButton setBackgroundImage:[UIImage imageNamed:@"tabBarGroups.png"] forState:UIControlStateNormal];
    } 
    if( index == 4 )
    {
        [tabBar.fourthButton.imageView setImage:[UIImage imageNamed:@"tabBarGroupsSelected.png"]];
        [tabBar.fourthButton setBackgroundImage:[UIImage imageNamed:@"tabBarGroupsSelected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [tabBar.fourthButton.imageView setImage:[UIImage imageNamed:@"tabBarGroups.png"]];
        [tabBar.fourthButton setBackgroundImage:[UIImage imageNamed:@"tabBarGroups.png"] forState:UIControlStateNormal];
    }
    
    
    
    
    //Configure all the buttons
    [tabBar.firstButton addTarget:self action:@selector(showFirstVC:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.secondButton addTarget:self action:@selector(showSecondVC:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.middleButton addTarget:self action:@selector(showMiddleVC:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.thirdButton addTarget:self action:@selector(showThirdVC:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.fourthButton addTarget:self action:@selector(showFourthVC:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - View Controller loading methods

- (void)showFirstVC:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
        [delegate tabBarClicked:0];
}

- (void)showSecondVC:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
        [delegate tabBarClicked:1];
}

- (void)showMiddleVC:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
        [delegate tabBarClicked:2];
}

- (void)showThirdVC:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
        [delegate tabBarClicked:3];
}

- (void)showFourthVC:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
        [delegate tabBarClicked:0];
}

- (void)dealloc
{
    [topView release];
    [tabBar release];
    [super dealloc];
}

@end
