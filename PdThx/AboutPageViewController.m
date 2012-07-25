//
//  AboutPageViewController.m
//  PdThx
//
//  Created by Justin Cheng on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutPageViewController.h"
#import "PdThxAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface AboutPageViewController ()

@end

@implementation AboutPageViewController

@synthesize viewPanel;
@synthesize videoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *htmlString = @"<html><head>\
    <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 270\"/></head>\
    <body style=\"background:#F00;margin-top:0px;margin-left:0px\">\
    <div><object width=\"270\" height=\"140\">\
    <param name=\"movie\" value=\"http://www.youtube.com/v/-bFf3yi7cNM?version=3&amp;hl=en_US&amp;rel=0\"></param>\
    <param name=\"wmode\" value=\"transparent\"></param>\
    <embed src=\"http://www.youtube.com/v/-bFf3yi7cNM?version=3&amp;hl=en_US&amp;rel=0\"\
    type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"270\" height=\"140\"></embed>\
    </object></div></body></html>";
    
    
    [videoView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.your-url.com"]];
    // Do any additional setup after loading the view from its nib.
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [[viewPanel layer] setBorderWidth:1.5];
    [viewPanel.layer setMasksToBounds:YES];
    [[viewPanel layer] setCornerRadius: 8.0];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]) {
       [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-320x44.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    [self setTitle:@"About"];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"AboutPageViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [viewPanel release];
    [toMobileWeb release];
    [videoView release];

    [super dealloc];
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
-(IBAction)linkToMobileWeb:(id)sender
{
        NSURL *url = [NSURL URLWithString:@"http://www.paidthx.com/mobile"];
    [[UIApplication sharedApplication] openURL:url];
}



- (void)viewDidUnload {
    [viewPanel release];
    viewPanel = nil;
    [toMobileWeb release];
    toMobileWeb = nil;
    [videoView release];
    videoView = nil;

    [super viewDidUnload];
}
@end
