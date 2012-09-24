//
//  FacebookLinkProtocol.h
//  PdThx
//
//  Created by Christopher Magee on 9/20/12.
//
//

#import <Foundation/Foundation.h>

@protocol FacebookLinkProtocol <NSObject>

-(void)facebookAccountLinkSuccess;
-(void)facebookAccountLinkFailed;

@end
