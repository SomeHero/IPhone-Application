//
//  SocialNetworkAccount.m
//  PdThx
//
//  Created by Christopher Magee on 9/11/12.
//
//

#import "SocialNetworkAccount.h"

@implementation SocialNetworkAccount


-(id)init {
    self = [super init];
    if(self) {
        
        networkAccessToken = [[NSString alloc] init];
        networkName = [[NSString alloc] init];
        networkUserId = [[NSString alloc] init];
    }
    
    return self;
}

-(SocialNetworkAccount *) initWithDictionary : (NSDictionary *) dictionary {
    self = [super init];
    
    if(self) {
        networkAccessToken = [[dictionary valueForKey: @"SocialNetworkUserToken"] copy];
        networkName = [[dictionary valueForKey:@"SocialNetworkName"] copy];
        networkUserId = [[dictionary valueForKey:@"SocialNetworkUserId"] copy];
    }
    
    return self;
}
// In the implementation
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    SocialNetworkAccount *another = [[SocialNetworkAccount alloc] init];
    
    another.networkAccessToken = networkAccessToken;
    another.networkName = networkName;
    another.networkUserId = networkUserId;
    
    return another;
}
@end
