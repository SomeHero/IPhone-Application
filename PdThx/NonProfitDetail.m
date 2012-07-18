//
//  NonProfitDetail.m
//  PdThx
//
//  Created by James Rhodes on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NonProfitDetail.h"

@implementation NonProfitDetail

@synthesize merchantId;
@synthesize name;
@synthesize imageUrl;
@synthesize preferredReceiveAccountId;
@synthesize tagLine;
@synthesize description;
@synthesize suggestedAmount;

-(id)init {
    self = [super init];
    if(self) {
        
        merchantId = [[NSString alloc] init];
        name = [[NSString alloc] init];
        imageUrl = [[NSString alloc] init];
        preferredReceiveAccountId = [[NSString alloc] init];
        tagLine = [[NSString alloc] init];
        description = [[NSString alloc] init];
    }
    
    return self;
}
-(NonProfitDetail *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        merchantId = [[dictionary valueForKey: @"Id"] copy];
        name = [[dictionary valueForKey: @"Name"] copy];
        imageUrl = [[dictionary valueForKey: @"MerchantImageUrl"] copy];
        preferredReceiveAccountId = [[dictionary valueForKey:@"PreferredReceiveAccountId"] copy];
         tagLine = [[dictionary valueForKey:@"MerchantTagLine"] copy];
        description = [[dictionary valueForKey:@"MerchantDescription"] copy];
        suggestedAmount = [[dictionary objectForKey:@"SuggestedAmount"] copy];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    NonProfitDetail *another = [[NonProfitDetail alloc] init];
    
    another.merchantId = merchantId;
    another.name = name;
    another.imageUrl = imageUrl;
    another.preferredReceiveAccountId = preferredReceiveAccountId;
    another.tagLine = tagLine;
    another.description = description;
    another.suggestedAmount = suggestedAmount;
    
    return another;
}

@end
