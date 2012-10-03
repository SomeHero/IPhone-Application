//
//  AmountSelectViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmountSelectChosenProtocol.h"
#import "User.h"
#import "PdThxAppDelegate.h"
#import "OHAttributedLabel.h"

@interface AmountSelectViewController : UIBaseViewController <UITextFieldDelegate>
{
    id<AmountSelectChosenProtocol> amountChosenDelegate;
    IBOutlet UITextField *amountDisplayLabel;
    IBOutlet UIButton *goButton;
    IBOutlet UIButton *quickAmount0;
    IBOutlet UIButton *quickAmount1;
    IBOutlet UIButton *quickAmount2;
    IBOutlet UIButton *quickAmount3;
    IBOutlet UILabel *lblGo;
    
    IBOutlet OHAttributedLabel *expressChargeLabel;
    IBOutlet OHAttributedLabel *amountExpressChargeLabel;
    IBOutlet UIButton *addExpressDeliveryButton;
    
    bool canExpress;
    bool isExpressed;
    double expressDeliveryRate;
    double expressDeliveryFreeThreshold;
    
    double upperLimit;
}

- (IBAction)amountChanged:(id)sender;
- (IBAction)pressedGoButton:(id)sender;
- (IBAction)pressedQuickAmount0:(id)sender;
- (IBAction)pressedQuickAmount1:(id)sender;
- (IBAction)pressedQuickAmount2:(id)sender;
- (IBAction)pressedQuickAmount3:(id)sender;
- (IBAction)pressedAddExpressDelivery:(id)sender;

@property (assign) id amountChosenDelegate;
@property (nonatomic, assign) UILabel* lblGo;

@property (assign) double expressDeliveryRate;
@property (assign) bool canExpress;
@property (assign) bool isExpressed;
@property (assign) double expressDeliveryFreeThreshold;

@property (assign) double upperLimit;

@property (nonatomic, retain) OHAttributedLabel *expressChargeLabel;
@property (nonatomic, retain) OHAttributedLabel *amountExpressChargeLabel;

@property (nonatomic, retain) UIButton *addExpressDeliveryButton;

@end
