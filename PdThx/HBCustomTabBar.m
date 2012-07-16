//
//  HollerCustomTabBar.m
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Webpreneur LLC. All rights reserved.
//

#import "HBCustomTabBar.h"


@implementation HBCustomTabBar

@synthesize firstTabButton,
            secondTabButton,
            centerTabButton,
            fourthTabButton,
            fifthTabButton;

@synthesize firstTabImage,
            secondTabImage,
            centerTabImage,
            fourthTabImage,
            fifthTabImage;


@synthesize firstTabLabel,
secondTabLabel,
centerTabLabel,
fourthTabLabel,
fifthTabLabel;


@synthesize firstTabSelectedOverlay,
secondTabSelectedOverlay,
centerTabSelectedOverlay,
fourthTabSelectedOverlay,
fifthTabSelectedOverlay;

- (id)init
{
    self = [super init];
    if( self )
    {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 360, 320, 59);
        self.opaque = NO;
    }
    return self;
}

- (void)dealloc
{
    [firstTabImage release];
    [secondTabImage release];
    [centerTabImage release];
    [fourthTabImage release];
    [fifthTabImage release];
    
    
    [firstTabButton release];
    [secondTabButton release];
    [centerTabButton release];
    [fourthTabButton release];
    [fifthTabButton release];

    
    
    [firstTabLabel release];
    [secondTabLabel release];
    [centerTabLabel release];
    [fourthTabLabel release];
    [fifthTabLabel release];
    
    
    [firstTabSelectedOverlay release];
    [secondTabSelectedOverlay release];
    [centerTabSelectedOverlay release];
    [fourthTabSelectedOverlay release];
    [fifthTabSelectedOverlay release];
    
    [super dealloc];
}

@end
