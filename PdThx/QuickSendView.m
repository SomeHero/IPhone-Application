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

-(void)reloadQuickSendContacts:(NSMutableArray *)contactArray
{
    [qs1button  setBackgroundImage:NULL forState:UIControlStateNormal | UIControlStateSelected];
    qs1textView.text = @"";
    
    [qs2button  setBackgroundImage:NULL forState:UIControlStateNormal | UIControlStateSelected];
    qs2textView.text = @"";
    
    [qs3button  setBackgroundImage:NULL forState:UIControlStateNormal | UIControlStateSelected];
    qs3textView.text = @"";
    
    [qs4button  setBackgroundImage:NULL forState:UIControlStateNormal | UIControlStateSelected];
    qs4textView.text = @"";
    
    [qs5button  setBackgroundImage:NULL forState:UIControlStateNormal | UIControlStateSelected];
    qs5textView.text = @"";
    
    [qs6button  setBackgroundImage:NULL forState:UIControlStateNormal | UIControlStateSelected];
    qs6textView.text = @"";
    
    [qs7button  setBackgroundImage:NULL forState:UIControlStateNormal | UIControlStateSelected];
    qs7textView.text = @"";
    
    [qs8button  setBackgroundImage:NULL forState:UIControlStateNormal | UIControlStateSelected];
    qs8textView.text = @"";
    
    [qs9button  setBackgroundImage:NULL forState:UIControlStateNormal | UIControlStateSelected];
    qs9textView.text = @"";
    
    /*      This cannot be made into a loop... I tried but I did not see an option.     */
    /*  ------------------------------------------------------------------------------  */
    
    int count = [contactArray count];
    
    if ( count > 0 )
    {
        NSDictionary* contactDict;
        
        if ( count > 0 )
        {
            contactDict = [contactArray objectAtIndex:0];
            [qs4button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal | UIControlStateSelected];
            qs4textView.text = [contactDict valueForKey:@"userName"];
        }
        if ( count > 1 )
        {
            contactDict = [contactArray objectAtIndex:1];
            [qs5button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal | UIControlStateSelected];
            qs5textView.text = [contactDict valueForKey:@"userName"];
        }
        if ( count > 2 )
        {
            contactDict = [contactArray objectAtIndex:2];
            [qs6button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal | UIControlStateSelected];
            qs6textView.text = [contactDict valueForKey:@"userName"];
        }
        if ( count > 3 )
        {
            contactDict = [contactArray objectAtIndex:3];
            [qs7button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal | UIControlStateSelected];
            qs7textView.text = [contactDict valueForKey:@"userName"];
        }
        if ( count > 4 )
        {
            contactDict = [contactArray objectAtIndex:4];
            [qs8button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal | UIControlStateSelected];
            qs8textView.text = [contactDict valueForKey:@"userName"];
        }
        if ( count > 5 )
        {
            contactDict = [contactArray objectAtIndex:5];
            [qs9button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal | UIControlStateSelected];
            qs9textView.text = [contactDict valueForKey:@"userName"];
        }
    }
}


@end
