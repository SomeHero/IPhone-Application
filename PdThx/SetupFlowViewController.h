//
//  SetupFlowViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivatePhoneViewController.h"
#import "PersonalizeViewController.h"
#import "AddACHAccountViewController.h"
#import "User.h"
#import "UserSetupCompleteProtocol.h"
#import "UserSetupStepCompleteProtocol.h"

@interface SetupFlowViewController : UIViewController<UserSetupStepCompleteProtocol>
{
    int currentReminderTab;
    ActivatePhoneViewController* activatePhoneController;
    User* user;
    id<UserSetupCompleteProtocol> userSetupCompleteDelegate;
}

@property(nonatomic, retain) id<UserSetupCompleteProtocol> userSetupCompleteDelegate;

@end
