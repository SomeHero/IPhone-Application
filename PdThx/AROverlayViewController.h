#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "TakeCheckPictureProtocol.h"

@interface AROverlayViewController : UIViewController <TakeCheckPictureProtocol> 
{
    id<TakeCheckPictureProtocol> pictureDelegate;
}

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property (nonatomic, retain) UIButton *scanButton;
@property (nonatomic, retain) UIButton *helpButton;
@property (nonatomic, retain) UIButton *dismissButton;
@property (nonatomic, retain) UIImageView *helpIndicator;

@property (assign) id pictureDelegate;

@end
