//
//  UserConfigurationService.h
//  PdThx
//
//  Created by James Rhodes on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"

@interface UserConfigurationService : NSObject

-(void)updateUserConfiguration:(NSString*)configurationValue forKey:(NSString*) configurationKey forUserId:(NSString *)userId;
@end
