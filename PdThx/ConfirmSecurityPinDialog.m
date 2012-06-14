//
//  UAModalExampleView.m
//  UAModalPanel
//
//  Created by Matt Coneybeare on 1/8/12.
//  Copyright (c) 2012 Urban Apps. All rights reserved.
//

#import "ConfirmSecurityPinDialog.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation ConfirmSecurityPinDialog

@synthesize viewLoadedFromXib, viewSecurityPinPlaceholder;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {

        // Margin between edge of container frame and panel. Default = 20.0
        self.outerMargin = 20.0;
        
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin = 10.0;
        
        // Border color of the panel. Default = [UIColor whiteColor]
        //self.borderColor = [UIColor colorWithRed:178 green:183 blue: 194 alpha:1.0];
        
        // Border width of the panel. Default = 1.5f;
        //self.borderWidth = .8f;
        
        // Corner radius of the panel. Default = 4.0f
        self.cornerRadius = 8.0f;
        
        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
        self.contentColor =  [UIColor colorWithWhite:0.2 alpha:0.9f];
        // Shows the bounce animation. Default = YES
        self.shouldBounce = YES;
        
		//////////////////////////////////////
		// SETUP CONTENT
		//////////////////////////////////////
        
		[[NSBundle mainBundle] loadNibNamed:@"ConfirmSecurityPinDialog" owner:self options:nil];
		
		NSArray *contentArray = [NSArray arrayWithObjects:viewLoadedFromXib, nil];
		
		int i = arc4random() % [contentArray count];
		v = [[contentArray objectAtIndex:(NSUInteger) i] retain];
        
        _viewLock=[[[ALUnlockPatternView alloc] initWithFrame:CGRectMake(0, 0, viewSecurityPinPlaceholder.frame.size.width-20, 160)] autorelease];
        
        _viewLock.delegate=self;
        _viewLock.lineColor=[UIColor whiteColor];
        _viewLock.lineWidth=12;
        _viewLock.lineColor=[UIColor colorWithRed:0.576 green:0.816 blue:0.133 alpha:1.000];
        [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"nSel.png"] forState:UIControlStateNormal];
        [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"sel.png"] forState:UIControlStateSelected];
        [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"hSel.png"] forState:UIControlStateHighlighted];
        
        [_viewLock setHidden:NO];
        [viewSecurityPinPlaceholder addSubview:_viewLock];
        
		[self.contentView addSubview:v];
		
	}	
	return self;
}
-(void)unlockPatternView:(ALUnlockPatternView *)patternView selectedCode:(NSString *)code{
    
    [_delegate confirmSecurityPinComplete:self selectedCode:code];
    
}

- (void)dealloc {
    [v release];
	[viewLoadedFromXib release];
    [viewSecurityPinPlaceholder release];

    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[v setFrame:self.contentView.bounds];
}

@end