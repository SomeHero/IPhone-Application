//
//  Application.h
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileItem.h"

@interface Application : NSObject
<NSCopying> {
@private
    NSString* apiKey;
    NSString* applicationId;
    NSMutableArray* profileItems;
}

@property(nonatomic, retain) NSString* apiKey;
@property(nonatomic, retain) NSString* applicationId;
@property(nonatomic, retain) NSMutableArray* profileItems;

-(Application *) initWithDictionary : (NSDictionary *) dictionary;

@end
