//
//  UserSettingsCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserSettingsCompleteProtocol;

@protocol UserSettingsCompleteProtocol <NSObject>

-(void)getUserSettingsDidComplete: (NSMutableArray*) userSettings;
-(void)getUserSettingsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;
-(void)updateUserSettingsDidComplete: (NSString*) attributeKey withValue: (NSString*) attributeValue;
-(void)updateUserSettingsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;

@end
