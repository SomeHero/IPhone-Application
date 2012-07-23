//
//  DetermineRecipientCompletelyProtocol.h
//  PdThx
//
//  Created by Edward Mitchell on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DetermineRecipientCompleteProtocol <NSObject>

-(void) determineRecipientDidComplete:(NSArray*) recipients;
-(void) determineRecipientDidFail:(NSString*) message;

@end
