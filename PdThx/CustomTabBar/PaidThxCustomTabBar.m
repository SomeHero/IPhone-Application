//
//  HollerCustomTabBar.m
//  Holler
//
//  Created by Nick ONeill on 8/17/11.
//  Copyright 2011 Webpreneur LLC. All rights reserved.
//

#import "PaidThxCustomTabBar.h"

#define K_CUSTOM_TAB_HEIGHT 62

@implementation PaidThxCustomTabBar
@synthesize firstButton;
@synthesize secondButton;
@synthesize thirdButton;
@synthesize fourthButton;
@synthesize middleButton;

- (id)init
{
    self = [super init];
    if( self )
    {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, self.superview.frame.size.height, self.superview.frame.size
                                .width, K_CUSTOM_TAB_HEIGHT);
        self.opaque = NO;
    }
    return self;
}

- (void)dealloc
{
    [middleButton release];
    
    [firstButton release];
    [secondButton release];
    [thirdButton release];
    [fourthButton release];
    [super dealloc];
}

@end
