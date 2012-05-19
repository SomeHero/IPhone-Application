//***************************************************************
 //  ALUnlockPatternView.m
 //  ALUnlockPatternViewDemo
 //
 //  This software is provided AS IS. 
 //  AnguriaLab grants you the right to use and modify this 
 //  code for commercial use as part of your software.
 //
 //  Any distribution of this source code or of any library 
 //  containing this source code is strictly prohibited.
 //
 //  For any support, contact us at support@mobilebricks.com
 //
 //  Looking for another component or piece of code? We can help! 
 //  Get in touch at http://www.mobilebricks.com 
 //
 //  Copyright 2011 AnguriaLab LLC. All rights reserved.
 //****************************************************************/

#include <QuartzCore/QuartzCore.h>
#import "ALUnlockPatternView.h"

#pragma mark -
#pragma mark Private Interface
@interface ALUnlockPatternView (Private)
-(int) getCellFromPoint:(CGPoint) point;
-(BOOL) isInsideTheRadius:(CGPoint) point cellIndex:(int) index;
-(float) distanceBetweenTwoPoints:(CGPoint) point1 point2:(CGPoint) point2;
@end

@implementation ALUnlockPatternView

@synthesize cells=_cells;
@synthesize showLine=_showLine;
@synthesize lineWidth=_lineWidth;
@synthesize lineColor=_lineColor;
@synthesize repeatSelection=_repeatSelection;
@synthesize radiusPercentage=_radiusPercentage;
@synthesize delegate=_delegate;


#pragma mark -
#pragma mark Private Methods
/**
 *  Passing a point of this view, returns in which of the 9 cells is this point
 */
-(int) getCellFromPoint:(CGPoint) point{
    int row=point.y/(self.frame.size.height/3);
    int col=point.x/(self.frame.size.width/3);
    return (col+1)+(row*3);
}
/**
 *  Check if the input point is inside the selection range of the 'index' cell
 */
-(BOOL) isInsideTheRadius:(CGPoint) point cellIndex:(int) index{
    float minSide=MIN(self.frame.size.height/3, self.frame.size.width/3);
    _radius=minSide*_radiusPercentage/100;
    UIButton *btn=(UIButton *)[self viewWithTag:index];
    float distance=[self distanceBetweenTwoPoints:btn.center point2:point];
    if (distance<=_radius*2)
        return YES;
    else
        return NO;
}
/**
 *  Return the distance between two points
 */
-(float) distanceBetweenTwoPoints:(CGPoint) point1 point2:(CGPoint) point2{
    float dx = point2.x - point1.x;
    float dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};
#pragma mark -
#pragma mark Override Methods
- (id)initWithFrame:(CGRect)frame
{
    float width=frame.size.width;
    float height=frame.size.height;
    
    //if (width>kMinSideLength)
    //    width=kMinSideLength;
    
    //if (height>kMinSideLength)
    //    height=kMinSideLength;
    
    self = [super initWithFrame:CGRectMake(frame.origin.x,frame.origin.y,width,height)];
    if (self) {
        // Initialization code
        _radiusPercentage=kRadiusPercentage;
        _lineColor=kLineColor;
        _lineWidth=kLineWidth;
        _repeatSelection=NO;
        _showLine=YES;
        NSMutableArray *cellCollection=[[[NSMutableArray alloc] init] autorelease];
        for (int i=1; i<=9; i++) {
            UIButton *cell=[UIButton buttonWithType:UIButtonTypeCustom];
            cell.tag=i;
            cell.frame=CGRectMake( ((i-1)%3)*self.frame.size.width/3,
                                  ((i-1)/3)*self.frame.size.height/3,
                                  self.frame.size.width/3,
                                  self.frame.size.height/3);
            //cell.layer.borderWidth=1.0;
            cell.userInteractionEnabled=NO;
            cell.adjustsImageWhenHighlighted=NO;
            [cell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //[cell setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            [self addSubview:cell];
            [cellCollection addObject:cell];
        }
        _cells=[[NSArray arrayWithArray:cellCollection] retain];
        self.backgroundColor=[UIColor clearColor];
        _pointsList=[[NSMutableArray alloc] init];
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _touchStopped=NO;
    if (_matrixValues)
        [_matrixValues release];
    _matrixValues=[[NSMutableString alloc] initWithString:@"000000000"];
    if (_code)
        [_code release];
    _code=[[NSMutableString alloc] initWithString:@""];
    [_pointsList removeAllObjects];
    for (UIButton *b in _cells) {
        b.selected=NO;
        b.highlighted=NO;
    }
    UITouch *touch = [touches anyObject];    
    _lastCellSelected=[self getCellFromPoint:[touch locationInView:self]];
    UIButton *btn=(UIButton *)[self viewWithTag:_lastCellSelected];
    
    if ( [btn backgroundImageForState:UIControlStateHighlighted] !=  [btn backgroundImageForState:UIControlStateNormal])
        btn.highlighted=YES;
    else
        btn.selected=YES;
    
    PointObject *pt=[[[PointObject alloc] init] autorelease];
    pt.point=btn.center;
    _startPoint=btn.center;
    [_pointsList addObject:pt];
    [_matrixValues replaceCharactersInRange:NSMakeRange(_lastCellSelected-1,1) withString:@"1"];
    [_code appendFormat:@"%d",_lastCellSelected];
    if ([_delegate respondsToSelector:@selector(unlockPatternView:didSelectCellAtIndex:andpartialCode:)])
        [_delegate unlockPatternView:self didSelectCellAtIndex:_lastCellSelected andpartialCode:_code];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_touchStopped)
        return;
    BOOL addPoint=YES;
    UITouch *touch = [touches anyObject];
    _endPoint = [touch locationInView:self];
    
    //check if current touch is out of the view border limits
    if (_endPoint.x < 0 ||
        _endPoint.x > self.frame.size.width ||
        _endPoint.y < 0 ||
        _endPoint.y > self.frame.size.height) {        
        //[self touchesEnded:nil withEvent:nil]; ** Removed because we don't care if their finger leaves the window, just if they let go. **
        //_touchStopped=YES;
        return;
    }
    
    int i=[self getCellFromPoint:_endPoint];
    if (i!=_lastCellSelected) {
        if ([self isInsideTheRadius:_endPoint cellIndex:i]) {
            UIButton *btn=(UIButton *)[self viewWithTag:i];
            PointObject *pt=[[[PointObject alloc] init] autorelease];
            pt.point=btn.center;
            if (!_repeatSelection) {
                for (PointObject *ptElement in _pointsList) {
                    if (pt.point.x == ptElement.point.x &&
                        pt.point.y == ptElement.point.y){
                        addPoint=FALSE;
                        break;
                    }
                }
            }
            if (addPoint) {
                [_pointsList addObject:pt];
                UIButton *btn=(UIButton *)[self viewWithTag:_lastCellSelected];
                UIButton *btn2=(UIButton *)[self viewWithTag:i];
                if ( [btn2 backgroundImageForState:UIControlStateHighlighted] !=  
                    [btn2 backgroundImageForState:UIControlStateNormal]){
                    btn.selected=YES;
                    btn.highlighted=NO;
                    btn2.selected=NO;
                    btn2.highlighted=YES;
                }
                else{
                    btn2.selected=YES;
                }
                
                _lastCellSelected=i;
                [_matrixValues replaceCharactersInRange:NSMakeRange(_lastCellSelected-1,1) withString:@"1"];
                [_code appendFormat:@"%d",_lastCellSelected];
                if ([_delegate respondsToSelector:@selector(unlockPatternView:didSelectCellAtIndex:andpartialCode:)])
                    [_delegate unlockPatternView:self didSelectCellAtIndex:_lastCellSelected andpartialCode:_code];
            }
        }
    }
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!_touchStopped) {
        UIButton *btn=(UIButton *)[self viewWithTag:_lastCellSelected];
        btn.highlighted=NO;
        btn.selected=YES;
        PointObject *last=(PointObject *)[_pointsList objectAtIndex:[_pointsList count]-1];
        _endPoint=last.point;
        if ([_delegate respondsToSelector:@selector(unlockPatternView:selectedCode:)])
            [_delegate unlockPatternView:self selectedCode:_code];
        [self resetPoints];
        for (UIButton *b in _cells) {
            b.selected=NO;
            b.highlighted=NO;
        }
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ([_pointsList count] == 0)
        return;
    if (_showLine) {
        // Drawing code
        //Get the CGContext from this view
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextBeginPath(UIGraphicsGetCurrentContext()); 
        
        //Set the stroke (pen) color
        CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
        //Set the width of the pen mark
        CGContextSetLineWidth(context, _lineWidth);
        for (int i=0;i<[_pointsList count]-1;i++) {
            PointObject *start=(PointObject *)[_pointsList objectAtIndex:i];
            PointObject *end=(PointObject *)[_pointsList objectAtIndex:i+1];
             
            CGContextMoveToPoint(context, start.point.x, start.point.y);
            CGContextAddLineToPoint(context, end.point.x, end.point.y);
            CGContextSetLineCap(context, kCGLineCapRound);
            //Draw it
            CGContextStrokePath(context);
        }
        PointObject *last=(PointObject *)[_pointsList objectAtIndex:[_pointsList count]-1];
        CGContextMoveToPoint(context, last.point.x, last.point.y);
        CGContextAddLineToPoint(context, _endPoint.x, _endPoint.y);
        CGContextSetLineCap(context, kCGLineCapRound);
        //Draw it
        CGContextStrokePath(context);
    }
}
- (void)dealloc
{
    if (_cells)
        [_cells release];
    if (_pointsList)
        [_pointsList release];
    if (_matrixValues)
        [_matrixValues release];
    if (_code)
        [_code release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public Methods
-(BOOL) isCellSelected:(int) cellNumber{
    char cell=[_matrixValues characterAtIndex:cellNumber-1];
    if (cell == '0')
        return NO;
    return YES;
}
-(void) setRadiusPercentage:(float) value{
    if (value<5)
        _radiusPercentage=5;
    else if(value > 100)
        _radiusPercentage=100;
    else
        _radiusPercentage=value;
}
-(void) setCellsBackgroundImage:(UIImage*) image forState:(UIControlState) state{
    for (UIButton *btn in _cells) {
        [btn setBackgroundImage:image forState:state];
    }
}

-(void) setCellBackgroundImage:(UIImage*) image forState:(UIControlState) state atIndex:(int) index{
    if (index<1 || index>9) {
        NSLog(@"Wrong index; the index value must be between 1 and 9!");
        return;
    }
    UIButton *btn=(UIButton*)[_cells objectAtIndex:index-1];
    [btn setBackgroundImage:image forState:state];
}
-(void)resetPoints{
    [_pointsList removeAllObjects];
}
@end

@implementation PointObject
@synthesize point;
@end
