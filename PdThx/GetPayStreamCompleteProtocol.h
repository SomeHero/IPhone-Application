//
//  GetPayStreamCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetPayStreamCompleteProtocol;

@protocol GetPayStreamCompleteProtocol <NSObject>

-(void)getPayStreamDidComplete:(NSMutableArray*)payStreamMessages;
-(void)getPayStreamDidFail:(NSString*)message withErrorCode:(int)errorCode;

@end
