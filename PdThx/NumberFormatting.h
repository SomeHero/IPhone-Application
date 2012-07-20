//
//  NumberFormatting.h
//  PdThx
//
//  Created by James Rhodes on 4/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NumberFormatting : NSObject {
    
}

-(NSString *)stringToCurrency:(NSString *)aString;
-(NSString *)decimalToIntString:(NSDecimalNumber *)aDecimal;

@end