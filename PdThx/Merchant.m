//
//  Merchant.m
//  PdThx
//
//  Created by James Rhodes on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Merchant.h"

@implementation Merchant

@synthesize merchantId;
@synthesize name;
@synthesize imageUrl;
@synthesize preferredReceiveAccountId;

-(id)init {
self = [super init];
if(self) {
    
    merchantId = [[NSString alloc] init];
    name = [[NSString alloc] init];
    imageUrl = [[NSString alloc] init];
    
}

return self;
}
-(Merchant *) initWithDictionary : (NSDictionary *) dictionary {
self = [super init];

if(self) { 
    merchantId = [[dictionary valueForKey: @"Id"] copy];
    name = [[dictionary valueForKey: @"Name"] copy];
    imageUrl = [[dictionary valueForKey: @"MerchantImageUrl"] copy];
    preferredReceiveAccountId = [[dictionary valueForKey:@"PreferredReceiveAccountId"] copy];
}

return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
// We'll ignore the zone for now
Merchant *another = [[Merchant alloc] init];

another.merchantId = merchantId;
another.name = name;
another.imageUrl = imageUrl;

return another;
}

@end
