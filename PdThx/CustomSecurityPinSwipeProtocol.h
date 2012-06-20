//
//  CustomPinSwipeProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomSecurityPinSwipeProtocol;

@protocol CustomSecurityPinSwipeProtocol <NSObject>

-(void)swipeDidComplete: (id)sender withPin: (NSString*)pin;
-(void)swipeDidCancel: (id)sender;

@end
