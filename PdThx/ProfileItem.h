//
//  ProfileItem.h
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileItem : NSObject
<NSCopying> {
@private
    NSString* attributeName;
    NSString* attributeValue;
}

@property(nonatomic, retain) NSString* attributeName;
@property(nonatomic, retain) NSString* attributeValue;

-(ProfileItem *) initWithDictionary : (NSDictionary *) dictionary;

@end
