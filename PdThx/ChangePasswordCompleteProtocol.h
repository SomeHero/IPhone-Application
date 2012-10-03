//
//  ChangePasswordCompleteProtocol.h
//  PdThx
//
//  Created by Edward Mitchell on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChangePasswordCompleteProtocol <NSObject>

-(void) changePasswordSuccess;
-(void) changePasswordDidFail: (NSString*) response withErrorCode:(int)errorCode;

@end
