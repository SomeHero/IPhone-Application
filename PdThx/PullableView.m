
#import "PullableView.h"
#import <UIKit/UIKit.h>


/**
 @author Fabio Rodella fabio@crocodella.com.br
 */

@implementation PullableView

@synthesize handleView;
@synthesize closedCenter;
@synthesize openedCenter;
@synthesize dragRecognizer;
@synthesize tapRecognizer;
@synthesize animate;
@synthesize animationDuration;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        animate = YES;
        animationDuration = 0.7;
        
        toggleOnTap = YES;
        
        // Creates the handle view. Subclasses should resize, reposition and style this view
        handleView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 40)];
        [self addSubview:handleView];
        [handleView release];
        
        dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
        dragRecognizer.minimumNumberOfTouches = 1;
        dragRecognizer.maximumNumberOfTouches = 1;
        
        [self addGestureRecognizer:dragRecognizer];
        [dragRecognizer release];
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        
        [handleView addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
        
        opened = NO;
    }
    return self;
}

- (void)handleDrag:(UIPanGestureRecognizer *)sender {
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        
        startPos = self.center;
        
        // Finds the minimum and maximum points in the axis
        minPos = closedCenter.x < openedCenter.x ? closedCenter : openedCenter;
        maxPos = closedCenter.x > openedCenter.x ? closedCenter : openedCenter;
    
    } else if ([sender state] == UIGestureRecognizerStateChanged) {
                
        CGPoint translate = [sender translationInView:self.superview];
        
        CGPoint newPos;
        
        // Moves the view, keeping it constrained between openedCenter and closedCenter
        newPos = CGPointMake(startPos.x + translate.x, startPos.y);
            
        if (newPos.x < minPos.x) {
            newPos.x = minPos.x;
            translate = CGPointMake(newPos.x - startPos.x, 0);
        }
            
        if (newPos.x > maxPos.x) {
            newPos.x = maxPos.x;
            translate = CGPointMake(newPos.x - startPos.x, 0);
        }
        
        [delegate pullableView:self didMoveLocation:((float)translate.x)/((float)(maxPos.x/2))];
        [sender setTranslation:translate inView:self.superview];
        
        self.center = newPos;
        
    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        
        // Gets the velocity of the gesture in the axis, so it can be
        // determined to which endpoint the state should be set.
        
        CGPoint vectorVelocity = [sender velocityInView:self.superview];
        CGFloat axisVelocity =  vectorVelocity.x;
        
        CGPoint target = axisVelocity < 0 ? minPos : maxPos;
        BOOL op = CGPointEqualToPoint(target, openedCenter);
        
        [self setOpened:op animated:animate];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self setOpened:!opened animated:animate];
    }
}

- (void)setToggleOnTap:(BOOL)tap {
    toggleOnTap = tap;
    tapRecognizer.enabled = tap;
}

- (BOOL)toggleOnTap {
    return toggleOnTap;
}

- (void)setOpened:(BOOL)op animated:(BOOL)anim {
    opened = op;
    
    
    [delegate pullableView:self startedAnimation:animationDuration withDirection:( opened ? YES : NO )];
    
    
    if (anim) {
        
        // For the duration of the animation, no further interaction with the view is permitted
        dragRecognizer.enabled = NO;
        tapRecognizer.enabled = NO;
        
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.center = opened ? openedCenter : closedCenter;
        } completion:^(BOOL finished) {
            [self animationDidStop:@"Slideover" finished:[NSNumber numberWithBool:TRUE] context:nil];
        }];
        
    } else {
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
        }
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (finished) {
        // Restores interaction after the animation is over
        dragRecognizer.enabled = YES;
        tapRecognizer.enabled = toggleOnTap;
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
        }
    }
}

@end
