//
//  FBHelperReturnProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBHelperReturnProtocol <NSObject>

-(void)fbSignInCompleteWithMEResponse:(id)response;
-(void)fbSignInCancelled;
-(void)linkedFacebookFriendsDidLoad:(id)friendsList;

@end
