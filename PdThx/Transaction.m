//
//  Transaction.m
//  PdThx
//
//  Created by James Rhodes on 4/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transaction.h"


@implementation Transaction

@synthesize transactionId, paymentId, senderUri, recipientUri, amount, achTransactionId, transactionStatus, transactionCategory, transactionType,
standardEntryClass, paymentChannel, transactionBatchId, transactionSentDate,  createDate, lastUpdatedDate, direction;
@synthesize recipientName;
@synthesize recipientImageUri;
@synthesize senderName;
@synthesize senderImageUri;

-(id)init {
    self = [super init];
    
    
    if(self) {
        transactionId = [[NSString alloc] init];
        paymentId = [[NSString alloc] init];
        senderUri = [[NSString alloc] init];
        recipientUri = [[NSString alloc] init];
        amount = [[NSNumber alloc] init];
        achTransactionId = [[NSString alloc] init];
        transactionStatus = [[NSString alloc] init];
        transactionCategory = [[NSString alloc] init];
        transactionType = [[NSString alloc] init];
        standardEntryClass = [[NSString alloc] init];
        paymentChannel = [[NSString alloc] init];
        transactionBatchId = [[NSString alloc] init];
        transactionSentDate = [[NSDate alloc] init];
        createDate = [[NSDate alloc] init];
        lastUpdatedDate = [[NSDate alloc] init];
        direction = [[NSString alloc] init];
        recipientName = [[NSString alloc] init];
        recipientImageUri = [[NSString alloc] init];
        senderName = [[NSString alloc] init];
        senderImageUri = [[NSString alloc] init];
    }
    
    return self;
}
-(id)initWithDictionary:(NSDictionary *)dictionary  {
    self = [super init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    
    if(self) { 
        transactionId = [[dictionary valueForKey:@"transactionId"] copy];
        paymentId = [[dictionary valueForKey:@"paymentId"] copy];
        senderUri = [[dictionary valueForKey:@"senderUri"] copy];
        recipientUri = [[dictionary valueForKey:@"recipientUri"] copy];
        amount = [[dictionary objectForKey:@"amount"] copy];
        achTransactionId = [[dictionary valueForKey:@"achTransactionId"] copy];
        transactionStatus = [[dictionary valueForKey:@"transactionStatus"] copy];
        transactionCategory = [[dictionary valueForKey:@"transactionCategory"] copy];
        transactionType = [[dictionary valueForKey:@"transactionType"] copy];
        standardEntryClass = [[dictionary valueForKey:@"standardEntryClass"] copy];
        paymentChannel = [[dictionary valueForKey:@"paymentChannel"] copy];
        transactionBatchId = [[dictionary valueForKey:@"transactionBatchId"] copy];
        transactionSentDate = [[dictionary valueForKey:@"transctionSentDate"] copy];
        
        NSString* rawData = [[dictionary valueForKey:@"createDate"] autorelease];
        NSRange timezone = NSMakeRange([rawData length] - 10, 3);
        NSString *cleanData = [rawData stringByReplacingOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:timezone ];
        createDate = [[format dateFromString: cleanData] copy];
        lastUpdatedDate = [[dictionary valueForKey:@"lastUpdatedDate"] copy];
        direction = [[dictionary valueForKey:@"direction"] copy];
        senderName = [[dictionary valueForKey:@"senderName"] copy];
        senderImageUri = [[dictionary valueForKey:@"senderImageUri"] copy];
        recipientName = [[dictionary valueForKey:@"recipientName"] copy];
        recipientImageUri = [[dictionary valueForKey:@"recipientImageUri"] copy];
    }
    
    [format release];
    
    return self;
    
}

-(void)dealloc {
    [transactionId release];
    [paymentId release];
    [senderUri release];
    [recipientUri release];
    [amount release];
    [achTransactionId release];
    [transactionStatus release];
    [transactionCategory release];
    [standardEntryClass release];
    [paymentChannel release];
    [transactionBatchId release];
    [transactionSentDate release];
    [createDate release];
    [lastUpdatedDate release];
    [direction release];
    [senderName release];
    [senderImageUri release];
    [recipientName release];
    [recipientImageUri release];
    
    [super dealloc];
}
@end