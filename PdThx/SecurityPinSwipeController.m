//
//  SecurityPinSwipeController.m
//  PdThx
//
//  Created by James Rhodes on 6/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SecurityPinSwipeController.h"


@implementation SecurityPinSwipeController

@synthesize viewLoadedFromXib;

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
        
		[[NSBundle mainBundle] loadNibNamed:@"SecurityPinSwipeController" owner:self options:nil];
        _viewLock=[[[ALUnlockPatternView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        
        _viewLock.delegate=self;
        _viewLock.lineColor=[UIColor whiteColor];
        _viewLock.lineWidth=12;
        _viewLock.lineColor=[UIColor colorWithRed:0.576 green:0.816 blue:0.133 alpha:1.000];
        [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"nSel.png"] forState:UIControlStateNormal];
        [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"sel.png"] forState:UIControlStateSelected];
        [_viewLock setCellsBackgroundImage:[UIImage imageNamed:@"hSel.png"] forState:UIControlStateHighlighted];
        
        [_viewLock setHidden:NO];
        
		[self.contentView addSubview:_viewLock];
		
	}	
	return self;
}

- (void)dealloc
{
    [super dealloc];
    
    [_viewLock dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
