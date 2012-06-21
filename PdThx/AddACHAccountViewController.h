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
    UserSetupACHAccount* accountService;
    User* user;
}

-(IBAction) btnCreateAccountClicked:(id)sender;
-(IBAction) bgClicked:(id)sender;

@end
