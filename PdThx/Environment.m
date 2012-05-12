//
//  Environment.m
//  PdThx
//
//  Created by James Rhodes on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Environment.h"

@implementation Environment

static Environment *sharedInstance = nil;

@synthesize pdthxAPIKey;
@synthesize pdthxWebServicesBaseUrl;

- (id)init
{
    self = [super init];
    
    if (self) {
        // Do Nada
    }
    
    return self;
}

- (void)initializeSharedInstance
{
    NSString* configuration = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Configuration"];
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* envsPListPath = [bundle pathForResource:@
                               "Environments" ofType:@"plist"];
    NSDictionary* environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
    NSDictionary* environment = [environments objectForKey:configuration];
    
    self.pdthxWebServicesBaseUrl = [[[NSString alloc] initWithString:[environment valueForKey:@"pdthxWebServicesBaseUrl"]] autorelease];
    self.pdthxAPIKey = [[[NSString alloc] initWithString:[environment valueForKey:@"pdthxAPIKEY"]] autorelease];
    
    [environments release];
}

#pragma mark - Lifecycle Methods

+ (Environment *)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
            [sharedInstance initializeSharedInstance];
        }
        return sharedInstance;
    }
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}

- (void) release
{
    // Do Nada
}

- (id) autorelease
{
    return self;
}

- (id) retain
{
    return self;
}

- (void) dealloc
{
    [pdthxWebServicesBaseUrl release];
    [pdthxAPIKey release];
    [super dealloc];
}

@end
