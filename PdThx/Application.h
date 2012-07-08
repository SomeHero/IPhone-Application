//
//  Application.h
//  PdThx
//
//  Created by James Rhodes on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileSection.h"

@interface Application : NSObject
<NSCopying> {
@private
    NSString* apiKey;
    NSString* applicationId;
    NSMutableArray* profileSections;
}

@property(nonatomic, retain) NSString* apiKey;
@property(nonatomic, retain) NSString* applicationId;
@property(nonatomic, retain) NSMutableArray* profileSections;

-(Application *) initWithDictionary : (NSDictionary *) dictionary;

@end
