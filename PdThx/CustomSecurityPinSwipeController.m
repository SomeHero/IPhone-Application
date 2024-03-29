//
//  CustomSecurityPinSwipeController.m
//  PdThx
//
//  Created by James Rhodes on 6/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomSecurityPinSwipeController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CustomSecurityPinSwipeController

@synthesize viewPinLock;
@synthesize navigationItem;
@synthesize securityPinSwipeDelegate;
@synthesize lblHeader;
@synthesize navigationTitle;
@synthesize headerText;
@synthesize tag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)unlockPatternView:(ALUnlockPatternView *)patternView selectedCode:(NSString *)code{
    securityPin = [NSString stringWithString:[code copy]];
    [self dismissModalViewControllerAnimated:YES];

}
- (void)dealloc
{
    [super dealloc];
    
    [viewPinLock release];
    [navigationItem release];
    [securityPinSwipeDelegate release];
    [lblHeader release];
    [headerText release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)viewDidDisappear:(BOOL)animated {
    if(didCancel)
    {
        [securityPinSwipeDelegate swipeDidCancel:self];
        didCancel = false;
    }
    else {
        [securityPinSwipeDelegate swipeDidComplete:self withPin:securityPin];
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setTitle: navigationTitle];
    
    didCancel = false;
    
    ALUnlockPatternView *custom=[[[ALUnlockPatternView alloc] initWithFrame:CGRectMake(0, 0, viewPinLock.frame.size.width, viewPinLock.frame.size.height)] autorelease];
    custom.lineColor= UIColorFromRGB(0xb5e3f0);
    custom.lineWidth=15;
    custom.repeatSelection=YES;
    custom.radiusPercentage=10;
    custom.delegate=self;
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-60x60.png"] forState:UIControlStateNormal];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-selected-60x60.png"] forState:UIControlStateSelected];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-pressed-60x60.png"] forState:UIControlStateHighlighted];
    for (int i=0;i<[custom.cells count];i++) {
        UIButton* b=(UIButton*)[custom.cells objectAtIndex:i];        
        
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        //[b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        b.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        b.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    }
    
    [self.viewPinLock addSubview:custom];

    //[self.view addSubview: header];
    //[self.view addSubview:body];
}
-(void)viewDidAppear:(BOOL)animated {
    
    lblHeader.text = headerText;
    
    UIBarButtonItem *cancelButton =  [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemAction target:self action:@selector(cancelClicked)];
    
    self.navigationItem.leftBarButtonItem= cancelButton;
    [cancelButton release];
}
-(void)cancelClicked {
    didCancel = true;
    
    [self dismissModalViewControllerAnimated:YES];
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

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:100.0 alpha:0.5];
        titleView.shadowOffset = CGSizeMake(0.0,1.5);
        
        //52.0 54.0 61.0 is the grey he wanted
        titleView.textColor = [UIColor colorWithRed:52.0/255.0 green:54.0/255.0 blue:61.0/255.0 alpha:1.0];
        
        self.navigationItem.titleView = titleView;
        [titleView release];
    }
    
    titleView.text = title;
    [titleView sizeToFit];
}


@end
