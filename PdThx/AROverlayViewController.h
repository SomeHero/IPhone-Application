#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"

@interface AROverlayViewController : UIViewController {
}

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property (nonatomic, retain) UIButton *scanButton;
@property (nonatomic, retain) UIButton *helpButton;
@property (nonatomic, retain) UIButton *dismissButton;
@property (nonatomic, retain) UIImageView *helpIndicator;


@end
