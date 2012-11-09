//
//  UserHomeScreenInformationProtocol.h
//  PdThx
//
//  Created by James Rhodes on 10/31/12.
//
//

#import <Foundation/Foundation.h>

@protocol UserHomeScreenInformationProtocol <NSObject>

-(void)userHomeScreenInformationDidComplete:(NSDictionary*) quickSendDictionary;
-(void)userHomeScreenInformationDidFail:(NSString*) message withErrorCode:(int)errorCode;

@end
