//
//  CancelPaymentRequestProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CancelPaymentRequestProtocol;

@protocol CancelPaymentRequestProtocol <NSObject>

-(void)cancelPaymentRequestDidComplete;
-(void)cancelPaymentRequestDidFail;

@end