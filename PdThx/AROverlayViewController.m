#import "AROverlayViewController.h"
#import "PdThxAppDelegate.h"

@interface AROverlayViewController ()
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation AROverlayViewController

@synthesize captureManager;
@synthesize CheckImageReturnDelegate;
@synthesize scanningLabel;
@synthesize scanButton;
@synthesize helpButton;
@synthesize dismissButton;
@synthesize helpIndicator;
@synthesize pictureBeingTaken;
@synthesize holdSteadyLabel;

- (void)viewDidLoad
{
    [self setWantsFullScreenLayout:YES];
    
	[self setCaptureManager:[[[CaptureSessionManager alloc] init] autorelease]];
    
	[[self captureManager] addVideoInputFrontCamera:YES]; // set to YES for Front Camera, No for Back camera
    
    [[self captureManager] addStillImageOutput];
    
	[[self captureManager] addVideoPreviewLayer];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundImageView setImage:[UIImage imageNamed:@"bg-checkcapture-320x480.png"]];
    [[self view] addSubview:backgroundImageView];
    [backgroundImageView release];
    
    CGRect layerRect = CGRectMake(28.5,15.5,354/2,898/2);
    [[[self captureManager] previewLayer] setBounds:layerRect];
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
    UIImage *scanImage = [UIImage imageNamed:@"btn-takepic-48x37-active.png"];
    scanButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-scanImage.size.width-25, self.view.frame.size.height-scanImage.size.height-10, 37, 48)];
    [scanButton setBackgroundImage:scanImage forState:UIControlStateNormal];
    [scanButton setBackgroundImage:scanImage forState:UIControlStateSelected];
    [scanButton setBackgroundImage:scanImage forState:UIControlStateHighlighted];
    [scanButton addTarget:self action:@selector(scanButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    UIImage *helpImage = [UIImage imageNamed:@"btn-takepic-48x37.png"];
    helpButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-helpImage.size.width-5, 10, 37, 48)];
    [helpButton setBackgroundImage:helpImage forState:UIControlStateNormal];
    [helpButton setBackgroundImage:helpImage forState:UIControlStateSelected];
    [helpButton setBackgroundImage:helpImage forState:UIControlStateHighlighted];
    [helpButton addTarget:self action:@selector(helpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpButton];
    
    holdSteadyLabel = [[UILabel alloc] init];
    holdSteadyLabel.transform = CGAffineTransformMakeRotation( M_PI/2 );
    holdSteadyLabel.frame = CGRectMake(0,0,30,self.view.frame.size.height); //Height will become width after rotation
    holdSteadyLabel.textAlignment = UITextAlignmentCenter;
    holdSteadyLabel.text = @"Hold steady";
    holdSteadyLabel.textColor = [UIColor redColor];
    holdSteadyLabel.backgroundColor = [UIColor clearColor];
    holdSteadyLabel.hidden = YES;
    
    [self.view addSubview:holdSteadyLabel];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
    
    pictureBeingTaken = false;
    
	[[captureManager captureSession] startRunning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)saveImageToPhotoAlbum 
{
    if ( pictureBeingTaken )
    {
        NSLog(@"Trying to save image: %@", [self.captureManager stillImage]);
        
        pictureBeingTaken = false;
        [CheckImageReturnDelegate cameraReturnedImage:[self.captureManager stillImage]];
        
        //UIImageWriteToSavedPhotosAlbum([self.captureManager stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        //UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        NSLog(@"Failed to save image to album");
        
    }
    else  // No errors
    {
        // Show message image successfully saved
        NSLog(@"Success saving image to album");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [captureManager release], captureManager = nil;
    [scanButton release];
    [helpIndicator release];
    [dismissButton release];
    [helpButton release];
    [scanningLabel release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)scanButtonPressed
{
    if ( ! pictureBeingTaken ){
        holdSteadyLabel.hidden = NO;
        [self performSelector:@selector(captureImage) withObject:nil afterDelay:2.0];
        pictureBeingTaken = true;
    }
}

-(void)captureImage
{
    if ( pictureBeingTaken ){
        PdThxAppDelegate*appDelegate = (PdThxAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate showWithStatus:@"Please wait" withDetailedStatus:@"Saving Image"];
        
        holdSteadyLabel.hidden = YES;
        [[self captureManager] captureStillImage];
        
        // Haha, I guessed that this function following it would freeze the preview layer so the user can
        // see what they took a picture of, and it works :P
        
        [[[[self captureManager] previewLayer] session] stopRunning];
    }
}

- (void)helpButtonPressed
{
    // App Delegate Display Alert View?
    // Nah, I think a custom help indicator.
    
    helpIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn-takepic-48x37.png"]];
    helpIndicator.frame = CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-40);
    [self.view addSubview:helpIndicator];
    
    UIImage *dismissImage = [UIImage imageNamed:@"btn-takepic-48x37-active.png"];
    dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(helpIndicator.frame.origin.x+10, helpIndicator.frame.origin.y+helpIndicator.frame.size.height/2-dismissImage.size.height/2, 37, 48)];
    
    [dismissButton setBackgroundImage:dismissImage forState:UIControlStateNormal];
    [dismissButton setBackgroundImage:dismissImage forState:UIControlStateSelected];
    [dismissButton setBackgroundImage:dismissImage forState:UIControlStateHighlighted];
    [dismissButton addTarget:self action:@selector(dismissHelpIndicator) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
}

-(void)dismissHelpIndicator {
    [dismissButton removeFromSuperview];
    [helpIndicator removeFromSuperview];
}



@end

