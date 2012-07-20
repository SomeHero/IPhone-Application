//
//  NonProfitDetail.h
//  PdThx
//
//  Created by James Rhodes on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NonProfitDetail : NSObject
<NSCopying> {
@private
    NSString* merchantId;
    NSString* name;
    NSString* imageUrl;
    NSString* preferredReceiveAccountId;
    NSString* tagLine;
    NSString* description;
    NSDecimalNumber* suggestedAmount;
}

@property(nonatomic, retain) NSString* merchantId;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* imageUrl;
@property(nonatomic, retain) NSString* preferredReceiveAccountId;
@property(nonatomic, retain) NSString* tagLine;
@property(nonatomic, retain) NSString* description;
@property(nonatomic, retain) NSDecimalNumber* suggestedAmount;

-(NonProfitDetail *) initWithDictionary : (NSDictionary *) dictionary;

@end