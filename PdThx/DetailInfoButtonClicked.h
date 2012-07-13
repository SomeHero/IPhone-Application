//
//  DetailInfoButtonClicked.h
//  PdThx
//
//  Created by James Rhodes on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DetailInfoButtonClicked;

@protocol DetailInfoButtonClicked <NSObject>

-(void)infoButtonClicked: (NSString*) merchantId;


@end
