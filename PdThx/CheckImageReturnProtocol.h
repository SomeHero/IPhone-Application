//
//  CheckImageReturnProtocol.h
//  PdThx
//
//  Created by Christopher Magee on 8/27/12.
//
//

#import <Foundation/Foundation.h>

@protocol CheckImageReturnProtocol;

@protocol CheckImageReturnProtocol <NSObject>

-(void)cameraReturnedImage:(UIImage*)image;

@end
