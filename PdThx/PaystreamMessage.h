//
//  PaystreamMessage.h
//  PdThx
//
//  Created by James Rhodes on 5/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.

#import <Foundation/Foundation.h>

@interface PaystreamMessage : NSObject
{
    NSDecimalNumber* amount;
    NSString* comments;
    NSString* messageId;
    NSString* messageStatus;
    NSString* messageType;
    NSString* recipientUri;
    NSString* recipientImageUri;
    UIImage* recipientImageData;;
    NSString* senderUri;
    NSString* senderImageUri;
    UIImage* senderImageData;
    NSDate* createDate;
    NSString* direction;
    NSString* recipientName;
    NSString* recipientUriType;
    NSString* senderName;
    NSString* transactionImageUri;
    UIImage * imgData;
    bool senderHasSeen;
    bool recipientHasSeen;
    
    bool isCancellable;
    bool isRemindable;
    bool isRejectable;
    bool isAcceptable;
    bool isExpressable;
    
    NSString* deliveryMethod;
    double deliveryCharge;
}

@property(nonatomic, retain) NSDecimalNumber* amount;
@property(nonatomic, retain) NSString* comments;
@property(nonatomic, retain) NSString* messageId;
@property(nonatomic, retain) NSString* messageStatus;
@property(nonatomic, retain) NSString* messageType;
@property(nonatomic, retain) NSString* recipientUri;
@property(nonatomic, retain) NSString* recipientImageUri;
@property(nonatomic, retain) UIImage* recipientImage;
@property(nonatomic, retain) NSString* recipientUriType;
@property(nonatomic, retain) NSString* senderUri;
@property(nonatomic, retain) NSString* senderImageUri;
@property(nonatomic, retain) UIImage* senderImage;
@property(nonatomic, retain) NSDate* createDate;
@property(nonatomic, retain) NSString* direction;
@property(nonatomic, retain) NSString* recipientName;
@property(nonatomic, retain) NSString* transactionImageUri;
@property(nonatomic, retain) NSString* senderName;
@property (nonatomic, retain) UIImage* imgData;

@property(assign) bool senderHasSeen;
@property(assign) bool recipientHasSeen;

@property(assign) bool senderExpressed;
@property(assign) bool recipientExpressed;

@property(assign) bool isCancellable;
@property(assign) bool isRemindable;
@property(assign) bool isRejectable;
@property(assign) bool isAcceptable;
@property(assign) bool isExpressable;

@property (nonatomic, retain) NSString* deliveryMethod;
@property (assign) double deliveryCharge;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
