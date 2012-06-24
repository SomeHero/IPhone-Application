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
    if([accountNumberToTest length] == 0)
        return false;
    
    return true;
}


-(BOOL)doesAccountNumberMatch:(NSString *) accountNumberToTest doesMatch:(NSString *) confirmationNumber {
    if(![accountNumberToTest isEqualToString:confirmationNumber])
        return false;
    
    return true;
}
@end
