//
//  UISetupUserBaseViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneNumberFormatting.h"

@interface UISetupUserBaseViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *autoCompleteArray;
    NSMutableArray *allResults;
    UITextField *currTextField;
    PhoneNumberFormatting* phoneNumberFormatter;
}

@property(nonatomic, retain) UIScrollView *scrollView;

-(void) removeCurrentViewFromNavigation: (UINavigationController*) navContoller;
-(void) showAlertView:(NSString *)title withMessage: (NSString *) message;
-(void) signOutClicked;
-(void) actionButtonClicked:(id)sender;
-(void)loadContacts;
@end
