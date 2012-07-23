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
#import "PersonalizeUserCompleteProtocol.h"
#import "ChangePasswordCompleteProtocol.h"
#import "ForgotPasswordCompleteProtocol.h"
#import "LinkWithFacebookProtocol.h"

@interface UserService : NSObject {
    ASIHTTPRequest *requestObj;
    id<UserInformationCompleteProtocol> userInformationCompleteDelegate;
    id<UserSecurityPinCompleteProtocol> userSecurityPinCompleteDelegate;
    id<PersonalizeUserCompleteProtocol> personalizeUserCompleteDelegate;
    id<ChangePasswordCompleteProtocol> changePasswordCompleteDelegate;
    id<ForgotPasswordCompleteProtocol>
        forgotPasswordCompleteDelegate;
    id<LinkWithFacebookProtocol> linkFbAccountDelegate;
}

@property(retain) id userInformationCompleteDelegate;
@property(nonatomic, retain) id userSecurityPinCompleteDelegate;
@property(nonatomic, retain) id personalizeUserCompleteDelegate;
@property(nonatomic, retain) id changePasswordCompleteDelegate;
@property(nonatomic, retain) id forgotPasswordCompleteDelegate;
@property(nonatomic, retain) id linkFbAccountDelegate;

-(void) getUserInformation:(NSString*) userId;
-(void) setupSecurityPin:(NSString*) userId WithPin: (NSString*) securityPin;
-(void) changeSecurityPin: (NSString*) userId WithOld:(NSString*) oldSecurityPin AndNew:(NSString*) newSecurityPin;
-(void) personalizeUser:(NSString*) userId WithFirstName: (NSString*) firstName withLastName :(NSString*) lastName withImage: (NSString*) imageUrl;
-(void) changePasswordFor: (NSString*) userId WithOld:(NSString*) oldPassword AndNew: (NSString*) newPassword;

-(void) forgotPasswordFor: (NSString*) emailAddress;

-(void)linkFacebookAccount:(NSString*)userId withFacebookId:(NSString*)facebookId withAuthToken:(NSString*)token;

@end
            