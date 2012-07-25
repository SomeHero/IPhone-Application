//
//  TabBarManager.m
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Holler Inc. All rights reserved.
//

#import "SignedOutTabBarManager.h"
#import "SignedOutTabBar.h"
#import "WelcomeScreenViewController.h"
#import "PdThxAppDelegate.h"

@implementation SignedOutTabBarManager
@synthesize tabBar, topView;

- (id)initWithViewController:(UIViewController *)theVc topView:(UIView *)top delegate:(NSObject <SignedOutTabBarDelegate>*)theDelegate selectedIndex:(NSInteger)index
{
    self = [super init];
    if( self )
    {
        delegate = theDelegate;
        self.topView = top;
        
        self.tabBar = [[[SignedOutTabBar alloc]init]autorelease];
        
        [self configureTabBar:theVc selectedIndex:index];
    }
    return self;
}

- (void)configureTabBar:(UIViewController *)vc selectedIndex:(NSInteger)index
{
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"SignedOutTabBar" owner:self options:nil];
    
    for( id currentObject in topLevelObjects )
    {
        if([currentObject isKindOfClass:[SignedOutTabBar class]]){
            SignedOutTabBar *bar = (SignedOutTabBar *)currentObject;
            
            [tabBar release];
            [bar retain];
            tabBar = bar;
            
            tabBar.frame = CGRectMake(0, 364, 320, 52);
            
            [vc.view insertSubview:tabBar aboveSubview:topView];
            break;
        }
    }
    
    if( index == 0 )
    {
        tabBar.firstTabSelectedOverlay.hidden = NO;
        [tabBar.firstTabImage setImage:[UIImage imageNamed:@"tab-home-30x30-active.png"]];
        tabBar.firstTabLabel.textColor = [UIColor colorWithRed:44/255.0 green:131/255.0 blue:70/255.0 alpha:1.0];
        //44 131 70 GREEN LABEL
    }
    else
    {
        tabBar.firstTabSelectedOverlay.hidden = YES;
        [tabBar.firstTabImage setImage:[UIImage imageNamed:@"tab-home-30x30.png"]];
        tabBar.firstTabLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
    }
    if( index == 1 )
    {
        tabBar.secondTabSelectedOverlay.hidden = NO;
        [tabBar.secondTabImage setImage:[UIImage imageNamed:@"tab-signon-30x30-active.png"]];
        tabBar.secondTabLabel.textColor = [UIColor colorWithRed:44/255.0 green:131/255.0 blue:70/255.0 alpha:1.0];
    }
    else
    {
        tabBar.secondTabSelectedOverlay.hidden = YES;
        [tabBar.secondTabImage setImage:[UIImage imageNamed:@"tab-signon-30x30.png"]];
        tabBar.secondTabLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
    }
    if( index == 2 )
    {
        tabBar.thirdTabSelectedOverlay.hidden = NO;
        [tabBar.thirdTabImage setImage:[UIImage imageNamed:@"tab-join-30x30-active.png"]];
        tabBar.thirdTabLabel.textColor = [UIColor colorWithRed:44/255.0 green:131/255.0 blue:70/255.0 alpha:1.0];
    }
    else
    {
        tabBar.thirdTabSelectedOverlay.hidden = YES;
        [tabBar.thirdTabImage setImage:[UIImage imageNamed:@"tab-join-30x30.png"]];
        tabBar.thirdTabLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
    }
    if( index == 3 )
    {
        tabBar.fourthTabSelectedOverlay.hidden = NO;
        [tabBar.fourthTabImage setImage:[UIImage imageNamed:@"tab-about-30x30-active.png"]];
        tabBar.fourthTabLabel.textColor = [UIColor colorWithRed:44/255.0 green:131/255.0 blue:70/255.0 alpha:1.0];
    }
    else
    {
        tabBar.fourthTabSelectedOverlay.hidden = YES;
        [tabBar.fourthTabImage setImage:[UIImage imageNamed:@"tab-about-30x30.png"]];
        tabBar.fourthTabLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
    }
    
    //Configure all the buttons
    [tabBar.firstTabButton addTarget:self action:@selector(loadFirstTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.secondTabButton addTarget:self action:@selector(loadSecondTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.thirdTabButton addTarget:self action:@selector(loadThirdTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBar.fourthTabButton addTarget:self action:@selector(loadFourthTab:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)loadThirdTab:(id)selector
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



- (void)dealloc
{
    [topView release];
    [tabBar release];
    [super dealloc];
}

@end
