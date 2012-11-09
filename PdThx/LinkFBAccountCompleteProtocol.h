//
//  LinkFBAccountCompleteProtocol.h
//  PdThx
//
//  Created by James Rhodes on 10/31/12.
//
//

#import <Foundation/Foundation.h>

@protocol LinkFBAccountCompleteProtocol <NSObject>

-(void)linkFBAccountDidComplete;
-(void)linkFBAccountDidFail: (NSString*) errorMessage withErrorCode:(int)errorCode;

@end
