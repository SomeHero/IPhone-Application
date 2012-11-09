//
//  UserService.h
//  PdThx
//
//  Created by James Rhodes on 4/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInformationCompleteProtocol.h"
#import "UserHomeScreenInformationProtocol.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "UserSecurityPinCompleteProtocol.h"
#import "PersonalizeUserCompleteProtocol.h"
#import "ChangePasswordCompleteProtocol.h"
#import "ForgotPasswordCompleteProtocol.h"
#import "LinkFBAccountCompleteProtocol.h"
#import "FindUserByNumberProtocol.h"
#import "FindMatchingMeCodesProtocol.h"

@interface UserService : NSObject {
    ASIHTTPRequest *requestObj;
    id<UserInformationCompleteProtocol> userInformationCompleteDelegate;
    id<UserHomeScreenInformationProtocol> userHomeScreenInformationDelegate;
    id<UserSecurityPinCompleteProtocol> userSecurityPinCompleteDelegate;
    id<PersonalizeUserCompleteProtocol> personalizeUserCompleteDelegate;
    id<ChangePasswordCompleteProtocol> changePasswordCompleteDelegate;
    id<ForgotPasswordCompleteProtocol>
        forgotPasswordCompleteDelegate;
    id<LinkFBAccountCompleteProtocol> linkFBAccountDelegate;
    id<FindUserByNumberProtocol> findUserDelegate;
    id<FindMatchingMeCodesProtocol> findMeCodeDelegate;
}

@property(retain) id userInformationCompleteDelegate;
@property(nonatomic, retain) id userSecurityPinCompleteDelegate;
@property(nonatomic, retain) id personalizeUserCompleteDelegate;
@property(nonatomic, retain) id changePasswordCompleteDelegate;
@property(nonatomic, retain) id forgotPasswordCompleteDelegate;
@property(nonatomic, retain) id linkFBAccountDelegate;
@property(nonatomic, retain) id findUserDelegate;
@property(nonatomic, retain) id findMeCodeDelegate;

//Request object retained to be able to cancel requests before changing tabs.
@property(nonatomic, retain) ASIHTTPRequest *requestObj;

-(void) getUserInformation:(NSString*) userId;

-(void) refreshHomeScreenInformation:(NSString*) userId;

-(void) setupSecurityPin:(NSString*) userId WithPin: (NSString*) securityPin;
-(void) changeSecurityPin: (NSString*) userId WithOld:(NSString*) oldSecurityPin AndNew:(NSString*) newSecurityPin;
-(void) personalizeUser:(NSString*) userId WithFirstName: (NSString*) firstName withLastName :(NSString*) lastName withImage: (NSString*) imageUrl;
-(void) changePasswordFor: (NSString*) userId WithOld:(NSString*) oldPassword AndNew: (NSString*) newPassword;

-(void) forgotPasswordFor: (NSString*) emailAddress;

-(void)linkFacebookAccount:(NSString*)userId withFacebookId:(NSString*)facebookId withAuthToken:(NSString*)token;

-(Contact*)findContactByPhoneNumber:(NSString*)phoneNumber;

-(void)findMeCodesMatchingSearchTerm:(NSString*)searchTerm;

@end
            