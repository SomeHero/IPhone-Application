//
//  ContactSelectChosenProtocol.h
//  PdThx
//
//  Created by James Rhodes on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@protocol ContactSelectChosenProtocol <NSObject>

-(void)didChooseContact:(Contact*)contact;

@end
