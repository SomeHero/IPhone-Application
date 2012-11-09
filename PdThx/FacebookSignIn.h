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
#import "GetFacebookFriendsProtocol.h"
#import "FacebookLinkProtocol.h"
#import "FacebookUnlinkProtocol.h"

@interface FacebookSignIn : NSObject <CustomAlertViewProtocol>
{
    SignInWithFBService *service;
    
    id<FBHelperReturnProtocol> returnDelegate;
    id<GetFacebookFriendsProtocol> getFacebookFriendsDelegate;
    id<FacebookLinkProtocol> linkDelegate;
    id<FacebookUnlinkProtocol> unlinkDelegate;
}

-(void)signInWithFacebook:(id)returnProtocol;
-(void)getFacebookFriendsWithDelegate:(id)returnDelegate withSocialNetworkUserId:(NSString*)userId withSocialNetworkAccessToken:(NSString*)accessToken;
-(void)linkNewFacebookAccount:(id)callback;
-(void)unlinkFacebookAccount:(id)callback;

@property (assign) id returnDelegate;
@property(assign) id getFacebookFriendsDelegate;
@property (assign) id linkDelegate;
@property (assign) id unlinkDelegate;

@end
