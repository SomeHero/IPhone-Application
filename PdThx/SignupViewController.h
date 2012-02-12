//
//  SignupViewController.h
//  Signup
//
//  Created by Parveen Kaler on 10-07-24.
//  Copyright 2010 Smartful Studios Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextEditCell;

@interface SignupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *tableView;
    IBOutlet TextEditCell *loadCell;
    NSString* _userName;
    NSString* _password;
    IBOutlet UIButton *demoBtn;
    IBOutlet UIButton *createAccountBtn;
    UITextField *currTextField;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) TextEditCell *loadCell;
@property (nonatomic, retain) UIScrollView *scrollView;

-(BOOL)validateUserSignIn: (NSString*) userName password: (NSString*) password;
-(IBAction) bgTouched:(id) sender;
-(IBAction) btnForgotPasswordClicked:(id) sender;

-(void) signInUser:(NSString*) userName withPassword:(NSString *) password;
-(void) showAlertView:(NSString *)title withMessage: (NSString *) message;
@end
