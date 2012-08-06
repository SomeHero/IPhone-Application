//
//  LinkWithFacebookProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LinkWithFacebookProtocol;

@protocol LinkWithFacebookProtocol <NSObject>

-(void)linkFbAccountDidSucceed;
-(void)linkFbAccountDidFail: (NSString*) message;

@end
