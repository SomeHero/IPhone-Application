//
//  SecurityQuestionChallengeProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SecurityQuestionChallengeProtocol;

@protocol SecurityQuestionChallengeProtocol <NSObject>

-(void)securityQuestionAnsweredCorrect;
-(void)securityQuestionAnsweredInCorrect:(NSString*)errorMessage withErrorCode:(int)errorCode;


@end
