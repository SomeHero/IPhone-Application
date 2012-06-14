//
//  RejectPaymentRequestProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RejectPaymentRequestProtocol;

@protocol RejectPaymentRequestProtocol <NSObject>

-(void)rejectPaymentRequestDidComplete;
-(void)rejectPaymentRequestDidFail;

@end
