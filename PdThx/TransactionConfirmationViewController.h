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
#import "User.h"

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
@property(nonatomic, retain) UIButton* btnContinue;
@property(nonatomic, retain) NSString* continueButtonText;
@property(nonatomic, retain) User* user;

-(IBAction) btnHomeClicked:(id) sender;
-(IBAction) btnContinueClicked: (id) sender;
-(IBAction) btnFacebookShare:(id) sender;
-(IBAction) btnTwitterShare:(id) sender;


@end
