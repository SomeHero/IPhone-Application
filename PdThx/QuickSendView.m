//
//  QuickSendView.m
//  PdThx
//
//  Created by James Rhodes on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickSendView.h"
#import "PdThxAppDelegate.h"
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
@synthesize noContactsImageView;


- (id)initWithFrame:(CGRect)frame
{
    
    //self = [super initWithFrame:frame]; // not needed - thanks ddickison
	if (self)
    {
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
    NSLog(@"DrawRect called");
    // Drawing code
    // Quick Send Images
    [self.qs1button.layer setCornerRadius:14.0];
    [self.qs1button.layer setMasksToBounds:YES];
    [self.qs1button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs1button.layer setBorderWidth:0.0]; // 28 24 20
    
    [self.qs2button.layer setCornerRadius:14.0];
    [self.qs2button.layer setMasksToBounds:YES];
    [self.qs2button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs2button.layer setBorderWidth:0.0]; // 28 24 20
    
    [self.qs3button.layer setCornerRadius:14.0];
    [self.qs3button.layer setMasksToBounds:YES];
    [self.qs3button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs3button.layer setBorderWidth:0.0]; // 28 24 20
    
    [self.qs4button.layer setCornerRadius:14.0];
    [self.qs4button.layer setMasksToBounds:YES];
    [self.qs4button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs4button.layer setBorderWidth:0.0]; // 28 24 20
    
    [self.qs5button.layer setCornerRadius:14.0];
    [self.qs5button.layer setMasksToBounds:YES];
    [self.qs5button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs5button.layer setBorderWidth:0.0]; // 28 24 20
    
    [self.qs6button.layer setCornerRadius:14.0];
    [self.qs6button.layer setMasksToBounds:YES];
    [self.qs6button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs6button.layer setBorderWidth:0.0]; // 28 24 20
    
    [self.qs7button.layer setCornerRadius:14.0];
    [self.qs7button.layer setMasksToBounds:YES];
    [self.qs7button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs7button.layer setBorderWidth:0.0]; // 28 24 20
    
    [self.qs8button.layer setCornerRadius:14.0];
    [self.qs8button.layer setMasksToBounds:YES];
    [self.qs8button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs8button.layer setBorderWidth:0.0]; // 28 24 20
    
    [self.qs9button.layer setCornerRadius:14.0];
    [self.qs9button.layer setMasksToBounds:YES];
    [self.qs9button.layer setBorderColor:[UIColor colorWithRed:185.0/255.0 green:195.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor]; // 
    [self.qs9button.layer setBorderWidth:0.0]; // 28 24 20
    
    PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self reloadQuickSendContacts:appDelegate.quickSendArray];
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
    
    [noContactsImageView release];
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
    NSLog(@"Loading contacts array with %@",contactArray);
    
    if ( contactArray != (id)[NSNull null] && [contactArray count] > 0 )
    {
        if ( phoneFormatter == nil )
            phoneFormatter = [[PhoneNumberFormatting alloc] init];
        
        [qs4button  setBackgroundImage:NULL forState:UIControlStateNormal];
        [qs4button setHidden:YES];
        qs4textView.text = @"";
        
        [qs5button  setBackgroundImage:NULL forState:UIControlStateNormal];
        [qs5button setHidden:YES];
        qs5textView.text = @"";
        
        [qs6button  setBackgroundImage:NULL forState:UIControlStateNormal];
        [qs6button setHidden:YES];
        qs6textView.text = @"";
        
        [qs7button  setBackgroundImage:NULL forState:UIControlStateNormal];
        [qs7button setHidden:YES];
        qs7textView.text = @"";
        
        [qs8button  setBackgroundImage:NULL forState:UIControlStateNormal];
        [qs8button setHidden:YES];
        qs8textView.text = @"";
        
        [qs9button  setBackgroundImage:NULL forState:UIControlStateNormal];
        [qs9button setHidden:YES];
        qs9textView.text = @"";
        
        
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
                    [self populateQuickSendItemWithContactObject:contactDict forQuickSendContactSlot:4];
                }
                if ( count > 1 )
                {
                    contactDict = [contactArray objectAtIndex:1];
                    [self populateQuickSendItemWithContactObject:contactDict forQuickSendContactSlot:5];
                }
                if ( count > 2 )
                {
                    contactDict = [contactArray objectAtIndex:2];
                    [self populateQuickSendItemWithContactObject:contactDict forQuickSendContactSlot:6];
                }
                if ( count > 3 )
                {
                    contactDict = [contactArray objectAtIndex:3];
                    [self populateQuickSendItemWithContactObject:contactDict forQuickSendContactSlot:7];
                }
                if( count > 4 )
                {
                    contactDict = [contactArray objectAtIndex:4];
                    [self populateQuickSendItemWithContactObject:contactDict forQuickSendContactSlot:8];
                }
                if ( count > 5 )
                {
                    contactDict = [contactArray objectAtIndex:5];
                    [self populateQuickSendItemWithContactObject:contactDict forQuickSendContactSlot:9];
                }
                
                NSLog(@"Successful Finish of Count Block");
            }
        }
        
        NSLog(@"Saving Quicksend Information into App Delegate.");
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate setQuickSendArray:contactArray];
    }
    else
    {
        // Contact list is null, clear the quicksend area and display the no quicksend image
        [qs4button setHidden:YES];
        [qs4textView setHidden:YES];
        
        [qs5button setHidden:YES];
        [qs5textView setHidden:YES];
        
        [qs6button setHidden:YES];
        [qs6textView setHidden:YES];
        
        [qs7button setHidden:YES];
        [qs7textView setHidden:YES];
        
        [qs8button setHidden:YES];
        [qs8textView setHidden:YES];
        
        [qs9button setHidden:YES];
        [qs9textView setHidden:YES];
        
        [noContactsImageView setHidden:NO];
    }
}


-(void)populateQuickSendItemWithContactObject:(NSDictionary*)contactDict forQuickSendContactSlot:(int)slot
{
    UIButton * imageButton;
    UITextView * textView;
    
    switch ( slot )
    {
        case 4:
        {
            imageButton = qs4button;
            textView = qs4textView;
            break;
        }
        case 5:
        {
            imageButton = qs5button;
            textView = qs5textView;
            break;
        }
        case 6:
        {
            imageButton = qs6button;
            textView = qs6textView;
            break;
        }
        case 7:
        {
            imageButton = qs7button;
            textView = qs7textView;
            break;
        }
        case 8:
        {
            imageButton = qs8button;
            textView = qs8textView;
            break;
        }
        case 9:
        {
            imageButton = qs9button;
            textView = qs9textView;
            break;
        }
    }
    
    [imageButton setHidden:NO];
    [textView setHidden:NO];
    [noContactsImageView setHidden:YES];
    
    if ( [contactDict valueForKey:@"userImage"] != (id)[NSNull null] ){
        [imageButton  setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal];
    }
    else
        [imageButton setBackgroundImage:[UIImage imageNamed: @"avatar-50x50.png"] forState:UIControlStateNormal];
    
    if ( [[[contactDict valueForKey:@"userUri"] substringToIndex:3] isEqualToString:@"fb_"] )
    {
        NSLog(@"Setting image for %@ to %@", [contactDict objectForKey:@"userName"], [contactDict objectForKey:@"userImage"]);
        [imageButton setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[contactDict valueForKey:@"userImage"]]]] forState:UIControlStateNormal];
    }
    
    if ( [contactDict valueForKey:@"userName"] != (id)[NSNull null] )
        [textView setText: [contactDict valueForKey:@"userName"]];
    else
    {
        NSString * numOnly = [[[contactDict valueForKey:@"userUri"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        if ( [numOnly isEqualToString:[contactDict objectForKey:@"userUri"] ] )
            [textView setText:[phoneFormatter stringToFormattedPhoneNumber:[contactDict valueForKey:@"userUri"]]];
        else
            [textView setText:[contactDict valueForKey:@"userUri"]];
    }
}

@end
