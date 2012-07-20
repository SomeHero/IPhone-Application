#import "AROverlayViewController.h"

@interface AROverlayViewController ()
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
@end

@implementation AROverlayViewController

@synthesize captureManager;
@synthesize scanningLabel;
@synthesize scanButton;
@synthesize helpButton;
@synthesize dismissButton;
@synthesize helpIndicator;
@synthesize pictureDelegate;

- (void)viewDidLoad {
    
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveImageToPhotoAlbum) name:kImageCapturedSuccessfully object:nil];
	[[captureManager captureSession] startRunning];
}


- (void)saveImageToPhotoAlbum 
{
    UIImageWriteToSavedPhotosAlbum([[self captureManager] stillImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else {
        // TODO: IMPLEMENT FINISHED SUCCESSFULLY POPOVER
        [pictureDelegate checkImageDidReturn:image];
        // TODO: CALL IMAGE ADDED DELEGATE
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [captureManager release], captureManager = nil;
    [scanButton release];
    [helpIndicator release];
    [dismissButton release];
    [helpButton release];
    [scanningLabel release];
    [pictureDelegate release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)scanButtonPressed {
	// TODO: LOAD ONSCREEN TEXT VIEW WITH "HOLD STEADY"...
    
    
    // TODO: TIMER FUNCTION 2 SECOND DELAY THEN CALL BELOW METHOD
    [[self captureManager] captureStillImage];
}


- (void)helpButtonPressed {
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

