#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "CheckImageReturnProtocol.h"

@interface AROverlayViewController : UIViewController
{
    id<CheckImageReturnProtocol> CheckImageReturnDelegate;
    
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *scanButton;
}

@property (assign) id CheckImageReturnDelegate;

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property (nonatomic, retain) UIButton *scanButton;
@property (nonatomic, retain) UIButton *backButton;

@property (nonatomic, retain) UIButton *dismissButton;
@property (nonatomic, retain) UIImageView *helpIndicator;
@property (nonatomic, retain) UILabel *holdSteadyLabel;

@property (assign) bool pictureBeingTaken;


@end
