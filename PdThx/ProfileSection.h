//
//  ProfileSection.h
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileItem.h"

@interface ProfileSection : NSObject
<NSCopying> {
@private
    NSInteger sectionId;
    NSString* sectionHeader;
    NSInteger sortOrder;
    NSMutableArray* profileItems;
}

@property(nonatomic) NSInteger sectionId;
@property(nonatomic, retain) NSString* sectionHeader;
@property(nonatomic, retain) NSMutableArray* profileItems;
@property(nonatomic) NSInteger sortOrder;

-(ProfileSection*) initWithDictionary : (NSDictionary *) dictionary;

@end
