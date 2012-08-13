//
//  UpdateSeenMessagesProtocol.h
//  PdThx
//
//  Created by James Rhodes on 8/10/12.
//
//

#import <Foundation/Foundation.h>

@protocol UpdateSeenMessagesProtocol <NSObject>

-(void)paystreamUpdated:(bool)success;

@end
