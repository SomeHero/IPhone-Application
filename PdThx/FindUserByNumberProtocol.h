//
//  FindUserByNumberProtocol.h
//  PdThx
//
//  Created by Christopher Magee on 8/25/12.
//
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@protocol FindUserByNumberProtocol;

@protocol FindUserByNumberProtocol <NSObject>


-(void)didFindUserWithContactObject:(Contact*)contactObject;

@end
