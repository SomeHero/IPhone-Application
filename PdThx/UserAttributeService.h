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
#import "UserSettingsCompleteProtocol.h"

@interface UserAttributeService : NSObject{
    ASIHTTPRequest *requestObj;
    id<UserSettingsCompleteProtocol> userSettingsCompleteProtocol;
}

@property(retain) id userSettingsCompleteProtocol;

-(void) updateUserAttribute:(NSString*)attributeId withValue:(NSString*) attributeValue forUser:(NSString*) userId;

@end
