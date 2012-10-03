//
//  PersonalizeUserCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PersonalizeUserCompleteProtocol;

@protocol PersonalizeUserCompleteProtocol <NSObject>

-(void) personalizeUserDidComplete;
-(void) personalizeUserDidFail:(NSString*) response withErrorCode:(int)errorCode;

@end
