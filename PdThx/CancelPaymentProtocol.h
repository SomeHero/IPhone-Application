//
//  CancelPaymentProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CancelPaymentProtocol;

@protocol CancelPaymentProtocol <NSObject>

-(void)cancelPaymentDidComplete;
-(void)cancelPaymentDidFail: (NSString*) message withErrorCode:(int)errorCode;

@end
