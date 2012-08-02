//
//  PayPoint.h
//  PdThx
//
//  Created by James Rhodes on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayPoint : NSObject {

@private
    NSString* payPointId;
    NSString* userId;
    NSString* payPointType;
    NSString* uri;
    bool verified;
}

@property(nonatomic, retain) NSString* payPointId;
@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* payPointType;
@property(nonatomic, retain) NSString* uri;
@property(nonatomic) bool verified;
-(PayPoint *) initWithDictionary : (NSDictionary *) dictionary;
@end
