//
//  DeletePayPointDelegate.h
//  PdThx
//
//  Created by James Rhodes on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DeletePayPointDelegate <NSObject>

-(void)deletePayPointCompleted;
-(void)deletePayPointFailed: (NSString*) errorMessage;

@end
