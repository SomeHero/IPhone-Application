//
//  MeCodeProtocol.h
//  PdThx
//
//  Created by Justin Cheng on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeCodeCreateCompleteProtocol <NSObject>
-(void) meCodeCreateSuccess;
-(void)meCodeCreateDidFail:(NSString*) response withErrorCode:(int)errorCode;
@end
