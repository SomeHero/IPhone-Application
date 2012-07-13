//
//  SetupUserProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserSetupCompleteProtocol;

@protocol UserSetupCompleteProtocol <NSObject>

-(void)setupUserDidComplete: (id)sender;

@end
