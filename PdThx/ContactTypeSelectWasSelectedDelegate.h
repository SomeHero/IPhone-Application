//
//  ContactSelectWasSelectedDelegate.h
//  TSPopoverDemo
//
//  Created by James Rhodes on 7/14/12.
//  Copyright (c) 2012 ar.ms. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ContactTypeSelectWasSelectedDelegate <NSObject>

-(void)contactWasSelected:(NSInteger)contactType;

@end
