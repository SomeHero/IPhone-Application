//
//  MerchantOffer.m
//  PdThx
//
//  Created by James Rhodes on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MerchantOffer.h"

@implementation MerchantOffer

@synthesize Id;
@synthesize Amount;

-(id)init {
    self = [super init];
    if(self) {
        
        
    }
    
    return self;
}
-(MerchantOffer *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        Id = [[dictionary valueForKey: @"Id"] copy];
        Amount = [[dictionary objectForKey: @"Amount"] copy];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    MerchantOffer *another = [[MerchantOffer alloc] init];
    
    another.Id = Id;
    another.Amount = Amount;
    
    return another;
}


@end
