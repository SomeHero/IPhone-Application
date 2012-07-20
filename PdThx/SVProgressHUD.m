//
//  SVProgressHUD.m
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVProgressHUD
//

#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

#if ! __has_feature(objc_arc)
#error You need to either convert your project to ARC or add the -fobjc-arc compiler flag to SVProgressHUD.m.
#endif

@interface SVProgressHUD ()

@property (nonatomic, readwrite) SVProgressHUDMaskType maskType;
@property (nonatomic, strong, readonly) NSTimer *fadeOutTimer;

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIView *hudView;
@property (nonatomic, strong, readonly) UILabel *stringLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinnerView;

@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;

- (void)showWithStatus:(NSString*)string maskType:(SVProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show;
- (void)showImage:(UIImage*)image status:(NSString*)status duration:(NSTimeInterval)duration;
- (void)dismiss;

- (void)setStatus:(NSString*)string;
- (void)registerNotifications;
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle;
- (void)positionHUD:(NSNotification*)notification;

@end


@implementation SVProgressHUD

@synthesize overlayWindow, hudView, maskType, fadeOutTimer, stringLabel, imageView, spinnerView, visibleKeyboardHeight;

- (void)dealloc {
	self.fadeOutTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (SVProgressHUD*)sharedView {
    static dispatch_once_t once;
    static SVProgressHUD *sharedView;
    dispatch_once(&once, ^ { sharedView = [[SVProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}


+ (void)setStatus:(NSString *)string 
{
	[[SVProgressHUD sharedView] setStatus:string];
}

#pragma mark - Show Methods

+ (void)show {
    [[SVProgressHUD sharedView] showWithStatus:nil maskType:SVProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithStatus:(NSString *)status {
    [[SVProgressHUD sharedView] showWithStatus:status maskType:SVProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithMaskType:(SVProgressHUDMaskType)maskType {
    [[SVProgressHUD sharedView] showWithStatus:nil maskType:maskType networkIndicator:NO];
}

+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType {
    [[SVProgressHUD sharedView] showWithStatus:status maskType:maskType networkIndicator:NO];
}

#pragma mark - Show then dismiss methods

+ (void)showSuccessWithStatus:(NSString *)string {
    [SVProgressHUD showImage:[UIImage imageNamed:@"loadingPassed62x62.png"] status:string];
}

+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    [SVProgressHUD show];
    [SVProgressHUD showImage:[UIImage imageNamed:@"loadingPassed62x62.png"] status:string];
}

+ (void)showErrorWithStatus:(NSString *)string {
    [SVProgressHUD showImage:[UIImage imageNamed:@"loadingFailed62x62.png"] status:string];
}

+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    [SVProgressHUD show];
    [SVProgressHUD showImage:[UIImage imageNamed:@"loadingFailed62x62.png"] status:string];
}

+ (void)showImage:(UIImage *)image status:(NSString *)string {
    if ( image == [UIImage imageNamed:@"loadingFailed62x62.png"] )
        [[SVProgressHUD sharedView] showImage:image status:string duration:1.5];
    else
        [[SVProgressHUD sharedView] showImage:image status:string duration:0.8];
     
}


#pragma mark - Dismiss Methods

+ (void)dismiss {
	[[SVProgressHUD sharedView] dismiss];
}

+ (void)dismissWithSuccess:(NSString*)string {
	[SVProgressHUD showSuccessWithStatus:string];
}

+ (void)dismissWithSuccess:(NSString *)string afterDelay:(NSTimeInterval)seconds {
    [[SVProgressHUD sharedView] showImage:[UIImage imageNamed:@"loadingPassed62x62.png"] status:string duration:seconds];
}

+ (void)dismissWithError:(NSString*)string {
	[SVProgressHUD showErrorWithStatus:string];
}

+ (void)dismissWithError:(NSString *)string afterDelay:(NSTimeInterval)seconds {
    [[SVProgressHUD sharedView] showImage:[UIImage imageNamed:@"loadingFailed62x62.png"] status:string duration:seconds];
}


#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.maskType) {
        case SVProgressHUDMaskTypeBlack: {
            [[UIColor whiteColor] set];
            CGContextSetAlpha(context, 0.65);
            CGContextFillRect(context, self.bounds);
            break;
        }
            
        case SVProgressHUDMaskTypeGradient: {
            
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f}; 
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
            break;
        }
    }
}

- (void)setStatus:(NSString *)string {
    self.maskType = SVProgressHUDMaskTypeBlack;
    CGFloat hudWidth = 171.0;
    CGFloat hudHeight = 171.0;
    CGRect labelRect = CGRectZero;
    
    /*
     CGRect labelRect = CGRectZero;
     CGSize labelSize = CGSizeMake(160.0, 20.0);
     CGPoint labelCenter = CGPointMake(171/2, 131);
     labelRect = CGRectMake(labelCenter.x, labelCenter.y-(labelSize.width/2), labelSize.width, labelSize.height);
     */
    
    labelRect = CGRectMake(10, 131, 151, 20);
    
	self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    self.imageView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+1, self.hudView.bounds.size.height*0.525);
	
	self.stringLabel.hidden = NO;
	self.stringLabel.text = string;
    self.stringLabel.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
    self.stringLabel.adjustsFontSizeToFitWidth = YES;
    
	self.stringLabel.frame = labelRect;
    stringLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	
    self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+1, self.hudView.bounds.size.height*0.525);
}

- (void)setFadeOutTimer:(NSTimer *)newTimer 
{
    
    if(fadeOutTimer)
        [fadeOutTimer invalidate], fadeOutTimer = nil;
    
    if(newTimer)
        fadeOutTimer = newTimer;
}


- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification 
                                               object:nil];  
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(positionHUD:) 
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}


- (void)positionHUD:(NSNotification*)notification {
    
    CGFloat keyboardHeight;
    double animationDuration;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(UIInterfaceOrientationIsPortrait(orientation))
                keyboardHeight = keyboardFrame.size.height;
            else
                keyboardHeight = keyboardFrame.size.width;
        } else
            keyboardHeight = 0;
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    if(keyboardHeight > 0)
        activeHeight += statusBarFrame.size.height*2;
    
    activeHeight -= keyboardHeight;
    CGFloat posY = floor(activeHeight*0.45);
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) { 
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI; 
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    } 
    
    if(notification) {
        [UIView animateWithDuration:animationDuration 
                              delay:0 
                            options:UIViewAnimationOptionAllowUserInteraction 
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    } else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
    
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.hudView.transform = CGAffineTransformMakeRotation(angle); 
    self.hudView.center = newCenter;
}

#pragma mark - Master show/dismiss methods

- (void)showWithStatus:(NSString*)string maskType:(SVProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
        self.fadeOutTimer = nil;
        self.imageView.hidden = YES;
        self.maskType = hudMaskType;
        
        [self setStatus:string];
        [self.spinnerView startAnimating];
        
        if(self.maskType != SVProgressHUDMaskTypeNone) {
            self.overlayWindow.userInteractionEnabled = YES;
        } else {
            self.overlayWindow.userInteractionEnabled = NO;
        }
        
        [self.overlayWindow setHidden:NO];
        [self positionHUD:nil];
        
        if(self.alpha != 1) {
            [self registerNotifications];
            self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 2.0, 2.0);
            
            [UIView animateWithDuration:0.15
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{	
                                 self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/2.0, 1/2.0);
                                 self.alpha = 1;
                             }
                             completion:NULL];
        }
        
        [self setNeedsDisplay];
    });
}


- (void)showImage:(UIImage *)image status:(NSString *)string duration:(NSTimeInterval)duration {
    if(![SVProgressHUD isVisible])
        [SVProgressHUD show];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
        self.imageView.hidden = NO;
        [self setStatus:string];
        [self.spinnerView stopAnimating];
        
        self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    });
}


- (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:0.10
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{	
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){ 
                             if(self.alpha == 0) {
                                 [[NSNotificationCenter defaultCenter] removeObserver:self];
                                 [hudView removeFromSuperview];
                                 hudView = nil;

                                 [overlayWindow removeFromSuperview];
                                 overlayWindow = nil;
                             }
                         }];
    });
}

#pragma mark - Utilities

+ (BOOL)isVisible {
    return ([SVProgressHUD sharedView].alpha == 1);
}


#pragma mark - Getters

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
    }
    return overlayWindow;
}

- (UIView *)hudView {
    if(!hudView) {
        hudView = [[UIView alloc] initWithFrame:CGRectZero];
        hudView.layer.cornerRadius = 10;
		UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingImage342x342.png"]];
        //hudView.backgroundColor = [UIColor whiteColor];
        
        [hudView addSubview:bgView];
        
        [self addSubview:hudView];
    }
    return hudView;
}

- (UILabel *)stringLabel {
    if (stringLabel == nil) {
        stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		stringLabel.textColor = [UIColor whiteColor];
		stringLabel.backgroundColor = [UIColor clearColor];
		stringLabel.adjustsFontSizeToFitWidth = YES;
		stringLabel.textAlignment = UITextAlignmentCenter;
		stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		stringLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        stringLabel.numberOfLines = 0;
    }
    
    if(!stringLabel.superview)
        [self.hudView addSubview:stringLabel];
    
    return stringLabel;
}

- (UIImageView *)imageView {
    if (imageView == nil)
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    
    if(!imageView.superview)
        [self.hudView addSubview:imageView];
    
    return imageView;
}

- (UIActivityIndicatorView *)spinnerView {
    if (spinnerView == nil) {
        spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		spinnerView.hidesWhenStopped = YES;
		spinnerView.bounds = CGRectMake(0, 0, 37, 37);
    }
    
    if(!spinnerView.superview)
        [self.hudView addSubview:spinnerView];
    
    return spinnerView;
}

- (CGFloat)visibleKeyboardHeight {
        
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }

    // Locate UIKeyboard.  
    UIView *foundKeyboard = nil;
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:0];
        }                                                                                
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
            foundKeyboard = possibleKeyboard;
            break;
        }
    }
        
    if(foundKeyboard && foundKeyboard.bounds.size.height > 100)
        return foundKeyboard.bounds.size.height;
    
    return 0;
}

@end
