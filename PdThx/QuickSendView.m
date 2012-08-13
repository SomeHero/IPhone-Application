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

@synthesize qs1button, qs1bottomlabel, qs1toplabel;
@synthesize qs2button, qs2bottomlabel, qs2toplabel;
@synthesize qs3button, qs3bottomlabel, qs3toplabel;
@synthesize qs4button, qs4bottomlabel, qs4toplabel;
@synthesize qs5button, qs5bottomlabel, qs5toplabel;
@synthesize qs6button, qs6bottomlabel, qs6toplabel;
@synthesize qs7button, qs7bottomlabel, qs7toplabel;
@synthesize qs8button, qs8bottomlabel, qs8toplabel;
@synthesize qs9button, qs9bottomlabel, qs9toplabel;
@synthesize buttonDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    [qs1toplabel release];
    [qs1bottomlabel release];
    [qs2toplabel release];
    [qs2bottomlabel release];
    [qs3toplabel release];
    [qs3bottomlabel release];
    [qs4toplabel release];
    [qs4bottomlabel release];
    [qs5toplabel release];
    [qs5bottomlabel release];
    [qs6toplabel release];
    [qs6bottomlabel release];
    [qs7toplabel release];
    [qs7bottomlabel release];
    [qs8toplabel release];
    [qs8bottomlabel release];
    [qs9toplabel release];
    [qs9bottomlabel release];
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
