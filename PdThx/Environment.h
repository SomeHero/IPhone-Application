//
//  Environment.h
//  PdThx
//
//  Created by James Rhodes on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface Environment : NSObject {
    NSString* pdthxWebServicesBaseUrl;
    NSString *pdthxAPIKey;
    NSString *deviceToken;
}

@property(nonatomic, retain) NSString* pdthxWebServicesBaseUrl;
@property(nonatomic, retain) NSString* pdthxAPIKey;
@property(nonatomic, retain) NSString* deviceToken;

+ (Environment *)sharedInstance;

@end
