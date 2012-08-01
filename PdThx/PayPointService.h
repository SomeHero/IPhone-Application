//
//  PayPointService.h
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Environment.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "PayPoint.h"
#import "GetPayPointProtocol.h"
#import "AddPayPointCompleteProtocol.h"
#import "PayPointVerificationCompleteProtocol.h"
#import "DeletePayPointDelegate.h"

@interface PayPointService : NSObject
{
    ASIHTTPRequest *requestObj;
    id<GetPayPointProtocol> getPayPointsDelegate;
    id<AddPayPointCompleteProtocol> addPayPointCompleteDelegate;
    id<PayPointVerificationCompleteProtocol> payPointVerificationCompleteDelegate;
    id<DeletePayPointDelegate> deletePayPointCompleteDelegate;
}

@property(retain) id getPayPointsDelegate;
@property(retain) id addPayPointCompleteDelegate;
@property(retain) id payPointVerificationCompleteDelegate;
@property(retain) id deletePayPointCompleteDelegate;

-(void) getPayPoints:(NSString*) userId;
-(void) getPayPoints:(NSString*) userId ofType: (NSString*) type;
-(void) deletePayPoint: (NSString*)payPointId forUserId: (NSString*) userId;
-(void) addPayPoint:(NSString *) uri ofType: (NSString*) type forUserId: (NSString*) userId;
-(void) resendEmailVerificationLink:(NSString*)payPointId forUserId:(NSString*) userId;
-(void) resendMobileVerificationCode:(NSString*)payPointId forUserId:(NSString*) userId;
    

@end
