//
//  UserProfileItem.m
//  PdThx
//
//  Created by James Rhodes on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfileItem.h"

@implementation UserProfileItem

@synthesize itemKey;
@synthesize itemValue;
@synthesize pointValue;

-(id)init {
    self = [super init];
    if(self) {
        
        itemKey = [[NSString alloc] init];
        itemValue = [[NSString alloc] init];
        pointValue = 0;
        
    }
    
    return self;
}
-(UserProfileItem *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        itemKey = [[dictionary valueForKey: @"profileKey"] copy];
        itemValue = [[dictionary valueForKey: @"profileItemValue"] copy];
        pointValue = [[dictionary objectForKey: @"pointValue"] intValue];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    UserProfileItem *another = [[UserProfileItem alloc] init];
    
    another.itemKey = itemKey;
    another.itemValue = itemValue;
    another.pointValue = pointValue;
    
    return another;
}


@end
