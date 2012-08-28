//
//  VerifyMobilePayPointProtocol.h
//  PdThx
//
//  Created by James Rhodes on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VerifyMobilePayPointProtocol <NSObject>

-(void)verifyMobilePayPointDidComplete: (bool) verified;
-(void)verifyMobilePayPointDidFail: (NSString*) errorMessage;


@end
