/***************************************************************
 //  ALUnlockPatternView.h
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
 ****************************************************************/


#import <UIKit/UIKit.h>

#define kMinSideLength              150
#define kRadiusPercentage           22
#define kLineColor                  [UIColor blueColor]
#define kLineWidth                  5


/**
 *  @mainpage
 *
 *  ALUnlockPatternView it's a component which allow to caputure gestures inside a 3x3 grid
 *  view and store the movement sequence into a string.\n\n 
 *
 *  The typical scenario when you can use this component, is to verify credentials.
 *  You can customize the size of the grid, the images of the cells and you can choose if each
 *  cell of the grid can be selected one or more times if you want to support more complex movements.
 */


@protocol ALUnlockPatternViewDelegate;

@interface ALUnlockPatternView : UIView {
    NSMutableString *_matrixValues;
    NSArray* _cells;
    BOOL _showLine;
    float _lineWidth;
    UIColor *_lineColor;
    BOOL _repeatSelection;
    float _radius;
    float _radiusPercentage;
    id<ALUnlockPatternViewDelegate> _delegate;
    
    CGPoint _startPoint;
    CGPoint _endPoint;
    int _lastCellSelected;
    NSMutableArray *_pointsList;
    NSMutableString *_code;
    BOOL _touchStopped;
}
#pragma mark -
#pragma mark Properties
/**
 *  List of all references of each cell view. 
 *  Every cell view is an instance of UIButton object.
 */
@property(nonatomic,readonly) NSArray* cells;
/**
 *  Indicates if the conjunction line is visible or not.
 *  Default: YES.
 */
@property(nonatomic) BOOL showLine;
/**
 *  Indicates the width of the conjunction line.
 *  Default: 5.0
 */
@property(nonatomic) float lineWidth;
/**
 *  Indicates the color of the conjunction line.
 *  Default: [UIColor blueColor]
 */
@property(nonatomic,retain) UIColor *lineColor;
/**
 *  This parameter, if YES, allow the user to select more then one time the grid cells.
 *  Default: NO
 */
@property(nonatomic) BOOL repeatSelection;
/**
 *  This parameter indicates the touch sensibility for every cell.
 *  To avoid accidentals selections, the sensible zone that intercepts the selection of each single cell is a circular
 *  region which has the center in the center of the cell and radius the value of the minor side of the cell multiplied the
 *  radiusPercentage value.\n
 *  The value range goes from 5.0 to 100.0.
 */
@property(nonatomic) float radiusPercentage;
/**
 *  The delegate that will receive the events of this component
 */
@property(nonatomic,assign) id<ALUnlockPatternViewDelegate> delegate;

#pragma mark -
#pragma mark Public Methods
/**
 *  Return if the cell with index cellNumber is selected or not.
 *  @param[in]      cellNumber      The index of the cell; from 1 (top-left cell) to 9 (bottom-right cell)
 *  @return         YES if the cell is selected
 */
-(BOOL) isCellSelected:(int) cellNumber;
/**
 *  Through this method you can set a specific background image for each cell of the grid, corrisponding to the passed status. 
 *  @param[in]      image           The image you want to set
 *  @param[in]      state           The state to which associate the image
 */
-(void) setCellsBackgroundImage:(UIImage*) image forState:(UIControlState) state;
/**
 *  Through this method you can set a specific background image for a specific cell of the grid, corrisponding to the passed status. 
 *  @param[in]      image           The image you want to set
 *  @param[in]      state           The state to which associate the image
 *  @param[in]      index           The index of the cell; from 1 (top-left cell) to 9 (bottom-right cell)
 */
-(void) setCellBackgroundImage:(UIImage*) image forState:(UIControlState) state atIndex:(int) index;
/**
 *  Override of the setter method for the property radiusPercentage.
 *  @param[in]      value           The value to store in radiusPercentage.
 */
-(void) setRadiusPercentage:(float) value;
-(void)resetPoints;
@end


#pragma mark -
#pragma mark Protocol
@protocol ALUnlockPatternViewDelegate<NSObject>
/**
 *  Raised when the user stop to touch the grid or exit from its bounds.
 *  @param[in]      patternView         Reference of the ALUnlockPatternView instance which sends the event
 *  @param[in]      code                The code generated with the touch interaction with the grid
 */
-(void) unlockPatternView:(ALUnlockPatternView*) patternView selectedCode:(NSString*) code;
@optional
/**
 *  Raised each time was selected a new cell of the grid.
 *  @param[in]      patternView         Reference of the ALUnlockPatternView instance which sends the event
 *  @param[in]      index               The index of the cell; from 1 (top-left cell) to 9 (bottom-right cell)
 *  @param[in]      partialCode         The code generated until this last cell selection
 */
-(void) unlockPatternView:(ALUnlockPatternView*) patternView 
     didSelectCellAtIndex:(int) index andpartialCode:(NSString*) partialCode;
@end

/*! \class PointObject 
 *
 *  This is a simple wrapper of CGPoint. This wrapper permits to store a collection of CGPoint into a NSArray,
 */
@interface PointObject : NSObject {
    CGPoint point;
}
/**
 *  It's the wrapped point; is the only property of this class.
 */
@property(nonatomic) CGPoint point;
@end

