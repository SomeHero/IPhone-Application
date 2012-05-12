//
//  NumberFormatting.m
//  PdThx
//
//  Created by James Rhodes on 4/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "NumberFormatting.h"


@implementation NumberFormatting

-(NSString *)stringToCurrency:(NSString *)aString {
    NSNumberFormatter *currencyFormatter  = [[[NSNumberFormatter alloc] init] autorelease];
    [currencyFormatter setGeneratesDecimalNumbers:YES];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    if ([aString length] == 0)
        aString = @"0";
    
    //convert the integer value of the price to a decimal number i.e. 123 = 1.23
    //[currencyFormatter maximumFractionDigits] gives number of decimal places we need to have
    //multiply by -1 so the decimal moves inward
    //we are only dealing with positive values so the number is not negative
    NSDecimalNumber *value  = [NSDecimalNumber decimalNumberWithMantissa:[aString integerValue]
                                                                exponent:(-1 * [currencyFormatter maximumFractionDigits])
                                                              isNegative:NO];
    
    return [currencyFormatter stringFromNumber:value];
}

-(NSString *)decimalToIntString:(NSDecimalNumber *)aDecimal {
    NSNumberFormatter *currencyFormatter  = [[[NSNumberFormatter alloc] init] autorelease];
    [currencyFormatter setGeneratesDecimalNumbers:YES];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    if (aDecimal == nil)
        aDecimal = [NSDecimalNumber zero];
    
    NSDecimalNumber *price  = [NSDecimalNumber decimalNumberWithMantissa:[aDecimal integerValue]
                                                                exponent:([currencyFormatter maximumFractionDigits])
                                                              isNegative:NO];
    
    return [price stringValue];
}

@end