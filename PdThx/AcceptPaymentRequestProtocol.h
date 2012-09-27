//
//  AcceptPaymentRequestProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AcceptPaymentRequestProtocol;

@protocol AcceptPaymentRequestProtocol <NSObject>

-(void)acceptPaymentRequestDidComplete;
-(void)acceptPaymentRequestDidFail: (NSString*) message withErrorCode:(int)errorCode;

@end