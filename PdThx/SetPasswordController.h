//
//  SetPasswordController.h
//  PdThx
//
//  Created by James Rhodes on 1/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SetPasswordController : UIViewController {
    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    IBOutlet UIButton *button;
    IBOutlet UIScrollView *scrollView;
    UITextField *currTextField;
}
@property(nonatomic, retain) IBOutlet UITextField *txtUserName;
@property(nonatomic, retain) IBOutlet UITextField *txtPassword;
@property(nonatomic, retain) IBOutlet UITextField *txtConfirmPassword;
@property(nonatomic, retain) IBOutlet UIButton* button;
@property(nonatomic, retain) IBOutlet UIScrollView* scrollView;

-(IBAction) bgTouched:(id) sender;
-(void) setupPassword:(NSString*) password withUserName:(NSString *) userName forUser: (NSString *) userId;

@end
