//
//  ApplicationSettingsCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApplicationSettingsCompleteProtocol <NSObject>

-(void)getApplicationSettingsDidComplete:(Application*)application;
-(void)getApplicationSettingsDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;

@end
