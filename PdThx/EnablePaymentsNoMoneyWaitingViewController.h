//
//  EnablePaymentsNoMoneyWaitingViewController.h
//  PdThx
//
//  Created by Christopher Magee on 9/6/12.
//
//

#import "UISetupUserBaseViewController.h"

@interface EnablePaymentsNoMoneyWaitingViewController : UISetupUserBaseViewController
{
    IBOutlet UIButton *addBankAccountButton;
    IBOutlet UIButton *remindMeLaterButton;
    IBOutlet UIView *navBar;
    
}

@property (nonatomic, retain) UIButton *addBankAccountButton;
@property (nonatomic, retain) UIButton *remindMeLaterButton;
@property (nonatomic, retain) UIView *navBar;

- (IBAction)pressedAddBankAccountButton:(id)sender;
- (IBAction)pressedRemindMeLaterButton:(id)sender;

@end
