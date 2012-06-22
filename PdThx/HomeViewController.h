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

@interface HomeViewController : UIBaseViewController<SignInCompleteProtocol, ACHSetupCompleteProtocol, UserInformationCompleteProtocol>
{
    IBOutlet UIView *viewPanel;
    IBOutlet UIButton *btnRequestMoney;
    IBOutlet UIButton *btnSendMoney;
    IBOutlet UIButton *btnUserImage;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel* lblPayPoints;
    IBOutlet UILabel* lblScore;
    IBOutlet UILabel* lblIncreaseScore;
    IBOutlet UILabel* lblPaystreamCount;
    
    UserService *userService;
}
@property(nonatomic, retain) UIView *viewPanel;
@property(nonatomic, retain) UIButton *btnRequestMoney;
@property(nonatomic, retain) UIButton *btnSendMoney;
@property(nonatomic, retain) UILabel *lblUserName;

-(IBAction) btnRequestMoneyClicked:(id) sender;
-(IBAction) btnSendMoneyClicked:(id) sender;

@end
