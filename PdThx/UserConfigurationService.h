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
#import "UserConfigurationCompleteProtocol.h"
#import "UserConfiguration.h"

@interface UserConfigurationService : NSObject
{
    id<UserConfigurationCompleteProtocol> userConfigurationCompleteDelegate;
}

@property(nonatomic, retain) id userConfigurationCompleteDelegate;

-(void)getUserSettings:(NSString*)userId;

-(void)updateUserConfiguration:(NSString*)configurationValue forKey:(NSString*) configurationKey forUserId:(NSString *)userId;

@end
