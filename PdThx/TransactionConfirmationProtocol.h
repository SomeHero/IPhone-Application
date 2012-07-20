//
//  TransactionConfirmationProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TransactionConfirmationProtocol;

@protocol TransactionConfirmationProtocol <NSObject>

-(void)onHomeClicked;
-(void)onContinueClicked;

@end
