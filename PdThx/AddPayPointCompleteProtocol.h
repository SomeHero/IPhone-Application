//
//  AddPayPointCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Application.h"
#import "PayPoint.h"

@protocol AddPayPointCompleteProtocol;

@protocol AddPayPointCompleteProtocol <NSObject>

-(void)addPayPointsDidComplete: (NSString*) payPoint;
-(void)addPayPointsDidFail: (NSString*) errorMessage;

@end
