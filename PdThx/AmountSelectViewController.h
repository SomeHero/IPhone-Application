//
//  AmountSelectViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmountSelectChosenProtocol.h"

@interface AmountSelectViewController : UIViewController <UITextFieldDelegate>
{
    id<AmountSelectChosenProtocol> amountChosenDelegate;
    IBOutlet UITextField *amountDisplayLabel;
    IBOutlet UIButton *goButton;
    IBOutlet UIButton *quickAmount0;
    IBOutlet UIButton *quickAmount1;
    IBOutlet UIButton *quickAmount2;
    IBOutlet UIButton *quickAmount3;
}

- (IBAction)amountChanged:(id)sender;
- (IBAction)pressedGoButton:(id)sender;
- (IBAction)pressedQuickAmount0:(id)sender;
- (IBAction)pressedQuickAmount1:(id)sender;
- (IBAction)pressedQuickAmount2:(id)sender;
- (IBAction)pressedQuickAmount3:(id)sender;

@property (assign) id amountChosenDelegate;

@end
