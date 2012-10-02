//
//  SetPreferredAccountProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SetPreferredAccountProtocol;

@protocol SetPreferredAccountProtocol <NSObject>

-(void)setPreferredAccountDidComplete;
-(void)setPreferredAccountDidFail:(NSString*)responseMsg withErrorCode:(int)errorCode;

@end
