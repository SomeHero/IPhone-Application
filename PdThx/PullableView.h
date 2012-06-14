
#import <UIKit/UIKit.h>

@class PullableView;


@protocol PullableViewDelegate <NSObject>

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened;
- (void)pullableView:(PullableView *)pView didMoveLocation:(float)relativePosition;
- (void)pullableView:(PullableView *)pView startedAnimation:(float)animationDuration withDirection:(BOOL)directionBoolean;

@end




@interface PullableView : UIView 
{
    CGPoint closedCenter;
    CGPoint openedCenter;
    
    UIView *handleView;
    UIPanGestureRecognizer *dragRecognizer;
    UITapGestureRecognizer *tapRecognizer;
    
    CGPoint startPos;
    CGPoint minPos;
    CGPoint maxPos;
    
    BOOL opened;
    
    BOOL toggleOnTap;
    BOOL animate;
    float animationDuration;
    
    id<PullableViewDelegate> delegate;
}

@property (nonatomic,readonly) UIView *handleView;
@property (readwrite,assign) CGPoint closedCenter;
@property (readwrite,assign) CGPoint openedCenter;
@property (nonatomic,readonly) UIPanGestureRecognizer *dragRecognizer;
@property (nonatomic,readonly) UITapGestureRecognizer *tapRecognizer;
@property (readwrite,assign) BOOL toggleOnTap;
@property (readwrite,assign) BOOL animate;
@property (readwrite,assign) float animationDuration;
@property (readwrite,assign) id<PullableViewDelegate> delegate;


- (void)setOpened:(BOOL)op animated:(BOOL)anim;

@end
