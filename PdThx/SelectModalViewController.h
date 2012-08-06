//
//  SelectModalViewController.h
//  PdThx
//
//  Created by James Rhodes on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAModalPanel.h"
#import "ModalSelectProtocol.h"
#import <QuartzCore/QuartzCore.h>

@interface SelectModalViewController : UAModalPanel<UITableViewDataSource, UITableViewDelegate> 
{
    UIView *v;
	NSMutableArray* optionItems;
    NSString* selectedOptionItem;
    NSString* accountType;
    
    NSString* headerText;
    NSString* descriptionText; 
    
    id<ModalSelectProtocol> optionSelectDelegate;
}


@property(nonatomic, retain) NSString* headerText;
@property(nonatomic, retain) NSString* descriptionText;

@property(nonatomic, retain) id optionSelectDelegate;

@property(nonatomic, retain) NSMutableArray* optionItems;
@property(nonatomic, retain) NSString* selectedOptionItem;
@property(nonatomic, retain) NSString* accountType;

@end
