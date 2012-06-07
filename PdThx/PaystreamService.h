//
//  PaystreamService.h
//  PdThx
//
//  Created by James Rhodes on 6/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface PaystreamService : NSObject {
    ASIHTTPRequest *requestObj;
}

-(void) cancelPayment:(NSString*) messageId;
-(void) acceptRequest:(NSString*) messageId;
-(void) rejectRequest:(NSString*) messageId;
-(void) cancelRequest:(NSString*) messageId;

@end
