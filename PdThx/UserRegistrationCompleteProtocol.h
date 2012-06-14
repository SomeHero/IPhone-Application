//
//  UserRegistrationCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol UserRegistrationCompleteProtocol;

@protocol UserRegistrationCompleteProtocol <NSObject>

-(void)userRegistrationDidComplete:(NSString*) userId withSenderUri:(NSString*) senderUri;

-(void)userRegistrationDidFail:(NSString*) response;

@end
