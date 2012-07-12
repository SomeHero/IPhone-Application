//
//  MerchantServices.h
//  PdThx
//
//  Created by James Rhodes on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "GetPayStreamCompleteProtocol.h"
#import "Environment.h"
#import "SBJsonBase.h"
#import "SBJsonParser.h"
#import "Merchant.h"
#import "MerchantServicesCompleteProtocol.h"
@interface MerchantServices : NSObject
{
    ASIHTTPRequest* requestObj;
    id<MerchantServicesCompleteProtocol> merchantServicesCompleteProtocol;
}

@property(retain) id merchantServicesCompleteProtocol;

-(void)getMerchants;


@end
