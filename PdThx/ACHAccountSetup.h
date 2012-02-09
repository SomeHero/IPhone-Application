//
//  ACHAccountSetup.h
//  PdThx
//
//  Created by James Rhodes on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ACHAccountSetup : UIViewController {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField* txtNameOnAccount;
    IBOutlet UITextField* txtRoutingNumber;
    IBOutlet UITextField* txtAccountNumber;
    IBOutlet UITextField* txtAccountNumberConfirm;
    NSString *recipientMobileNumber;
    NSString *amount;
    NSString *comment;
    UITextField *currTextField;
}
@property(nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic, retain) NSString* recipientMobileNumber;
@property(nonatomic, retain) NSString* amount;
@property(nonatomic, retain) NSString* comment;
@property(nonatomic, retain) UITextField* txtNameOnAccount;
@property(nonatomic, retain) UITextField* txtRoutingNumber;
@property(nonatomic, retain) UITextField* txtAccountNumber;
@property(nonatomic, retain) UITextField* txtAccountNumberConfirm;

-(IBAction) bgTouched:(id) sender;
-(IBAction) btnContinueClicked:(id) sender;

-(void) setupACHAccount:(NSString *) accountNumber forUser:(NSString *) userId withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType;

@end
