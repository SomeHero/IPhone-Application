//
//  ProfileItem.m
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileItem.h"

@implementation ProfileItem

@synthesize attributeName;
@synthesize attributeValue;

-(id)init {
    self = [super init];
    if(self) {
        
        attributeName = [[NSString alloc] init];
        attributeValue = [[NSString alloc] init];

        
    }
    
    return self;
}
-(ProfileItem *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        attributeName = [[dictionary valueForKey: @"AttributeName"] copy];
        attributeValue = [[dictionary valueForKey: @"AttributeValue"] copy];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    ProfileItem *another = [[ProfileItem alloc] init];
    
    another.attributeName = attributeName;
    another.attributeValue = attributeValue;

    return another;
}

@end
