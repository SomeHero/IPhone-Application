//
//  UpdateBankAccountProtocol.h
//  PdThx
//
//  Created by James Rhodes on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UpdateBankAccountProtocol; 

@protocol UpdateBankAccountProtocol <NSObject>

-(void)updateBankAccountDidComplete;
-(void)updateBankAccountDidFail:(NSString*)errorMessage;

@end
