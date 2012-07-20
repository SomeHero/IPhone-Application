//
//  GetPayStreamService.h
//  PdThx
//
//  Created by James Rhodes on 5/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "GetPayStreamCompleteProtocol.h"

@interface GetPayStreamService : NSObject {
    ASIHTTPRequest* requestObj;
    id<GetPayStreamCompleteProtocol> getPayStreamCompleteDelegate;
}

@property(retain) id getPayStreamCompleteDelegate;

-(void)getPayStream:(NSString*) userId;

@end
