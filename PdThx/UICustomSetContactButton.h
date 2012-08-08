//
//  UICustomSetContactButton.h
//  PdThx
//
//  Created by James Rhodes on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface UICustomSetContactButton : UIButton
{
    Contact* contact;
}

@property(nonatomic, retain) Contact* contact;

@end
