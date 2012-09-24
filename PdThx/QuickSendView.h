//
//  QuickSendView.h
//  PdThx
//
//  Created by James Rhodes on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickSendButtonProtocol.h"
#import "PhoneNumberFormatting.h"
#import "UserService.h"

@interface QuickSendView : UIView
{
    IBOutlet UIButton *qs1button;
    IBOutlet UIButton *qs2button;
    IBOutlet UIButton *qs3button;
    IBOutlet UIButton *qs4button;
    IBOutlet UIButton *qs5button;
    IBOutlet UIButton *qs6button;
    IBOutlet UIButton *qs7button;
    IBOutlet UIButton *qs8button;
    IBOutlet UIButton *qs9button;
    
    IBOutlet UITextView *qs1textView;
    IBOutlet UITextView *qs2textView;
    IBOutlet UITextView *qs3textView;
    IBOutlet UITextView *qs4textView;
    IBOutlet UITextView *qs5textView;
    IBOutlet UITextView *qs6textView;
    IBOutlet UITextView *qs7textView;
    IBOutlet UITextView *qs8textView;
    IBOutlet UITextView *qs9textView;
    
    IBOutlet UIImageView *noContactsImageView;
    
    PhoneNumberFormatting *phoneFormatter;
    UserService *findUserService;
    
    id<QuickSendButtonProtocol> buttonDelegate;
}

@property (nonatomic,retain) UIButton* qs1button;
@property (nonatomic,retain) UIButton* qs2button;
@property (nonatomic,retain) UIButton* qs3button;
@property (nonatomic,retain) UIButton* qs4button;
@property (nonatomic,retain) UIButton* qs5button;
@property (nonatomic,retain) UIButton* qs6button;
@property (nonatomic,retain) UIButton* qs7button;
@property (nonatomic,retain) UIButton* qs8button;
@property (nonatomic,retain) UIButton* qs9button;

@property (nonatomic,retain) UITextView *qs1textView;
@property (nonatomic,retain) UITextView *qs2textView;
@property (nonatomic,retain) UITextView *qs3textView;
@property (nonatomic,retain) UITextView *qs4textView;
@property (nonatomic,retain) UITextView *qs5textView;
@property (nonatomic,retain) UITextView *qs6textView;
@property (nonatomic,retain) UITextView *qs7textView;
@property (nonatomic,retain) UITextView *qs8textView;
@property (nonatomic,retain) UITextView *qs9textView;

@property (nonatomic,retain) UIImageView *noContactsImageView;

@property(nonatomic, retain) PhoneNumberFormatting *phoneFormatter;
@property(nonatomic, retain) UserService *findUserService;

@property (assign) id buttonDelegate;

- (IBAction)qs1pressed:(id)sender;
- (IBAction)qs2pressed:(id)sender;
- (IBAction)qs3pressed:(id)sender;
- (IBAction)qs4pressed:(id)sender;
- (IBAction)qs5pressed:(id)sender;
- (IBAction)qs6pressed:(id)sender;
- (IBAction)qs7pressed:(id)sender;
- (IBAction)qs8pressed:(id)sender;
- (IBAction)qs9pressed:(id)sender;

-(void)reloadQuickSendContacts:(NSMutableArray*)contactArray;

@end
