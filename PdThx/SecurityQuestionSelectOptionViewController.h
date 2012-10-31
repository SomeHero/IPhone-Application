//
//  GenericSelectOptionViewController.h
//  PdThx
//
//  Created by Christopher Magee on 10/22/12.
//
//

#import <UIKit/UIKit.h>
#import "UAModalPanel.h"
#import "GenericModalReturnProtocol.h"
#import <QuartzCore/QuartzCore.h>

@interface SecurityQuestionSelectOptionViewController : UAModalPanel<UITableViewDataSource, UITableViewDelegate>
{
    UIView *v;
	NSMutableArray* optionsArray;
    int selectedOption;
    
    NSString* headerText;
    NSString* descriptionText;
    
    NSString* cellImageIcon;
    
    id<GenericModalReturnProtocol> optionSelectDelegate;
}

@property (nonatomic, retain) NSMutableArray* optionsArray;
@property (assign) int selectedOption;
@property (nonatomic, retain) NSString* headerText;
@property (nonatomic, retain) NSString* descriptionText;
@property (nonatomic, retain) NSString* cellImageIcon;

@property (assign) id optionSelectDelegate;

@end
