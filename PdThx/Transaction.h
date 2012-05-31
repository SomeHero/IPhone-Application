//
//  Transaction.h
//  PdThx
//
//  Created by James Rhodes on 4/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
// comments --- James

#import <Foundation/Foundation.h>


@interface Transaction : NSObject {
@private
    NSString* transactionId;
    NSString* paymentId;
    NSString* senderUri;
    NSString* recipientUri;
    NSDecimalNumber* amount;
    NSNumber* achTransactionId;
    NSString* transactionStatus;
    NSString* transactionCategory;
    NSString* transactionType;
    NSString* standardEntryClass;
    NSString* paymentChannel;
    NSString* transactionBatchId;
    NSDate* transactionSentDate;
    NSDate* createDate;
    NSDate* lastUpdatedDate;
    NSString* direction;
    NSString* senderName;
    NSString* senderImageUri;
    NSString* recipientName;
    NSString* recipientImageUri;
}
@property(nonatomic, retain) NSString* transactionId;
@property(nonatomic, retain) NSString* paymentId;
@property(nonatomic, retain) NSString* senderUri;
@property(nonatomic, retain) NSString* recipientUri;
@property(nonatomic, retain) NSDecimalNumber* amount;
@property(nonatomic, retain) NSNumber* achTransactionId;
@property(nonatomic, retain) NSString* transactionStatus;
@property(nonatomic, retain) NSString* transactionCategory;
@property(nonatomic, retain) NSString* transactionType;
@property(nonatomic, retain) NSString* standardEntryClass;
@property(nonatomic, retain) NSString* paymentChannel;
@property(nonatomic, retain) NSString* transactionBatchId;
@property(nonatomic, retain) NSDate* transactionSentDate;
@property(nonatomic, retain) NSDate* createDate;
@property(nonatomic, retain) NSDate* lastUpdatedDate;
@property(nonatomic, retain) NSString* direction;
@property(nonatomic, retain) NSString* senderName;
@property(nonatomic, retain) NSString* senderImageUri;
@property(nonatomic, retain) NSString* recipientName;
@property(nonatomic, retain) NSString* recipientImageUri;

-(Transaction *) initWithDictionary : (NSDictionary *) dictionary;

@end