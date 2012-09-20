//
//  FacebookSignIn.h
//  PdThx
//
//  Created by James Rhodes on 6/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SignInWithFBService.h"

#import "PdThxAppDelegate.h"
#import "FBHelperReturnProtocol.h"


@interface FacebookSignIn : NSObject
{
    SignInWithFBService *service;
    
    id<FBHelperReturnProtocol> returnDelegate;
}

- (void)signInWithFacebook:(id)returnProtocol;

-(void)getFacebookFriendsWithDelegate:(id)returnDelegate withSocialNetworkUserId:(NSString*)userId withSocialNetworkAccessToken:(NSString*)accessToken;

-(void)linkNewFacebookAccount:(id)callback;

-(void)unlinkFacebookAccount:(id)callback;

@property (assign) id returnDelegate;

@end
