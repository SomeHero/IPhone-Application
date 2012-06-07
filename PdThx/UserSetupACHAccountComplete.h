//
//  UserSetupACHAccountComplete.h
//  PdThx
//
//  Created by James Rhodes on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserSetupACHAccountComplete;

@protocol UserSetupACHAccountComplete <NSObject>

-(void)achAccountSetupDidComplete;
-(void)achACcountSetupDidSkip;

@end

