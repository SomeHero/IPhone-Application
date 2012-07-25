//
//  HollerCustomTabBar.m
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Webpreneur LLC. All rights reserved.
//

#import "SignedOutTabBar.h"
#import "PdThxAppDelegate.h"


@implementation SignedOutTabBar

@synthesize firstTabButton,
secondTabButton,
thirdTabButton,
fourthTabButton;

@synthesize firstTabImage,
secondTabImage,
thirdTabImage,
fourthTabImage;


@synthesize firstTabLabel,
secondTabLabel,
thirdTabLabel,
fourthTabLabel;

@synthesize firstTabSelectedOverlay,
secondTabSelectedOverlay,
thirdTabSelectedOverlay,
fourthTabSelectedOverlay;

- (id)init
{
    self = [super init];
    if( self )
    {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 364, 320, 52);
        self.opaque = NO;
    }
    return self;
}

- (void)dealloc
{
    [firstTabImage release];
    [secondTabImage release];
    [thirdTabImage release];
    [fourthTabImage release];
    
    
    [firstTabButton release];
    [secondTabButton release];
    [thirdTabButton release];
    [fourthTabButton release];
    
    
    
    [firstTabLabel release];
    [secondTabLabel release];
    [thirdTabLabel release];
    [fourthTabLabel release];
    
    
    [firstTabSelectedOverlay release];
    [secondTabSelectedOverlay release];
    [thirdTabSelectedOverlay release];
    [fourthTabSelectedOverlay release];
    
    [super dealloc];
}

@end
