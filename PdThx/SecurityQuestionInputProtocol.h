//
//  SecurityQuestionInputProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SecurityQuestionInputProtocol <NSObject>

-(void)choseSecurityQuestion:(int)questionId withAnswer:(NSString*)questionAnswer;

@end
