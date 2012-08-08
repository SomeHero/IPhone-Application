//
//  UICustomDetailButton.h
//  PdThx
//
//  Created by James Rhodes on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "Merchant.h"

@interface UICustomDetailButton : UIButton
{
    Contact* contact;
    Merchant* merchant;
}

@property(nonatomic, retain) Contact* contact;
@property(nonatomic, retain) Merchant* merchant;

@end
