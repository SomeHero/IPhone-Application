//
//  UIModalBaseViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneNumberFormatting.h"
#import "User.h"

@interface UIModalBaseViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UIScrollView *mainScrollView;
    NSMutableArray *autoCompleteArray;
    NSMutableArray *allResults;
    NSObject *currTextField;
    PhoneNumberFormatting* phoneNumberFormatter;
}

@property(nonatomic, retain) UIScrollView *mainScrollView;

-(void) removeCurrentViewFromNavigation: (UINavigationController*) navContoller;
-(void) showAlertView:(NSString *)title withMessage: (NSString *) message;

@end
