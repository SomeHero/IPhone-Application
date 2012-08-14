//
//  SetContactAndAmountProtocol.h
//  PdThx
//
//  Created by James Rhodes on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SetContactAndAmountProtocol <NSObject>

-(void)didSetContactAndAmount: (Contact*)contact amount:(double)amountToSend;

@end
