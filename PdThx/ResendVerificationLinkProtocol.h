//
//  ResendVerificationLinkProtocol.h
//  PdThx
//
//  Created by James Rhodes on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResendVerificationLinkProtocol <NSObject>

-(void)resendVerificationLinkDidComplete;
-(void)resendVerificationLinkDidFail: (NSString*) errorMessage;

@end
