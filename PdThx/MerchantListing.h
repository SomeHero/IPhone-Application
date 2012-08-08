//
//  MerchantListing.h
//  PdThx
//
//  Created by James Rhodes on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MerchantOffer.h"

@interface MerchantListing : NSObject
{
    NSString* Id;
    NSString* TagLine;
    NSString* Description;
    NSMutableArray* Offers;
}

@property(nonatomic, retain) NSString* Id;
@property(nonatomic, retain) NSString* TagLine;
@property(nonatomic, retain) NSString* Description;
@property(nonatomic, retain) NSMutableArray* Offers;

-(MerchantListing *) initWithDictionary : (NSDictionary *) dictionary;

@end
