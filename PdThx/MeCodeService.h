//
//  MeCodeService.h
//  PdThx
//
//  Created by Justin Cheng on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "Environment.h"
#import "MeCodeCreateCompleteProtocol.h"
@interface MeCodeService : NSObject
{
    ASIHTTPRequest *requestObj;
    id<MeCodeCreateCompleteProtocol> meCodeCreateCompleteDelegate;
}

@property(retain) id MeCodeCreateCompleteDelegate;

-(void) validateMeCode:(NSString*)userId withMeCode: (NSString *)meCode;
@end
