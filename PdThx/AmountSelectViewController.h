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
}

- (IBAction)amountChanged:(id)sender;
- (IBAction)pressedGoButton:(id)sender;

@property (assign) id amountChosenDelegate;

@end
