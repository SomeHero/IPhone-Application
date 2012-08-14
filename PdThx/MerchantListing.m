//
//  MerchantListing.m
//  PdThx
//
//  Created by James Rhodes on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MerchantListing.h"

@implementation MerchantListing

@synthesize Id;
@synthesize TagLine;
@synthesize Description;
@synthesize Offers;

-(id)init {
    self = [super init];
    if(self) {
        
        
    }
    
    return self;
}
-(MerchantListing *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        Id = [[dictionary valueForKey: @"Id"] copy];
        TagLine = [[dictionary valueForKey: @"TagLine"] copy];
        Description = [[dictionary valueForKey:@"Description"] copy];
        
        NSArray *tempMerchantOffers = [[dictionary valueForKey:@"Offers"] copy];
        
        Offers = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[tempMerchantOffers count]; i++)
        {
            [Offers addObject: [[[MerchantOffer alloc] initWithDictionary: [tempMerchantOffers objectAtIndex:(NSUInteger) i]] autorelease]];
        }
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    MerchantListing *another = [[MerchantListing alloc] init];
    
    another.Id = Id;
    another.TagLine = TagLine;
    another.Description = Description;
    another.Offers = Offers;
    
    return another;
}


@end
