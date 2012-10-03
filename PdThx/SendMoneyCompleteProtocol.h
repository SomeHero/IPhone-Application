//
//  SendMoneyCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SendMoneyCompleteProtocol;

@protocol SendMoneyCompleteProtocol <NSObject>

-(void)sendMoneyDidComplete;
-(void)sendMoneyDidFail:(NSString*) message withErrorCode:(int)errorCode;

@end
