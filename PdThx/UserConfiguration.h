//
//  UserConfiguration.h
//  PdThx
//
//  Created by James Rhodes on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserConfiguration : NSObject<NSCopying> {
@private
    NSString* Key;
    NSString* Value;
}

@property(nonatomic, retain) NSString* Key;
@property(nonatomic, retain) NSString* Value;

-(UserConfiguration *) initWithDictionary : (NSDictionary *) dictionary;

@end
