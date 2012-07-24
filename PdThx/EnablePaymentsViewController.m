//
//  EnablePaymentsViewController.m
//  PdThx
//
//  Created by James Rhodes on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnablePaymentsViewController.h"
#import "TakeCheckPictureProtocol.h"

@implementation EnablePaymentsViewController

@synthesize message;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)checkImageDidReturn:(UIImage *)image
{
    // Image Returned, deal with it.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    SetupNavigationView *setupNavBar = [[SetupNavigationView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
    [setupNavBar setActiveState:@"Enable Payments" withJoinComplete:YES whereActivateComplete:YES wherePersonalizeComplete:NO whereEnableComplete:NO];
    [navBar addSubview:setupNavBar];
    
    [self setTitle: @"Enable Payments"];
    

    NSError *error;
    //if(![[GANTracker sharedTracker] trackPageview:@"PersonalizeViewController"
    //                                   withError:&error]){
    //Handle Error Here
    // }
}
-(void)viewDidAppear:(BOOL)animated {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyy"];
    
    [lblOutstandingHeader setText: [NSString stringWithFormat: @"You have $%0.2f waiting for you!", [message.amount doubleValue]]];
    [lblOutstandingSender setText: [NSString stringWithFormat: @"%@ sent you $%0.2f", message.senderName, [message.amount doubleValue]]];
    [lblOutstandingDate setText:[dateFormatter stringFromDate: message.createDate]];
    
    NSString*	s;
	NSString*	art		= @"bg-message-stretch.png";
	CGSize		caps		= CGSizeMake(25, 24);
	UIFont*		font		= [UIFont fontWithName:@"Helvetica-Oblique"  size: 12];
	CGFloat		padTRBL[4]	= {15, 8, 8, 8};
	UIView*		bubble;
    
	// Create bubble
	s = [NSString stringWithFormat: @"\"%@\"", message.comments];
    
    bubble =[self makeBubbleWithWidth:220 font:font text:s background:art caps:caps padding:padTRBL];
	bubble.frame = CGRectMake(0, 0, bubble.frame.size.width, bubble.frame.size.height);
	[quoteBubble addSubview:bubble];
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

-(IBAction)btnRemindMeLaterClicked:(id)sender {
    
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) endUserSetupFlow];
    
}
-(IBAction)btnAddBankAccountClicked:(id)sender {
    [((PdThxAppDelegate*)[[UIApplication sharedApplication] delegate]) startUserSetupFlow];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (UIView*)makeBubbleWithWidth:(CGFloat)w font:(UIFont*)f text:(NSString*)s background:(NSString*)fn caps:(CGSize)caps padding:(CGFloat*)padTRBL
{
	// Create label
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 1)];
    
	// Configure (for multi-line word-wrapping)
	label.font = f;
	label.numberOfLines = 0;
	label.lineBreakMode = UILineBreakModeWordWrap;
    
	// Set and size
	label.text = s;
	[label sizeToFit];
    
	// Size and create final view
	CGSize finalSize = CGSizeMake(label.frame.size.width+padTRBL[1]+padTRBL[3], label.frame.size.height+padTRBL[0]+padTRBL[2]);
	UIView* finalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, finalSize.width, finalSize.height)];
    
	// Create stretchable BG image
	UIImage* bubble = [[UIImage imageNamed:fn] stretchableImageWithLeftCapWidth:caps.width topCapHeight:caps.height];
	UIImageView* background = [[UIImageView alloc] initWithImage:bubble];
	background.frame = finalView.frame;
    
	// Assemble composite (with padding for label)
	[finalView addSubview:background];
	[finalView addSubview:label];
    //label.textColor = UIColorFromRGB(0x676767);
	label.backgroundColor = [UIColor clearColor];
	label.frame = CGRectMake(padTRBL[3], padTRBL[0], label.frame.size.width, label.frame.size.height);
    
	// Clean and return
	[label release];
	[background release];
	return [finalView autorelease];
}


@end
