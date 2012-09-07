//
//  ValidationHelper.m
//  PdThx
//
//  Created by James Rhodes on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ValidationHelper.h"

@implementation ValidationHelper

-(BOOL)isValidNameOnAccount:(NSString *) nameToTest {
    if([nameToTest length] == 0)
        return false;
    
    return true;
}

-(BOOL)isValidRoutingNumber:(NSString *) routingNumberToTest {
    if([routingNumberToTest length] == 0)
        return false;
    
    return true;
}

-(BOOL)isValidAccountNumber:(NSString *) accountNumberToTest {
    if([accountNumberToTest length] == 0 || [accountNumberToTest length] < 4 || [accountNumberToTest length] > 17)
        return false;
    
    return true;
}


-(BOOL)doesAccountNumberMatch:(NSString *) accountNumberToTest doesMatch:(NSString *) confirmationNumber {
    if(![accountNumberToTest isEqualToString:confirmationNumber])
        return false;
    
    return true;
}


-(BOOL)isValidSecurityPinSwipe:(NSString*)swipedPin
{
    if ( swipedPin.length < 4 )
        return false;
    else
        return true;
}

-(BOOL)verifySecurityPinsMatch:(NSString*)firstPin andSecondPin:(NSString*)secondPin
{
    if ( [firstPin isEqualToString:secondPin] )
        return true;
    else
        return false;
}
@end
