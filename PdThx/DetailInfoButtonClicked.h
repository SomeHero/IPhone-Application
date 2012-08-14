//
//  DetailInfoButtonClicked.h
//  PdThx
//
//  Created by James Rhodes on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@protocol DetailInfoButtonClicked;

@protocol DetailInfoButtonClicked <NSObject>

-(void)infoButtonClicked: (Contact*) contact;


@end
