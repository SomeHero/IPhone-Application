//
//  ACHSetupCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 4/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ACHSetupCompleteProtocol;


#pragma mark -
#pragma mark Protocol
@protocol ACHSetupCompleteProtocol <NSObject>

-(void)achSetupDidComplete;

@end
