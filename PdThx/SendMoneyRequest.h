//
//  SendMoneyRequest.h
//  PdThx
//
//  Created by James Rhodes on 2/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SendMoneyRequest : NSObject {
    NSString* _recipientUri;
    NSString* _amount;
    NSString* _comments;
}

+(SendMoneyRequest *) sendMoneyRequest;

-(void) setRecipientUri: (NSString*) recipient;
-(NSString *) recipientUri;
-(void) setAmount: (NSString*) amount;
-(NSString *) amount;
-(void) setComments: (NSString*) comments;
-(NSString *) comments;
-(void) reset;

@end
