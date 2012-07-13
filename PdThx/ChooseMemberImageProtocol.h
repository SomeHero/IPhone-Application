//
//  ChooseMemberImageProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseMemberImageProtocol;

@protocol ChooseMemberImageProtocol <NSObject>

-(void)chooseMemberImageDidComplete: (NSString*) imageUrl;

@end
