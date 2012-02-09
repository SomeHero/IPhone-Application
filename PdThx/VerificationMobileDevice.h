//
//  VerificationMobileDevice.h
//  PdThx
//
//  Created by James Rhodes on 1/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VerificationMobileDevice : UIViewController<UITextFieldDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txtVerificationCode1;
    IBOutlet UITextField *txtVerificationCode2;
    NSString *recipientMobileNumber;
    NSString *amount;
    NSString *comment;
    UITextField *currTextField;
}
@property(nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic, retain) NSString* recipientMobileNumber;
@property(nonatomic, retain) NSString* amount;
@property(nonatomic, retain) NSString* comment;
@property(nonatomic, retain) UITextField *txtVerificationCode1;
@property(nonatomic, retain) UITextField *txtVerificationCode2;

-(IBAction) btnContinueClicked:(id) sender;
-(IBAction) btnReSendCodesClicked:(id) sender;
-(IBAction) bgTouched:(id) sender;

@end
