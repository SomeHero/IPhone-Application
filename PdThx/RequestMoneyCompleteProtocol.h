//
//  RequestMoneyCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestMoneyCompleteProtocol;

@protocol RequestMoneyCompleteProtocol <NSObject>

-(void)requestMoneyDidComplete;
-(void)requestMoneyDidFail: (NSString*) message;

@end
