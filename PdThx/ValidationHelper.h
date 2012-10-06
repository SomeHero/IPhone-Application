//
//  ValidationHelper.h
//  PdThx
//
//  Created by James Rhodes on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidationHelper : NSObject

-(BOOL) isValidNameOnAccount:nameOnAccount;
-(BOOL) isValidRoutingNumber:routingNumber;
-(BOOL) isValidAccountNumber:accountNumber;
-(BOOL) doesAccountNumberMatch: accountNumber doesMatch: confirmAccountNumber;
-(BOOL)verifySecurityPinsMatch:(NSString*)firstPin andSecondPin:(NSString*)secondPin;
-(BOOL)isValidSecurityPinSwipe:(NSString*)swipedPin;
-(BOOL)isRequired:(NSString*) valueToTest;

@end



