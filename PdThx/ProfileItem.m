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
@synthesize itemType;
@synthesize points;
@synthesize selectOptionHeader;
@synthesize selectOptionDescription;
@synthesize options;

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
        itemType = [[dictionary valueForKey:@"ItemType"] copy];
        points = [[dictionary valueForKey:@"Points"] intValue];
        
        NSArray *tempOptions = [[dictionary valueForKey:@"SelectOptions"] copy];
        selectOptionHeader = [[dictionary valueForKey: @"SelectOptionHeader"] copy];
        selectOptionDescription = [[dictionary valueForKey: @"SelectOptionDescription"] copy];
        options = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[tempOptions count]; i++)
        {
            [options addObject: [[tempOptions objectAtIndex:(NSUInteger) i] autorelease]];
        }
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
    another.itemType = itemType;
    another.points = points;

    return another;
}

@end
