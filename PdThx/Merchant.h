//
//  Merchant.h
//  PdThx
//
//  Created by James Rhodes on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Merchant : NSObject
<NSCopying> {
@private
    NSString* merchantId;
    NSString* name;
    NSString* imageUrl;
    NSString* preferredReceiveAccountId;
}

@property(nonatomic, retain) NSString* merchantId;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* imageUrl;
@property(nonatomic, retain) NSString* preferredReceiveAccountId;

-(Merchant *) initWithDictionary : (NSDictionary *) dictionary;

@end
