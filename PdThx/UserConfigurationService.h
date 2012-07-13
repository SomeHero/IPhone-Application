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
#import "UserSettingsCompleteProtocol.h"
#import "UserConfiguration.h"

@interface UserConfigurationService : NSObject
{
    id<UserSettingsCompleteProtocol> userSettingsCompleteDelegate;
}

@property(nonatomic, retain) id userSettingsCompleteDelegate;

-(void)getUserSettings:(NSString*)userId;

-(void)updateUserConfiguration:(NSString*)configurationValue forKey:(NSString*) configurationKey forUserId:(NSString *)userId;

@end
