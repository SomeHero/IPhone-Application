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

-(void)refreshTabBarNotification:(NSInteger)notifications
{
    // Set Paystream Notification Count
    tabBar.paystreamCountLabel.text = [NSString stringWithFormat:@"%d",notifications];
    
}


-(void)setTabBarNotificationCount:(NSInteger)notifications
{
    tabBar.paystreamCountLabel.text = [NSString stringWithFormat:@"%d",notifications];
}

- (void)configureTabBar:(UIViewController *)vc selectedIndex:(NSInteger)index
{
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"HBCustomTabBar" owner:self options:nil];
    
    for( id currentObject in topLevelObjects )
    {
        if([currentObject isKindOfClass:[HBCustomTabBar class]])
        {
            HBCustomTabBar *bar = (HBCustomTabBar *)currentObject;//[topLevelObjects objectAtIndex:0];
            [tabBar release];
            [bar retain];
            tabBar = bar;
            tabBar.frame = CGRectMake(0, 357, 320, 59);
            
            [vc.view insertSubview:tabBar aboveSubview:topView];
            break;
        }
    }
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    if ( [defs integerForKey:@"PaystreamNotificationCount"] > 9 )
    {
        [tabBar.paystreamCountImage setImage:[UIImage imageNamed:@"bg-notifications-9-14x14.png"]];
        tabBar.paystreamCountLabel.text = @"";
    } else if ( [defs integerForKey:@"PaystreamNotificationCount"] == 0 ) {
        [tabBar.paystreamCountImage setImage:NULL];
        tabBar.paystreamCountLabel.text = @"";
    } else {
        [tabBar.paystreamCountImage setImage:[UIImage imageNamed:@"bg-notifications-14x14.png"]];
        tabBar.paystreamCountLabel.text = [NSString stringWithFormat:@"%d",[defs integerForKey:@"PaystreamNotificationCount"]];
    }
    
    if( index == 0 )
    {
        [tabBar.firstTabImage setImage:[UIImage imageNamed:@"tab-home-30x30-active.png"]];
        tabBar.firstTabSelectedOverlay.hidden = NO;
        tabBar.firstTabLabel.textColor = [UIColor colorWithRed:44/255.0 green:131/255.0 blue:70/255.0 alpha:1.0];
        //44 131 70 GREEN LABEL
    }
    else
    {
        [tabBar.firstTabImage setImage:[UIImage imageNamed:@"tab-home-30x30.png"]];
        tabBar.firstTabSelectedOverlay.hidden = YES;
        tabBar.firstTabLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
    }
    if( index == 1 )
    {
        [tabBar.secondTabImage setImage:[UIImage imageNamed:@"tab-paystream-30x30-active.png"]];
        tabBar.secondTabSelectedOverlay.hidden = NO;
        tabBar.secondTabLabel.textColor = [UIColor colorWithRed:44/255.0 green:131/255.0 blue:70/255.0 alpha:1.0];
    }
    else
    {
        [tabBar.secondTabImage setImage:[UIImage imageNamed:@"tab-paystream-30x30.png"]];
        tabBar.secondTabSelectedOverlay.hidden = YES;
        tabBar.secondTabLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
    }
    if( index == 2 )
    {
        [tabBar.centerTabImage setImage:[UIImage imageNamed:@"tab-send-30x30-active.png"]];
        [tabBar.centerTabSelectedOverlay setImage:[UIImage imageNamed:@"bg-tab-send-active-75x57.png"]];
        tabBar.centerTabLabel.textColor = [UIColor colorWithRed:44/255.0 green:131/255.0 blue:70/255.0 alpha:1.0];
    }
    else
    {
        [tabBar.centerTabImage setImage:[UIImage imageNamed:@"tab-send-30x30.png"]];
        [tabBar.centerTabSelectedOverlay setImage:[UIImage imageNamed:@"bg-tab-send-75x57.png"]];
        tabBar.centerTabLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
    }
    if( index == 3 )
    {
        [tabBar.fourthTabImage setImage:[UIImage imageNamed:@"tab-request-30x30-active.png"]];
        tabBar.fourthTabSelectedOverlay.hidden = NO;
        tabBar.fourthTabLabel.textColor = [UIColor colorWithRed:44/255.0 green:131/255.0 blue:70/255.0 alpha:1.0];
    }
    else
    {
        [tabBar.fourthTabImage setImage:[UIImage imageNamed:@"tab-request-30x30.png"]];
        tabBar.fourthTabSelectedOverlay.hidden = YES;
        tabBar.fourthTabLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
    }
    if( index == 4 )
    {
        [tabBar.fifthTabImage setImage:[UIImage imageNamed:@"tab-dogood-30x30-active.png"]];
        tabBar.fifthTabSelectedOverlay.hidden = NO;
        tabBar.fifthTabLabel.textColor = [UIColor colorWithRed:44/255.0 green:131/255.0 blue:70/255.0 alpha:1.0];
    }
    else
    {
        [tabBar.fifthTabImage setImage:[UIImage imageNamed:@"tab-dogood-30x30.png"]];
        tabBar.fifthTabSelectedOverlay.hidden = YES;
        tabBar.fifthTabLabel.textColor = [UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
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
