//
//  UserProfileItem.h
//  PdThx
//
//  Created by James Rhodes on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfileItem : NSObject {

@private
    NSString* itemKey;
    NSString* itemValue;
    NSInteger pointValue;
}

@property(nonatomic, retain) NSString* itemKey;
@property(nonatomic, retain) NSString* itemValue;
@property(nonatomic) NSInteger pointValue;

-(UserProfileItem *) initWithDictionary : (NSDictionary *) dictionary;

@end
