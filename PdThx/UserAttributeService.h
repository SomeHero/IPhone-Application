//
//  UserAttributeService.h
//  PdThx
//
//  Created by James Rhodes on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"

@interface UserAttributeService : NSObject

-(void) updateUserAttribute:(NSString*)attributeId withValue:(NSString*) attributeValue forUser:(NSString*) userId;

@end
