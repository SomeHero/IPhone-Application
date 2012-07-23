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
@synthesize profileSections;
@synthesize applicationSettings;

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
        
        NSArray *tempProfileSectionsArray = [[dictionary valueForKey:@"ProfileSections"] copy];
        
        profileSections = [[NSMutableArray alloc] init];
        
        for(int i = 0; i <[tempProfileSectionsArray count]; i++)
        {
            [profileSections addObject: [[[ProfileSection alloc] initWithDictionary: [tempProfileSectionsArray objectAtIndex:(NSUInteger) i]] autorelease]];
        }
        
        
        NSArray *tempApplicationSettingsArray = [[dictionary valueForKey:@"ConfigurationVariables"] copy];
        
        applicationSettings = [[NSMutableDictionary alloc] init];
        
        for(int i = 0; i <[tempApplicationSettingsArray count]; i++)
        {
            ApplicationConfiguration* item = [[[ApplicationConfiguration alloc] initWithDictionary: [tempApplicationSettingsArray objectAtIndex:(NSUInteger) i]] autorelease];
            
            [applicationSettings setValue:item forKey: [item ConfigurationKey]];
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
    another.profileSections = [profileSections copy];
    another.applicationSettings = [applicationSettings copy];
    
    return another;
}

@end
