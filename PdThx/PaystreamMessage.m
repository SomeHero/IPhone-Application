//
//  PaystreamMessage.m
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PaystreamMessage.h"


@implementation PaystreamMessage

@synthesize amount;
@synthesize comments;
@synthesize messageId;
@synthesize messageStatus;
@synthesize messageType;
@synthesize recipientUri;
@synthesize senderUri;
@synthesize createDate;
@synthesize direction;
@synthesize recipientName;
@synthesize senderName;
@synthesize imgData;
@synthesize transactionImageUri;
@synthesize senderHasSeen, recipientHasSeen;
@synthesize isCancellable;
@synthesize isRemindable;
@synthesize isAcceptable;
@synthesize isRejectable;
@synthesize isExpressable;

@synthesize deliveryMethod, deliveryCharge;

-(id)init {
    self = [super init];
    
    
    if(self)
    {
        /*
        amount = [[NSDecimalNumber alloc] init];
        comments = [[NSString alloc] init];
        messageId = [[NSString alloc] init];
        messageStatus = [[NSString alloc] init];
        messageType = [[NSString alloc] init];
        senderUri = [[NSString alloc] init];
        recipientUri = [[NSString alloc] init];
        createDate = [[NSDate alloc] init];
        direction = [[NSString alloc] init];
        recipientName = [[NSString alloc] init];
        senderName = [[NSString alloc] init];
        transactionImageUri = [[NSString alloc] init];
         */
        
        // We probably shouldn't initialize the above variables... We would be losing memory by initializing strings, and then setting the variables to copies of objects from the dictionary we pass.
     }
    
    return self;
}
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    
    if(self) { 
        messageId = [[dictionary objectForKey:@"Id"] copy];
        amount = [[dictionary objectForKey:@"amount"] copy];
        comments =[[dictionary valueForKey:@"comments"] copy];
        messageStatus = [[dictionary valueForKey:@"messageStatus"] copy];
        messageType = [[dictionary valueForKey:@"messageType"] copy];
        senderUri = [[dictionary valueForKey:@"senderUri"] copy];
        recipientUri = [[dictionary valueForKey:@"recipientUri"] copy];
        
        NSString* rawData = [[dictionary valueForKey:@"createDate"] autorelease];
        NSRange timezone = NSMakeRange([rawData length] - 10, 3);
        NSString *cleanData = [rawData stringByReplacingOccurrencesOfString:@":" withString:@"" options:NSCaseInsensitiveSearch range:timezone ];
        createDate = [[format dateFromString: cleanData] copy];
        direction = [[dictionary valueForKey:@"direction"] copy];
        recipientName = [[dictionary valueForKey:@"recipientName"] copy];
        senderName = [[dictionary valueForKey:@"senderName"] copy];
        transactionImageUri = [[dictionary valueForKey:@"transactionImageUri"] copy];
        senderHasSeen = [[dictionary objectForKey:@"senderSeen"] boolValue];
        recipientHasSeen = [[dictionary objectForKey:@"recipientSeen"] boolValue];
        
        isCancellable = [[dictionary objectForKey: @"isCancellable"] boolValue];
        isRemindable = [[dictionary objectForKey: @"isRemindable"] boolValue];
        isAcceptable = [[dictionary objectForKey: @"isAcceptable"] boolValue];
        isRejectable = [[dictionary objectForKey: @"isRejectable"] boolValue];
    }
    
    [format release];
    
    return self;
    
}

-(void)dealloc {
    
    [super dealloc];
    
    //[amount release];
    //[comments release];
    //[messageId release];
    //[messageStatus release];
    //[messageType release];
    //[senderUri release];
    //[recipientUri release];
    //[imgData release];
    //[transactionImageUri release];
}

@end
