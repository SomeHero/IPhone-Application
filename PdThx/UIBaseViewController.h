//
//  UIBaseViewController.h
//  PdThx
//
//  Created by James Rhodes on 4/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneNumberFormatting.h"
#import "ContactSelectChosenProtocol.h"
#import "ContactTypeSelectViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface UIBaseViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
    NSObject *currTextField;
    PhoneNumberFormatting* phoneNumberFormatter;
}

@property(nonatomic, retain) TPKeyboardAvoidingScrollView *mainScrollView;

-(void) removeCurrentViewFromNavigation: (UINavigationController*) navContoller;
-(void) showAlertView:(NSString *)title withMessage: (NSString *) message;
-(void) actionButtonClicked:(id)sender;

@end