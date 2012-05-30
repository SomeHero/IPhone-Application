//
//  SignInWithFBService.h
//  PdThx
//
//  Created by James Rhodes on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "FBSignInCompleteProtocol.h"
#import "Facebook.h"

@interface SignInWithFBService : NSObject
{
    ASIHTTPRequest *requestObj;
    id<FBSignInCompleteProtocol> fbSignInCompleteDelegate;
}

@property(retain) id fbSignInCompleteDelegate;

-(void) validateUser:(Facebook*)fBook;

@end
