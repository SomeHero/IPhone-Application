//
//  TakeCheckPictureProtocol.h
//  PdThx
//
//  Created by James Rhodes on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TakeCheckPictureProtocol;

@protocol TakeCheckPictureProtocol <NSObject>

-(void)checkImageDidReturn:(UIImage *)image;

@end
