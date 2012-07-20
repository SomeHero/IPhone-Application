//
//  GetPayPointProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetPayPointProtocol;

@protocol GetPayPointProtocol <NSObject>

-(void)getPayPointsDidComplete:(NSMutableArray*)payPoints;
-(void)getPayPointsDidFail: (NSString*) errorMessage;

@end
