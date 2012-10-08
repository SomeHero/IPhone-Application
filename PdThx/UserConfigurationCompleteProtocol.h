//
//  UserConfigurationCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 10/8/12.
//
//

#import <Foundation/Foundation.h>

@protocol UserConfigurationCompleteProtocol <NSObject>

-(void)getUserConfigurationDidComplete: (NSMutableArray*) userSettings;
-(void)getUserConfigurationDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;

-(void)updateUserConfigurationDidComplete;
-(void)updateUserConfigurationDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;

@end
