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
    NSInteger itemId;
    NSString* label;
    NSInteger sortOrder;
    NSString* attributeId;
    NSString* itemType;
    NSInteger points;
    NSMutableArray* options;
}

@property(nonatomic) NSInteger itemId;
@property(nonatomic, retain) NSString* label;
@property(nonatomic, retain) NSString* attributeId;
@property(nonatomic) NSInteger sortOrder;
@property(nonatomic, retain) NSString* itemType;
@property(nonatomic) NSInteger points;
@property(nonatomic, retain) NSMutableArray* options;

-(ProfileItem *) initWithDictionary : (NSDictionary *) dictionary;

@end
