//
//  FBSignInCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBSignInCompleteProtocol;

@protocol FBSignInCompleteProtocol <NSObject>

-(void)fbSignInDidComplete:(BOOL)hasACHaccount withSecurityPin:(BOOL)hasSecurityPin withUserID:(NSString*)userID;

-(void)fbSignInDidFail:(NSString *)reason;

@end
