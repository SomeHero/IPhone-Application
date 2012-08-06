//
//  UIProfileTextField.m
//  PdThx
//
//  Created by James Rhodes on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIProfileTextField.h"

@implementation UIProfileTextField

@synthesize attributeId;

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
-(void)dealloc {
    
    [attributeId release];
    
    [super dealloc];
}

@end
