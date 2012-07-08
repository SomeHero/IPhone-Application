//
//  Application.m
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Application.h"

@implementation Application

@synthesize apiKey;
@synthesize applicationId;
@synthesize profileItems;

-(id)init {
    self = [super init];
    if(self) {
        
        apiKey = [[NSString alloc] init];
        applicationId = [[NSString alloc] init];
                
    }
    
    return self;
}
-(Application *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        apiKey = [[dictionary valueForKey: @"apiKey"] copy];
        applicationId = [[dictionary valueForKey: @"applicationId"] copy];
        
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
    Application *another = [[Application alloc] init];
    
    another.apiKey = apiKey;
    another.applicationId = applicationId;
    another.profileItems = [profileItems copy];
    
    return another;
}

@end
