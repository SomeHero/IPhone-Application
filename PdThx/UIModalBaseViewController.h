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
#import "PdThxAppDelegate.h"

@interface UIModalBaseViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UINavigationItem *navigationItem;
    IBOutlet UILabel* lblHeader;
    NSMutableArray *autoCompleteArray;
    NSMutableArray *allResults;
    NSObject *currTextField;
    PhoneNumberFormatting* phoneNumberFormatter;
    NSString* navigationTitle;
    NSString* headerText;
    User* user;
}

@property(nonatomic, retain) UIScrollView *mainScrollView;
@property(nonatomic, retain) NSString* navigationTitle;
@property(nonatomic, retain) NSString* headerText;

-(void) removeCurrentViewFromNavigation: (UINavigationController*) navContoller;
-(void) showAlertView:(NSString *)title withMessage: (NSString *) message;


-(IBAction) bgTouched:(id) sender;

@end
