//
//  ProfileSection.m
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileSection.h"

@implementation ProfileSection

@synthesize sectionId;
@synthesize sectionHeader;
@synthesize sortOrder;
@synthesize profileItems;

-(id)init {
    self = [super init];
    if(self) {
        
        sectionHeader = [[NSString alloc] init];
        
        
    }
    
    return self;
}
-(ProfileSection *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        sectionId = [[dictionary valueForKey: @"Id"] intValue];
        sectionHeader = [[dictionary valueForKey: @"SectionHeader"] copy];
        sortOrder = [[dictionary valueForKey: @"SortOrder"] intValue];
        
        NSArray *tempProfileItemsArray = [[dictionary valueForKey:@"ProfileItems"] copy];
        
        profileItems = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[tempProfileItemsArray count]; i++)
        {
            [profileItems addObject: [[[ProfileItem alloc] initWithDictionary: [tempProfileItemsArray objectAtIndex:(NSUInteger) i]] autorelease]];
        }
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    ProfileSection *another = [[ProfileSection alloc] init];
    
    another.sectionId = sectionId;
    another.sectionHeader = sectionHeader;
    another.sortOrder = sortOrder;
    another.profileItems = profileItems;
    
    return another;
}

@end
