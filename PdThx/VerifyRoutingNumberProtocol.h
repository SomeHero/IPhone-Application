//
//  VerifyRoutingNumberDidComplete.h
//  PdThx
//
//  Created by James Rhodes on 10/5/12.
//
//

#import <Foundation/Foundation.h>

@protocol VerifyRoutingNumberProtocol <NSObject>

-(void)verifyRoutingNumberDidComplete: (bool) verified;
-(void)verifyRoutingNumberDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;
@end
