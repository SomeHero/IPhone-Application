//
//  UserACHSetupCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol UserACHSetupCompleteProtocol;

@protocol UserACHSetupCompleteProtocol <NSObject>

-(void)userACHSetupDidComplete:(NSString*) paymentAccountId;
-(void)userACHSetupDidFail:(NSString*) message;

@end
