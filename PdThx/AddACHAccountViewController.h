//
//  AddACHAccountViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSetupACHAccount.h"
#import "CustomSecurityPinSwipeController.h"
#import "CustomSecurityPinSwipeProtocol.h"
#import "UserSetupACHAccountComplete.h"
#import "User.h"
#import "PdThxAppDelegate.h"

@interface AddACHAccountViewController : UIViewController<CustomSecurityPinSwipeProtocol>
{
    IBOutlet UITextField* txtNameOnAccount;
    IBOutlet UITextField* txtRoutingNumber;
    IBOutlet UITextField* txtAccountNumber;
    IBOutlet UITextField* txtConfirmAccountNumber;
    IBOutlet UISegmentedControl* ctrlAccountType;
    IBOutlet UITextView* ctrlHeaderText;
    NSString* navBarTitle;
    NSString* headerText;
    UserSetupACHAccount* accountService;
    User* user;
    CustomSecurityPinSwipeController* controller;
}

@property(nonatomic, retain) NSString* navBarTitle;
@property(nonatomic, retain) NSString* headerText;

-(IBAction) btnCreateAccountClicked:(id)sender;
-(IBAction) bgClicked:(id)sender;

@end
