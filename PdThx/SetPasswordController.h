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
    NSString *securityPin;
    NSString *recipientMobileNumber;
    NSString *amount;
    NSString *comment;
}
@property(nonatomic, retain) UITextField *txtUserName;
@property(nonatomic, retain) UITextField *txtPassword;
@property(nonatomic, retain) UITextField *txtConfirmPassword;
@property(nonatomic, retain) NSString *securityPin;
@property(nonatomic, retain) NSString* recipientMobileNumber;
@property(nonatomic, retain) NSString* amount;
@property(nonatomic, retain) NSString* comment;
@property(nonatomic, retain) UIButton* button;

-(IBAction) bgTouched:(id) sender;
-(void) setupPassword:(NSString*) password withUserName:(NSString *) userName forUser: (NSString *) userId;

@end
