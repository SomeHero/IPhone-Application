//
//  UserService.h
//  PdThx
//
//  Created by James Rhodes on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInformationCompleteProtocol.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "UserSecurityPinCompleteProtocol.h"

@interface UserService : NSObject {
    ASIHTTPRequest *requestObj;
    id<UserInformationCompleteProtocol> userInformationCompleteDelegate;
    id<UserSecurityPinCompleteProtocol> userSecurityPinCompleteDelegate;
}

@property(retain) id userInformationCompleteDelegate;
@property(nonatomic, retain) id userSecurityPinCompleteDelegate;

-(void) getUserInformation:(NSString*) userId;
-(void) setupSecurityPin:(NSString*) userId WithPin: (NSString*) securityPin;
-(void) changeSecurityPin: (NSString*) userId WithOld:(NSString*) oldSecurityPin AndNew:(NSString*) newSecurityPin;

@end
            