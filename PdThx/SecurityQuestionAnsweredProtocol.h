//
//  SecurityQuestionAnsweredProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SecurityQuestionAnsweredProtocol;

@protocol SecurityQuestionAnsweredProtocol <NSObject>

-(void)securityQuestionAnsweredDidComplete;
-(void)securityQuestionAnsweredDidFail:(NSString*)errorMessage withErrorCode:(int)errorCode;

@end
