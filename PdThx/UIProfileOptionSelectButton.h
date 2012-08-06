//
//  UIProfileOptionSelectButton.h
//  PdThx
//
//  Created by James Rhodes on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIProfileOptionSelectButton : UIButton
{
    NSMutableArray* options;
    NSString* selectedOption;
    NSString* optionSelectAttributeId;
}

@property(nonatomic, retain) NSMutableArray* options;
@property(nonatomic, retain) NSString* selectedOption;
@property(nonatomic, retain) NSString* optionSelectAttributeId;

@end
