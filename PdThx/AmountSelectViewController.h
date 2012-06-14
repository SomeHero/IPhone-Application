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
}

- (IBAction)amountChanged:(id)sender;
- (IBAction)pressedGoButton:(id)sender;
- (IBAction)pressedQuickAmount0:(id)sender;

@property (assign) id amountChosenDelegate;

@end
