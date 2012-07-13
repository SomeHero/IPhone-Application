//
//  GetSecurityQuestionsProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GetSecurityQuestionsProtocol;

@protocol GetSecurityQuestionsProtocol <NSObject>

-(void)loadedSecurityQuestions:(NSMutableArray*)questionArray;

@end

