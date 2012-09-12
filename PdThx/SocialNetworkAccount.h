//
//  SocialNetworkAccount.h
//  PdThx
//
//  Created by Christopher Magee on 9/11/12.
//
//

#import <Foundation/Foundation.h>

@interface SocialNetworkAccount : NSObject
{
    NSString* networkName;
    NSString* networkUserId;
    NSString* networkAccessToken;
}

@property(nonatomic, retain) NSString* networkName;
@property(nonatomic, retain) NSString* networkUserId;
@property(nonatomic, retain) NSString* networkAccessToken;


-(SocialNetworkAccount *) initWithDictionary : (NSDictionary *) dictionary;

@end
