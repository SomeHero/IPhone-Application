//
//  SelectRecipientViewControllerViewController.h
//  PdThx
//
//  Created by Edward Mitchell on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIModalBaseViewController.h"
#import "SelectRecipientProtocol.h"

@interface SelectRecipientViewController : UIModalBaseViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    IBOutlet UIPickerView *selectRecipientPicker;
    NSArray* recipientUriOutputs;
    NSArray* recipientUris;
    NSUInteger chosenRecipient;
    id<SelectRecipientProtocol> selectRecipientDelegate;
}
@property (retain, nonatomic) IBOutlet UIPickerView *selectRecipientPicker;
@property (retain, nonatomic) NSArray* recipientUris;
@property (retain, nonatomic) NSArray* recipientUriOutputs;
@property (retain) id<SelectRecipientProtocol> selectRecipientDelegate;

- (IBAction)btnSelectRecipientClicked:(id)sender;

@end
