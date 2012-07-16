//
//  UISetupUserBaseViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneNumberFormatting.h"
#import "User.h"
#import "UIBaseViewController.h"

@interface UISetupUserBaseViewController : UIBaseViewController <UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *autoCompleteArray;
    NSMutableArray *allResults;
    UITextField *currentTextField;
    User* user;
}

@property(nonatomic, retain) UIScrollView *scrollView;

-(void) removeCurrentViewFromNavigation: (UINavigationController*) navContoller;
-(void) showAlertView:(NSString *)title withMessage: (NSString *) message;
-(void) actionButtonClicked:(id)sender;

@end
