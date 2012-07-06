//
//  EnablePaymentsViewController.h
//  PdThx
//
//  Created by James Rhodes on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "UISetupUserBaseViewController.h"
#import "ASIHTTPRequest.h"
#import "PersonalizeUserCompleteProtocol.h"
#import "SetupNavigationView.h"
#import "UserService.h"
#import "PdThxAppDelegate.h"
#import "PaystreamMessage.h"

@interface EnablePaymentsViewController : UISetupUserBaseViewController<UITextFieldDelegate>
{
    IBOutlet UIView *navBar;
    IBOutlet UILabel* lblOutstandingHeader;
    IBOutlet UILabel* lblOutstandingSender;
    IBOutlet UILabel* lblOutstandingDate;
    IBOutlet UIButton* btnOutstandingImage;
    IBOutlet UIView* quoteBubble;
    PaystreamMessage* message;
}

@property(nonatomic, retain) PaystreamMessage* message;

-(IBAction)btnRemindMeLaterClicked:(id)sender;
-(IBAction)btnAddBankAccountClicked:(id)sender;

@end

