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
@synthesize recipientUriType;
@synthesize recipientImageUri;
@synthesize recipientImage;
@synthesize recipientName;
@synthesize senderName;
@synthesize senderImage;
@synthesize senderImageUri;
@synthesize imgData;
@synthesize transactionImageUri;
@synthesize senderHasSeen, recipientHasSeen;
@synthesize isCancellable;
@synthesize isRemindable;
@synthesize isAcceptable;
@synthesize isRejectable;
@synthesize isExpressable;
@synthesize deliveryMethod, deliveryCharge;

-(id)init
{
    self = [super init];
    
    
    if(self)
    {
    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    if(self) {
        messageId = [[dictionary objectForKey:@"Id"] copy];
        amount = [[dictionary objectForKey:@"amount"] copy];
        comments =[[dictionary valueForKey:@"comments"] copy];
        messageStatus = [[dictionary valueForKey:@"messageStatus"] copy];
        messageType = [[dictionary valueForKey:@"messageType"] copy];
        senderUri = [[dictionary valueForKey:@"senderUri"] copy];
        recipientUri = [[dictionary valueForKey:@"recipientUri"] copy];
        recipientUriType = [[dictionary valueForKey: @"recipientUriType"] copy];
        recipientImageUri = [[dictionary valueForKey: @"recipientImageUri"] copy];
        NSString* rawData = [[dictionary valueForKey:@"createDate"] autorelease];
        createDate = [[format dateFromString: rawData] copy];
        
        NSTimeInterval seconds = -60*60;
        if([localTimeZone isDaylightSavingTime])
            createDate = [[createDate dateByAddingTimeInterval: seconds] copy];
        
        direction = [[dictionary valueForKey:@"direction"] copy];
        recipientName = [[dictionary valueForKey:@"recipientName"] copy];
        senderName = [[dictionary valueForKey:@"senderName"] copy];
        senderImageUri = [[dictionary valueForKey: @"senderImageUri"] copy];
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
