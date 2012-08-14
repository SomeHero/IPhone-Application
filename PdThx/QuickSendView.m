//
//  QuickSendView.m
//  PdThx
//
//  Created by James Rhodes on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickSendView.h"
#import <QuartzCore/QuartzCore.h>


@implementation QuickSendView

@synthesize qs1button, qs1textView;
@synthesize qs2button, qs2textView;
@synthesize qs3button, qs3textView;
@synthesize qs4button, qs4textView;
@synthesize qs5button, qs5textView;
@synthesize qs6button, qs6textView;
@synthesize qs7button, qs7textView;
@synthesize qs8button, qs8textView;
@synthesize qs9button, qs9textView;
@synthesize buttonDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Quick Send Images
    [self.qs1button.layer setCornerRadius:14.0];
    [self.qs1button.layer setMasksToBounds:YES];
    [self.qs1button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs1button.layer setBorderWidth:0.7]; // 28 24 20
    
    [self.qs2button.layer setCornerRadius:14.0];
    [self.qs2button.layer setMasksToBounds:YES];
    [self.qs2button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs2button.layer setBorderWidth:0.7]; // 28 24 20
    
    [self.qs3button.layer setCornerRadius:14.0];
    [self.qs3button.layer setMasksToBounds:YES];
    [self.qs3button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs3button.layer setBorderWidth:0.7]; // 28 24 20
    
    [self.qs4button.layer setCornerRadius:14.0];
    [self.qs4button.layer setMasksToBounds:YES];
    [self.qs4button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs4button.layer setBorderWidth:0.7]; // 28 24 20
    
    [self.qs5button.layer setCornerRadius:14.0];
    [self.qs5button.layer setMasksToBounds:YES];
    [self.qs5button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs5button.layer setBorderWidth:0.7]; // 28 24 20
    
    [self.qs6button.layer setCornerRadius:14.0];
    [self.qs6button.layer setMasksToBounds:YES];
    [self.qs6button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs6button.layer setBorderWidth:0.7]; // 28 24 20
    
    [self.qs7button.layer setCornerRadius:14.0];
    [self.qs7button.layer setMasksToBounds:YES];
    [self.qs7button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs7button.layer setBorderWidth:0.7]; // 28 24 20
    
    [self.qs8button.layer setCornerRadius:14.0];
    [self.qs8button.layer setMasksToBounds:YES];
    [self.qs8button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs8button.layer setBorderWidth:0.7]; // 28 24 20
    
    [self.qs9button.layer setCornerRadius:14.0];
    [self.qs9button.layer setMasksToBounds:YES];
    [self.qs9button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs9button.layer setBorderWidth:0.7]; // 28 24 20
}


- (void)dealloc {
    [qs1button release];
    [qs2button release];
    [qs3button release];
    [qs4button release];
    [qs5button release];
    [qs6button release];
    [qs7button release];
    [qs8button release];
    [qs9button release];
    [qs1textView release];
    [qs2textView release];
    [qs3textView release];
    [qs4textView release];
    [qs5textView release];
    [qs6textView release];
    [qs7textView release];
    [qs8textView release];
    [qs9textView release];
    
    [super dealloc];
}

-(void)handleSwipeUp
{
    [buttonDelegate quicksendSwipedUp];
}

-(void)handleSwipeDown
{
    [buttonDelegate quicksendSwipedDown];
}


@end
