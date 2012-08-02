//
//  ModalSelectProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModalSelectProtocol <NSObject>

-(void) optionDidSelect:(NSString*) optionId;

@end
