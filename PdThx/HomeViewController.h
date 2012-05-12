//
//  HomeViewController.h
//  PdThx
//
//  Created by James Rhodes on 4/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupACHAccountController.h"
#import "SignInCompleteProtocol.h"
#import "UIBaseViewController.h"
#import "UserService.h"
#import "SignInViewController.h"

@interface HomeViewController : UIBaseViewController<SignInCompleteProtocol, ACHSetupCompleteProtocol, UserInformationCompleteProtocol>
{
    IBOutlet UIView *viewPanel;
    IBOutlet UIView *moneyView;
    IBOutlet UIButton *btnRequestMoney;
    IBOutlet UIButton *btnSendMoney;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblMoneySent;
    IBOutlet UILabel *lblMoneyReceived;
    UserService *userService;
    SignInViewController* signInViewController;
}
@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UIView *moneyView;
@property(nonatomic, retain) UIButton *btnRequestMoney;
@property(nonatomic, retain) UIButton *btnSendMoney;
@property(nonatomic, retain) UILabel *lblUserName;
@property(nonatomic, retain) UILabel *lblMoneySent;
@property(nonatomic, retain) UILabel *lblMoneyReceived;

-(IBAction) btnRequestMoneyClicked:(id) sender;
-(IBAction) btnSendMoneyClicked:(id) sender;

@end
