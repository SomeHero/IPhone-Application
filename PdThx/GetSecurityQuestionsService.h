//
//  GetSecurityQuestionsService.h
//  PdThx
//
//  Created by James Rhodes on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "GetSecurityQuestionsProtocol.h"

@interface GetSecurityQuestionsService : NSObject {
    ASIHTTPRequest* requestObj;
    id<GetSecurityQuestionsProtocol> questionsLoadedDelegate;
}

@property(retain) id questionsLoadedDelegate;

-(void)getSecurityQuestions:(bool)onlyActive;

@end
