//
//  MerchantServicesCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NonProfitDetail.h"

@protocol MerchantServicesCompleteProtocol;

@protocol MerchantServicesCompleteProtocol <NSObject>

-(void)getOrganizationsDidComplete: (NSMutableArray*) merchants;
-(void)getOrganizationsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;
-(void)getNonProfitsDidComplete: (NSMutableArray*) merchants;
-(void)getNonProfitsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;
-(void)getNonProfitDetailDidComplete: (NonProfitDetail*) nonProfitDetail;
-(void)getNonProfitDetailDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;

@end

