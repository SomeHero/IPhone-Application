//
//  MerchantOffer.h
//  PdThx
//
//  Created by James Rhodes on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantOffer : NSObject
{
    NSString* Id;
    NSDecimalNumber* Amount; 
}

@property(nonatomic, retain) NSString* Id;
@property(nonatomic, retain) NSDecimalNumber* Amount;

-(MerchantOffer *) initWithDictionary : (NSDictionary *) dictionary;

@end
