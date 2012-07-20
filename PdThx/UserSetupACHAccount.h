//
//  UserSetupACHAccount.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "UserACHSetupCompleteProtocol.h"

@interface UserSetupACHAccount : NSObject {
     ASIHTTPRequest *requestObj;   
    id<UserACHSetupCompleteProtocol> userACHSetupCompleteDelegate;
}

@property(retain) id userACHSetupCompleteDelegate;

-(void) setupACHAccount:(NSString *) accountNumber forUser:(NSString *) userId withNickname: (NSString*) nickname withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType withSecurityPin : (NSString*) securityPin withSecurityQuestionID:(int)questionID withSecurityQuestionAnswer:(NSString*)questionAnswer;

-(void) addACHAccount:(NSString *) accountNumber forUser:(NSString *) userId withNickname: (NSString*) nickname withNameOnAccount:(NSString *) nameOnAccount withRoutingNumber:(NSString *) routingNumber ofAccountType: (NSString *) accountType withSecurityPin : (NSString*) securityPin;

@end
