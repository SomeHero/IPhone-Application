//
//  ActivatePhoneViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "UISetupUserBaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ActivatePhoneViewController : UISetupUserBaseViewController <MFMessageComposeViewControllerDelegate>
{
    IBOutlet UIButton *activateButton;
    IBOutlet UIButton *remindMeLaterButton;
    IBOutlet UIView* viewPanel;
    NSString* registrationKey;
    
    
}

- (IBAction)pressedActivate:(id)sender;
- (IBAction)pressedRemindMeLater:(id)sender;

@end
