//
//  UISetupUserBaseViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneNumberFormatting.h"
#import "UIBaseViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface UISetupUserBaseViewController : UIBaseViewController
{
    IBOutlet TPKeyboardAvoidingScrollView *scrollView;
    NSMutableArray *autoCompleteArray;
    NSMutableArray *allResults;
    UITextField *currentTextField;
}

@property(nonatomic, retain) TPKeyboardAvoidingScrollView *scrollView;

-(void) removeCurrentViewFromNavigation: (UINavigationController*) navContoller;
-(void) showAlertView:(NSString *)title withMessage: (NSString *) message;
-(void) actionButtonClicked:(id)sender;

@end