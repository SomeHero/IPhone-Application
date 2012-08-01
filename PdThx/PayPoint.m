//
//  PayPoint.m
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PayPoint.h"

@implementation PayPoint

@synthesize payPointId;
@synthesize payPointType;
@synthesize uri;
@synthesize userId;
@synthesize verified;

-(id)init {
    self = [super init];
    if(self) {
        
        payPointId = [[NSString alloc] init];
        payPointType = [[NSString alloc] init];
        uri = [[NSString alloc] init];
        userId = [[NSString alloc] init];
        verified = false;
            }
    
    return self;
}
-(PayPoint *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) { 
        payPointId = [[dictionary valueForKey: @"Id"] copy];
        payPointType = [[dictionary valueForKey:@"Type"] copy];
        uri = [[dictionary valueForKey:@"Uri"] copy];
        userId = [[dictionary valueForKey:@"UserId"] copy];
        verified = [[dictionary objectForKey:@"Verified"] boolValue];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    PayPoint *another = [[PayPoint alloc] init];
    
    another.payPointId = payPointId;
    another.payPointType = payPointType;
    another.uri = uri;
    another.userId = userId;
    another.verified = verified;
    
    return another;
}

@end
