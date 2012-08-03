//
//  ACHHelpView.m
//  PdThx
//
//  Created by Justin Cheng on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ACHHelpView.h"

@implementation ACHHelpView
@synthesize exitButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [exitButton release];
    [super dealloc];
}
@end
