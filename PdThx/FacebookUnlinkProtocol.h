//
//  FacebookUnlinkProtocol.h
//  PdThx
//
//  Created by Christopher Magee on 9/20/12.
//
//

#import <Foundation/Foundation.h>

@protocol FacebookUnlinkProtocol <NSObject>

-(void)facebookAccountUnlinkSuccess;
-(void)facebookAccountUnlinkFailed;

@end
