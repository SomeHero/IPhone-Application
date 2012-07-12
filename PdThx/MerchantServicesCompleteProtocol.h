//
//  MerchantServicesCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MerchantServicesCompleteProtocol;

@protocol MerchantServicesCompleteProtocol <NSObject>

-(void)getMerchantsDidComplete: (NSMutableArray*) merchants;
-(void)getMerchantsDidFail: (NSString*) errorMessage;


@end

