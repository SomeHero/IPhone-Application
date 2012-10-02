//
//  ForgotPasswordCompleteProtocol.h
//  PdThx
//
//  Created by Edward Mitchell on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ForgotPasswordCompleteProtocol <NSObject>

-(void) forgotPasswordDidComplete;
-(void) forgotPasswordDidFail: (NSString*) message withErrorCode:(int)errorCode;

@end
