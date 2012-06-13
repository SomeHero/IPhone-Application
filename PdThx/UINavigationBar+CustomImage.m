//
//  UINavigationBar+CustomImage.m
//  PdThx
//
//  Created by James Rhodes on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+CustomImage.h"

@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavigationBar-320x44.png"]];
    [self addSubview:img];
    [self sendSubviewToBack:img];
}


@end