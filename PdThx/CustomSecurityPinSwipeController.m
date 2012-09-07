//
//  CustomSecurityPinSwipeController.m
//  PdThx
//
//  Created by James Rhodes on 6/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomSecurityPinSwipeController.h"
#import "PdThxAppDelegate.h"

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
@synthesize navigationBar;
@synthesize contactImageButton;

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
    
    [securityPinSwipeDelegate swipeDidComplete:self withPin:securityPin];

}
- (void)dealloc
{
    [navigationBar release];
    [contactImageButton release];
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
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setTitle: navigationTitle];
    
    didCancel = false;
    
    ALUnlockPatternView *custom=[[[ALUnlockPatternView alloc] initWithFrame:CGRectMake(0, 0, viewPinLock.frame.size.width, viewPinLock.frame.size.height)] autorelease];
    custom.lineColor= UIColorFromRGB(0x47ba80);
    custom.lineWidth=15;
    custom.repeatSelection=YES;
    custom.radiusPercentage=10;
    custom.delegate=self;
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-70x70.png"] forState:UIControlStateNormal];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-selected-70x70.png"] forState:UIControlStateSelected];
    [custom setCellsBackgroundImage:[UIImage imageNamed:@"btn-pinswipe-pressed-70x70.png"] forState:UIControlStateHighlighted];
    for (int i=0;i<[custom.cells count];i++) {
        UIButton* b=(UIButton*)[custom.cells objectAtIndex:i];        
        
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        //[b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        b.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        b.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    }
    
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-320x44.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    [contactImageButton.layer setCornerRadius:11.0];
    [contactImageButton.layer setMasksToBounds:YES];
    
    [self.viewPinLock addSubview:custom];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"CustomSecurityPinSwipeController"
                                        withError:&error]){
        //Handle Error Here
    }

    //[self.view addSubview: header];
    //[self.view addSubview:body];
}

-(void)viewDidAppear:(BOOL)animated
{    
    lblHeader.text = headerText;
    
    UIImage *bgImage = [UIImage imageNamed:@"BTN-Nav-Cancel-68x30.png"];
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsBtn setImage:bgImage forState:UIControlStateNormal];
    settingsBtn.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
    
    [settingsBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsBtn];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
}

-(void)cancelClicked {
    [securityPinSwipeDelegate swipeDidCancel:self];
}
- (void)viewDidUnload
{
    [navigationBar release];
    navigationBar = nil;
    [contactImageButton release];
    contactImageButton = nil;
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
