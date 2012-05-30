//
//  PaystreamMessage.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PaystreamMessage : NSObject {
    NSDecimalNumber* amount;
    NSString* comments;
    NSString* messageId;
    NSString* messageStatus;
    NSString* messageType;
    NSString* recipientUri;
    NSString* senderUri;
    NSDate* createDate;
    
}

@property(nonatomic, retain) NSDecimalNumber* amount;
@property(nonatomic, retain) NSString* comments;
@property(nonatomic, retain) NSString* messageId;
@property(nonatomic, retain) NSString* messageStatus;
@property(nonatomic, retain) NSString* messageType;
@property(nonatomic, retain) NSString* recipientUri;
@property(nonatomic, retain) NSString* senderUri;
@property(nonatomic, retain) NSDate* createDate;

@end
