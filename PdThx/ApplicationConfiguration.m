//
//  ApplicationConfiguration.m
//  PdThx
//
//  Created by James Rhodes on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApplicationConfiguration.h"

@implementation ApplicationConfiguration

@synthesize Id;
@synthesize ApiKey;
@synthesize ConfigurationKey;
@synthesize ConfigurationValue;
@synthesize ConfigurationType;

-(id)init {
    self = [super init];
    if(self) {
        
        
    }
    
    return self;
}
-(ApplicationConfiguration *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        Id = [[dictionary valueForKey: @"Id"] copy];
        ApiKey = [[dictionary valueForKey: @"ApiKey"] copy];
        ConfigurationKey = [[dictionary valueForKey:@"ConfigurationKey"] copy];
        ConfigurationValue = [[dictionary valueForKey:@"ConfigurationValue"] copy];
        ConfigurationType = [[dictionary valueForKey:@"ConfigurationType"] copy];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    ApplicationConfiguration *another = [[ApplicationConfiguration alloc] init];
    
    another.Id = Id;
    another.ApiKey = ApiKey;
    another.ConfigurationKey = ConfigurationKey;
    another.ConfigurationValue = ConfigurationValue;
    another.ConfigurationType = ConfigurationType;
    
    return another;
}

@end
