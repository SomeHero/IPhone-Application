//
//  ApplicationConfiguration.h
//  PdThx
//
//  Created by James Rhodes on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationConfiguration : NSObject<NSCopying> {
@private
    NSString* Id;
    NSString* ApiKey;
    NSString* ConfigurationKey;
    NSString* ConfigurationValue;
    NSString* ConfigurationType;
}

@property(nonatomic, retain) NSString* Id;
@property(nonatomic, retain) NSString* ApiKey;
@property(nonatomic, retain) NSString* ConfigurationKey;
@property(nonatomic, retain) NSString* ConfigurationValue;
@property(nonatomic, retain) NSString* ConfigurationType;

-(ApplicationConfiguration *) initWithDictionary : (NSDictionary *) dictionary;

@end