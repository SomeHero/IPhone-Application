//
//  TransactionConfirmationViewController.m
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TransactionConfirmationViewController.h"


@implementation TransactionConfirmationViewController

@synthesize confirmationText;
@synthesize transactionConfirmationDelegate;
@synthesize btnContinue;
@synthesize continueButtonText;
@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    [lblConfirmationHeader dealloc];
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
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar-320x44.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    user = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).user;
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"TransactionConfirmationViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    lblConfirmationHeader.text = confirmationText;
    [btnContinue setTitle:continueButtonText forState:UIControlStateNormal
    ];
    [btnContinue setTitle:continueButtonText forState:UIControlStateSelected
     ];
    
    [btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
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

-(IBAction) btnHomeClicked:(id) sender
{    
    [self dismissModalViewControllerAnimated:YES];
    
    [transactionConfirmationDelegate onHomeClicked];       
}

-(IBAction) btnContinueClicked: (id) sender {
    [self dismissModalViewControllerAnimated: YES];
    
    [transactionConfirmationDelegate onContinueClicked];
}

-(IBAction) btnFacebookShare:(id) sender
{
    /*
    TODO: Reimplement Sharing with Facebook Active Session...
    NSMutableDictionary* params = [NSMutableDictionary
                                   dictionaryWithObjectsAndKeys:
                                   @"Share on Facebook",  @"user_message_prompt",
                                   @"http://www.crunchbase.com/assets/images/resized/0019/7057/197057v2-max-250x250.png", @"link",
                                   @"PaidThx", @"name",
                                   @"The FREE Social Payment Network", @"caption",
                                   @"With PaidThx, sending money to anyone is simple and doesn't cost you a penny.", @"description",
                                   nil];
    
    [fBook dialog:@"feed" andParams:params andDelegate:self];
     */
}

-(IBAction) btnTwitterShare:(id) sender
{
}


@end
