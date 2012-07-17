//
//  ProfileItem.m
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileItem.h"

@implementation ProfileItem

@synthesize itemId;
@synthesize label;
@synthesize sortOrder;
@synthesize attributeId;

-(id)init {
    self = [super init];
    if(self) {
        
        label = [[NSString alloc] init];
        
    }
    
    return self;
}
-(ProfileItem *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        itemId = [[dictionary valueForKey: @"Id"] intValue];
        label = [[dictionary valueForKey: @"Label"] copy];
        attributeId = [[dictionary valueForKey: @"UserAttributeId"] copy];
        sortOrder = [[dictionary valueForKey: @"SortOrder"] intValue];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    ProfileItem *another = [[ProfileItem alloc] init];
    
    another.itemId = itemId;
    another.label = label;
    another.attributeId = attributeId;
    another.sortOrder = sortOrder;

    return another;
}

@end
