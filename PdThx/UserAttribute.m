//
//  UserAttribute.m
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAttribute.h"

@implementation UserAttribute

@synthesize attributeId;
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
-(UserAttribute *) initWithDictionary : (NSDictionary *) dictionary {
self = [super init];

if(self) { 
    attributeId = [[dictionary valueForKey: @"AttributeId"] copy];
    attributeName = [[dictionary valueForKey: @"AttributeName"] copy];
    attributeValue = [[dictionary valueForKey:@"AttributeValue"] copy];
}

return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
// We'll ignore the zone for now
UserAttribute *another = [[UserAttribute alloc] init];

another.attributeId = attributeId;
another.attributeName = attributeName;
another.attributeValue = attributeValue;

return another;
}

@end
