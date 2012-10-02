//
//  UserSecurityPinCompleteProtocol.h
//  PdThx
//
//  Created by Edward Mitchell on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserSecurityPinCompleteProtocol <NSObject>

-(void)userSecurityPinDidComplete;
-(void)userSecurityPinDidFail:(NSString*) message withErrorCode:(int)errorCode;

@end
