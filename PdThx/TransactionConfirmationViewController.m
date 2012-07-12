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
    NSError *error;
    if(![[GANTracker sharedTracker] trackPageview:@"TransactionConfirmationViewController"
                                        withError:&error]){
        //Handle Error Here
    }
}
-(void)viewDidAppear:(BOOL)animated {
    lblConfirmationHeader.text = confirmationText;
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

-(IBAction) btnHomeClicked:(id) sender {
    
    [self dismissModalViewControllerAnimated:YES];
    
    [transactionConfirmationDelegate onHomeClicked];
       
}
-(IBAction) btnContinueClicked: (id) sender {
    [self dismissModalViewControllerAnimated: YES];
    
    [transactionConfirmationDelegate onContinueClicked];
}
-(IBAction) btnFacebookShare:(id) sender {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    if ( [prefs valueForKey:@"facebookId"] && [[prefs valueForKey:@"facebookId"] length] > 0 ) 
    {
        Facebook * fBook;
        fBook = ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fBook;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            fBook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            fBook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        
        if ( [fBook isSessionValid] ){
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           ((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]).fbAppId, @"app_id",
                                           @"JUST WORK DAMMIT, follow this link! http://www.paidthx.com", @"message",
                                           @"http://www.paidthx.com", @"link",
                                           @"http://www.crunchbase.com/assets/images/resized/0019/7057/197057v2-max-250x250.png", @"picture",
                                           @"Try out PaidThx!", @"name",
                                           [NSString stringWithFormat:@"%@ sent money to me for FREE!",@"Chris"], @"caption",
                                           @"Using PaidThx, you can send money to ANYONE, even my favorite cause, from ANYWHERE!. Available for iPhone/Android to give you complete mobile control.", @"description",
                                           nil];
            
            
            [fBook requestWithGraphPath:@"feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
        }
    }
}

-(IBAction) btnTwitterShare:(id) sender {
    
}


@end
