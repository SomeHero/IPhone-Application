//
//  UserInformationCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@protocol UserInformationCompleteProtocol;

@protocol UserInformationCompleteProtocol <NSObject>

-(void)userInformationDidComplete:(User*)user;
-(void)userInformationDidFail:(NSString*) message;


-(void)userHomeScreenInformationDidComplete:(NSDictionary*) quickSendDictionary;
-(void)userHomeScreenInformationDidFail:(NSString*) message;

@end

