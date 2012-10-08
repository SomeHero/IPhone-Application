//
//  UserAttribute.h
//  PdThx
//
//  Created by James Rhodes on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAttribute : NSObject<NSCopying, NSMutableCopying> {
@private
    NSString* attributeId;
    NSString* attributeName;
    NSString* attributeValue;
}

@property(nonatomic, retain) NSString* attributeId;
@property(nonatomic, retain) NSString* attributeName;
@property(nonatomic, retain) NSString* attributeValue;

-(UserAttribute *) initWithDictionary : (NSDictionary *) dictionary;

@end
