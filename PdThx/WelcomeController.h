//
//  WelcomeController.h
//  PdThx
//
//  Created by James Rhodes on 12/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WelcomeController : UIViewController <UITextFieldDelegate> {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *txtMobileNumber;
    UITextField *currTextField;
}
@property(nonatomic, retain) UITextField *txtMobileNumber;

-(IBAction) btnBackgroundClicked:(id) sender;

@property(nonatomic, retain) UIScrollView *scrollView;

@end
