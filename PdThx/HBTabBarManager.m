//
//  TabBarManager.m
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Holler Inc. All rights reserved.
//

#import "HBTabBarManager.h"
#import "HBCustomTabBar.h"

@implementation HBTabBarManager
@synthesize tabBar, topView;

- (id)initWithViewController:(UIViewController *)theVc topView:(UIView *)top delegate:(NSObject <HBTabBarDelegate>*)theDelegate selectedIndex:(NSInteger)index
{
    self = [super init];
    if( self )
    {
        delegate = theDelegate;
        self.topView = top;
        self.tabBar = [[[HBCustomTabBar alloc]init]autorelease];
        
        [self configureTabBar:theVc selectedIndex:index];
    }
    return self;
}

- (void)configureTabBar:(UIViewController *)vc selectedIndex:(NSInteger)index
{
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"HBCustomTabBar" owner:self options:nil];
    
    for( id currentObject in topLevelObjects )
    {
        if([currentObject isKindOfClass:[HBCustomTabBar class]]){
            HBCustomTabBar *bar = (HBCustomTabBar *)currentObject;//[topLevelObjects objectAtIndex:0];
            [tabBar release];
            [bar retain];
            tabBar = bar;
            tabBar.frame = CGRectMake(0, 357, 320, 59);
            
            [vc.view insertSubview:tabBar aboveSubview:topView];
            break;
        }
    }
    
    if( index == 0 )
    {
        [tabBar.firstTabImage setImage:[UIImage imageNamed:@"home-active@2x.png"]];
    }
    else
    {
        [tabBar.firstTabImage setImage:[UIImage imageNamed:@"home-inactive@2x.png"]];
    }
    if( index == 1 )
    {
        [tabBar.secondTabImage setImage:[UIImage imageNamed:@"tab-paystream-30x30-active.png"]];
    }
    else
    {
        [tabBar.secondTabImage setImage:[UIImage imageNamed:@"tab-paystream-30x30.png"]];
    }
    if( index == 2 )
    {
        [tabBar.centerTabImage setImage:[UIImage imageNamed:@"tab-send-30x30-active.png"]];
    }
    else
    {
        [tabBar.centerTabImage setImage:[UIImage imageNamed:@"tab-send-30x30.png"]];
    }
    if( index == 3 )
    {
        [tabBar.fourthTabImage setImage:[UIImage imageNamed:@"tab-request-30x30-active.png"]];
    }
    else
    {
        [tabBar.fourthTabImage setImage:[UIImage imageNamed:@"tab-request-30x30.png"]];
    }
    if( index == 4 )
    {
        [tabBar.fifthTabImage setImage:[UIImage imageNamed:@"dogood-active@2x.png"]];
    }
    else
    {
        [tabBar.fifthTabImage setImage:[UIImage imageNamed:@"dogood-inactive@2x.png"]];
    }
    
    //Configure all the buttons
    [tabBar.firstTabButton addTarget:self action:@selector(loadFirstTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.secondTabButton addTarget:self action:@selector(loadSecondTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.centerTabButton addTarget:self action:@selector(loadCenterTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.fourthTabButton addTarget:self action:@selector(loadFourthTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.fifthTabButton addTarget:self action:@selector(loadFifthTab:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - View Controller loading methods

- (void)loadFirstTab:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
    {
        [delegate tabBarClicked:0];
    }
}

- (void)loadSecondTab:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
    {
        [delegate tabBarClicked:1];
    }
}

- (void)loadCenterTab:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
    {
        [delegate tabBarClicked:2];
    }
}

- (void)loadFourthTab:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
    {
        [delegate tabBarClicked:3];
    }
}

- (void)loadFifthTab:(id)selector
{
    if( [delegate respondsToSelector:@selector(tabBarClicked:)] )
    {
        [delegate tabBarClicked:4];
    }
}


- (void)dealloc
{
    [topView release];
    [tabBar release];
    [super dealloc];
}

@end
