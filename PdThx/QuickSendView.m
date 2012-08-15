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
@synthesize buttonDelegate, phoneFormatter;


- (id)initWithFrame:(CGRect)frame {
    
    //self = [super initWithFrame:frame]; // not needed - thanks ddickison
	if (self) {
        NSArray *nib = [[NSBundle mainBundle]
						loadNibNamed:@"QuickSendView"
						owner:self
						options:nil];
		
		[self release];	// release object before reassignment to avoid leak - thanks ddickison
		self = [nib objectAtIndex:0];
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
    [phoneFormatter release];
    
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
    if ( phoneFormatter == nil )
        phoneFormatter = [[PhoneNumberFormatting alloc] init];
    
    [qs4button  setBackgroundImage:NULL forState:UIControlStateNormal];
    qs4textView.text = @"";
    
    [qs5button  setBackgroundImage:NULL forState:UIControlStateNormal];
    qs5textView.text = @"";
    
    [qs6button  setBackgroundImage:NULL forState:UIControlStateNormal];
    qs6textView.text = @"";
    
    [qs7button  setBackgroundImage:NULL forState:UIControlStateNormal];
    qs7textView.text = @"";
    
    [qs8button  setBackgroundImage:NULL forState:UIControlStateNormal];
    qs8textView.text = @"";
    
    [qs9button  setBackgroundImage:NULL forState:UIControlStateNormal];
    qs9textView.text = @"";
    
    /*      This cannot be made into a loop... I tried but I did not see an option.     */
    /*  ------------------------------------------------------------------------------  */
    
    /*
     // The only cases we need to handle are: Phone Number and Email
     NSString * numOnly = [[txtEmailAddress.text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
     NSRange numOnly2 = [[[txtEmailAddress.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-() "]] componentsJoinedByString:@""] rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]  options:NSCaseInsensitiveSearch];
     if([txtEmailAddress.text length] < 1)
     return 0;
     if ( [txtEmailAddress.text isEqualToString:numOnly] || numOnly2.location == NSNotFound ) {
     // Is only Numbers, I think?
     */
    
    if ( contactArray != (id)[NSNull null] )
    {
        NSLog(@"Inside contact array not null");
        int count = [contactArray count];
        NSLog(@"After count, %d",count);
        
        if ( count > 0 )
        {
            NSDictionary* contactDict;
            
            if ( count > 0 )
            {
                contactDict = [contactArray objectAtIndex:0];
                
                NSLog(@"ContactDictionary0: %@", contactDict);
                
                if ( [contactDict valueForKey:@"userImage"] != (id)[NSNull null] )
                    [qs4button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal];
                else
                    [qs4button setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
                
                if ( [contactDict valueForKey:@"userName"] != (id)[NSNull null] )
                    [qs4textView setText: [contactDict valueForKey:@"userName"]];
                else
                {
                    NSString * numOnly = [[[contactDict valueForKey:@"userUri"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    
                    if ( [numOnly isEqualToString:[contactDict valueForKey:@"userUri"]] )
                        [qs4textView setText:[phoneFormatter stringToFormattedPhoneNumber:[contactDict valueForKey:@"userUri"]]];
                    else
                        [qs4textView setText:[contactDict valueForKey:@"userUri"]];
                }
            }
            if ( count > 1 )
            {
                NSLog(@"ContactDictionary1: %@", contactDict);
                contactDict = [contactArray objectAtIndex:1];
                if ( [contactDict objectForKey:@"userImage"] != (id)[NSNull null] )
                    [qs5button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal];
                else
                    [qs5button setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
                
                if ( [contactDict valueForKey:@"userName"] != (id)[NSNull null] )
                    [qs5textView setText: [contactDict valueForKey:@"userName"]];
                else
                {
                    NSString * numOnly = [[[contactDict valueForKey:@"userUri"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    
                    if ( [numOnly isEqualToString:[contactDict valueForKey:@"userUri"]] )
                        [qs5textView setText:[phoneFormatter stringToFormattedPhoneNumber:[contactDict valueForKey:@"userUri"]]];
                    else
                        [qs5textView setText:[contactDict valueForKey:@"userUri"]];
                }
            }
            if ( count > 2 )
            {
                contactDict = [contactArray objectAtIndex:2];
                NSLog(@"ContactDictionary2: %@", contactDict);
                
                if ( [contactDict valueForKey:@"userImage"] != (id)[NSNull null] )
                    [qs6button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal];
                else
                    [qs6button setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
                
                if ( [contactDict valueForKey:@"userName"] != (id)[NSNull null] )
                    [qs6textView setText: [contactDict valueForKey:@"userName"]];
                else
                {
                    NSString * numOnly = [[[contactDict valueForKey:@"userUri"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    
                    if ( [numOnly isEqualToString:[contactDict valueForKey:@"userUri"]] )
                        [qs6textView setText:[phoneFormatter stringToFormattedPhoneNumber:[contactDict valueForKey:@"userUri"]]];
                    else
                        [qs6textView setText:[contactDict valueForKey:@"userUri"]];
                }
            }
            if ( count > 3 )
            {
                contactDict = [contactArray objectAtIndex:3];
                NSLog(@"ContactDictionary3: %@", contactDict);
                
                
                if ( [contactDict valueForKey:@"userImage"] != (id)[NSNull null] )
                    [qs7button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal];
                else
                    [qs7button setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
                
                if ( [contactDict valueForKey:@"userName"] != (id)[NSNull null] )
                    [qs7textView setText: [contactDict valueForKey:@"userName"]];
                else
                {
                    NSString * numOnly = [[[contactDict valueForKey:@"userUri"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    
                    if ( [numOnly isEqualToString:[contactDict valueForKey:@"userUri"]] )
                        [qs7textView setText:[phoneFormatter stringToFormattedPhoneNumber:[contactDict valueForKey:@"userUri"]]];
                    else
                        [qs7textView setText:[contactDict valueForKey:@"userUri"]];
                }

            }
            if ( count > 4 )
            {
                contactDict = [contactArray objectAtIndex:4];
                NSLog(@"ContactDictionary4: %@", contactDict);
                
                
                if ( [contactDict valueForKey:@"userImage"] != (id)[NSNull null] )
                    [qs8button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal];
                else
                    [qs8button setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
                
                if ( [contactDict valueForKey:@"userName"] != (id)[NSNull null] )
                    [qs8textView setText: [contactDict valueForKey:@"userName"]];
                else
                {
                    NSString * numOnly = [[[contactDict valueForKey:@"userUri"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    
                    if ( [numOnly isEqualToString:[contactDict valueForKey:@"userUri"]] )
                        [qs8textView setText:[phoneFormatter stringToFormattedPhoneNumber:[contactDict valueForKey:@"userUri"]]];
                    else
                        [qs8textView setText:[contactDict valueForKey:@"userUri"]];
                }

            }
            if ( count > 5 )
            {
                contactDict = [contactArray objectAtIndex:5];
                NSLog(@"ContactDictionary5: %@", contactDict);
                
                if ( [contactDict valueForKey:@"userImage"] != (id)[NSNull null] )
                    [qs9button  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal];
                else
                    [qs9button setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
                
                if ( [contactDict valueForKey:@"userName"] != (id)[NSNull null] )
                    [qs9textView setText: [contactDict valueForKey:@"userName"]];
                else
                {
                    NSString * numOnly = [[[contactDict valueForKey:@"userUri"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    
                    if ( [numOnly isEqualToString:[contactDict valueForKey:@"userUri"]] )
                        [qs9textView setText:[phoneFormatter stringToFormattedPhoneNumber:[contactDict valueForKey:@"userUri"]]];
                    else
                        [qs9textView setText:[contactDict valueForKey:@"userUri"]];
                }

            }
            
            
            NSLog(@"Successful Finish of Count Block");
        }
    }
    
    NSLog(@"Removing from superview.");
    
}


@end
