//
//  TransactionConfirmationViewController.h
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionConfirmationProtocol.h"
#import "PdThxAppDelegate.h"

@interface TransactionConfirmationViewController : UIViewController {
    IBOutlet UILabel* lblConfirmationHeader;
    NSString* confirmationText;
    IBOutlet UIButton* btnFacebookShare;
    IBOutlet UIButton* btnTwitterShare;
    IBOutlet UIButton* btnHome;
    IBOutlet UIButton* btnContinue;
    id<TransactionConfirmationProtocol> transactionConfirmationDelegate;
    
}

@property(nonatomic, retain) NSString* confirmationText;
@property(nonatomic, retain) id transactionConfirmationDelegate;

-(IBAction) btnHomeClicked:(id) sender;
-(IBAction) btnContinueClicked: (id) sender;
-(IBAction) btnFacebookShare:(id) sender;
-(IBAction) btnTwitterShare:(id) sender;

@end
