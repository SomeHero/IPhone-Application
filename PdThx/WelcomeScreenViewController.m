//
//  WelcomeScreenViewController.m
//  PdThx
//
//  Created by Justin Cheng on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "CreateAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UINavigationBar+CustomImage.h"

@interface WelcomeScreenViewController ()

@end

@implementation WelcomeScreenViewController;

@synthesize viewPanel, firstTimeUserButton, currentUserButton;

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
    // Do any additional setup after loading the view from its nib.
    
    [[viewPanel layer] setBorderColor: [[UIColor colorWithHue:0 saturation:0 brightness: 0.81 alpha:1.0] CGColor]];
    [viewPanel.layer setMasksToBounds:YES];
    [[viewPanel layer] setBorderWidth:1.5];
    [[viewPanel layer] setCornerRadius: 8.0];
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"WelcomeScreenViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}
-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [firstTimeUserButton release];
    firstTimeUserButton = nil;
    [currentUserButton release];
    currentUserButton = nil;
    [viewPanel release];
    viewPanel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [firstTimeUserButton release];
    [currentUserButton release];
    [viewPanel release];
    [super dealloc];
}

- (IBAction)newToPaidThxButtonAction:(id)sender {
    
    CreateAccountViewController *ViewC = [[CreateAccountViewController alloc] initWithNibName:@"CreateAccountViewController" bundle:nil];
    [self.navigationController pushViewController:ViewC animated:YES];
}

- (IBAction)alreadyUsePaidThxButtonAction:(id)sender {
    //SignInViewController *VC = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    //[self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)firstTimeUserButtonPressed:(id)sender 
{
    [self.tabBarController setSelectedIndex:2];
}

- (IBAction)currentUserButtonPressed:(id)sender
{
    [self.tabBarController setSelectedIndex:1];
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
