//
//  SecurityQuestionService.h
//  PdThx
//
//  Created by James Rhodes on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SecurityQuestionAnsweredProtocol.h"
#import "Environment.h"
#import "JSON.h"

@interface SecurityQuestionService : NSObject {
    ASIHTTPRequest *requestObj;
    id<SecurityQuestionAnsweredProtocol> securityQuestionAnsweredDelegate;
}

@property(retain) id<SecurityQuestionAnsweredProtocol> securityQuestionAnsweredDelegate;

-(void) validateSecurityAnswer: (NSString*) answer forUserId: (NSString*) userId;

@end