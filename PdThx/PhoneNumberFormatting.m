//
//  PhoneNumberFormatting.m
//  PdThx
//
//  Created by James Rhodes on 5/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhoneNumberFormatting.h"


@implementation PhoneNumberFormatting

-(NSString *)stringToFormattedPhoneNumber:(NSString *)aString {
    
    NSString *tempPhoneNumber = [[aString componentsSeparatedByCharactersInSet:
                                  [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] 
                                 componentsJoinedByString:@""];
    

    if([tempPhoneNumber length] >= 10)
    {
        if([tempPhoneNumber characterAtIndex:0] == 1)
            tempPhoneNumber = [tempPhoneNumber substringWithRange:NSMakeRange(1, [tempPhoneNumber length] -1)];
        
        NSString* phoneNumber = [NSString stringWithFormat: @"(%@) %@-%@", [tempPhoneNumber substringWithRange:NSMakeRange(0, 3)], [tempPhoneNumber substringWithRange:NSMakeRange(3, 3)], [tempPhoneNumber substringWithRange:NSMakeRange(6, 4)]];
        
        return phoneNumber;
    }
    
    return aString;
    
}

@end
