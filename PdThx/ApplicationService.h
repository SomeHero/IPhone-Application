//
//  ApplicationService.h
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "Application.h"
#import "ApplicationSettingsCompleteProtocol.h"

@interface ApplicationService : NSObject
{
    ASIHTTPRequest *requestObj;
    id<ApplicationSettingsCompleteProtocol> applicationSettingsDidComplete;
}

@property(retain) id applicationSettingsDidComplete;

-(void) getApplicationSettings:(NSString*) apiKey;

@end
