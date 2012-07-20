//
//  UserConfiguration.m
//  PdThx
//
//  Created by James Rhodes on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserConfiguration.h"

@implementation UserConfiguration

@synthesize Key;
@synthesize Value;

-(id)init {
    self = [super init];
    if(self) {
        
        Key = [[NSString alloc] init];
        Value = [[NSString alloc] init];
        
    }
    
    return self;
}
-(UserConfiguration *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        Key = [[dictionary valueForKey: @"ConfigurationKey"] copy];
        Value = [[dictionary valueForKey:@"ConfigurationValue"] copy];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    UserConfiguration *another = [[UserConfiguration alloc] init];
    
    another.Key = Key;
    another.Value = Value;
    
    return another;
}

@end
